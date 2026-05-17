#!/usr/bin/env bash
# =============================================================================
# screen-orientation.sh — Read and change screen orientation in KDE Plasma
# Works on both X11 and Wayland (via kscreen-doctor)
# =============================================================================

set -euo pipefail

ORIENTATIONS=("normal" "left" "right" "inverted")

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -l, --list            List all connected outputs
  -g, --get [OUTPUT]    Get current orientation (all outputs, or a specific one)
  -s, --set OUTPUT ORI  Set orientation for OUTPUT
                        ORI: normal | left | right | inverted
  -h, --help            Show this help

Examples:
  $(basename "$0") --list
  $(basename "$0") --get
  $(basename "$0") --get HDMI-1
  $(basename "$0") --set HDMI-1 left
  $(basename "$0") --set eDP-1 normal
EOF
}

# -----------------------------------------------------------------------------
# Detect backend: prefer kscreen-doctor (works on Wayland + X11), fall back to xrandr
# -----------------------------------------------------------------------------
detect_backend() {
    if command -v kscreen-doctor &>/dev/null; then
        echo "kscreen-doctor"
    elif command -v xrandr &>/dev/null; then
        echo "xrandr"
    else
        echo "none"
    fi
}

# -----------------------------------------------------------------------------
# kscreen-doctor helpers
# -----------------------------------------------------------------------------
#

kscreen_list() {
    echo "=== Connected outputs (kscreen-doctor) ==="
    kscreen-doctor -j | jq -r ".outputs[] | \"name: \(.name), connected: \(.connected), enabled: \(.enabled), rotation: \(.rotation)\""
}

kscreen_get() {
    local target="${1:-}"
    echo "=== Current orientation (kscreen-doctor) ==="
    if [[ -z "$target" ]]; then
        kscreen-doctor -j | jq -r ".outputs[] | \"name: \(.name), rotation: \(.rotation)\""
    else
        kscreen-doctor -j | jq -r ".outputs[] | select(.name == \"$target\") | \"name: \(.name), rotation: \(.rotation)\""
    fi
}

kscreen_set() {
    local output="$1"
    local orientation="$2"

    validate_orientation "$orientation"
    kscreen-doctor "output.$output.rotation.$orientation"
}

# -----------------------------------------------------------------------------
# xrandr helpers (X11 fallback)
# -----------------------------------------------------------------------------
xrandr_list() {
    echo "=== Connected outputs (xrandr) ==="
    xrandr --query | awk '/connected/ {print "  " $0}'
}

xrandr_get() {
    local target="${1:-}"
    echo "=== Current orientation (xrandr) ==="
    xrandr --query --verbose | awk -v tgt="$target" '
        /^[A-Za-z].*connected/ {
            name = $1
        }
        /^\s+[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/ && name != "" {
            # Rotation is printed after the resolution on the same line
            if (tgt == "" || tgt == name) {
                rot = "normal"
                if ($0 ~ / left /)     rot = "left"
                if ($0 ~ / right /)    rot = "right"
                if ($0 ~ / inverted /) rot = "inverted"
                printf "  %-20s %s\n", name, rot
            }
            name = ""
        }
    '
}

xrandr_set() {
    local output="$1"
    local orientation="$2"

    validate_orientation "$orientation"

    echo "Setting '$output' to '$orientation' via xrandr..."
    xrandr --output "$output" --rotate "$orientation"
    echo "Done."
}

# -----------------------------------------------------------------------------
# Shared helpers
# -----------------------------------------------------------------------------
validate_orientation() {
    local ori="$1"
    for valid in "${ORIENTATIONS[@]}"; do
        [[ "$ori" == "$valid" ]] && return 0
    done
    echo "Error: invalid orientation '$ori'. Choose: ${ORIENTATIONS[*]}" >&2
    exit 1
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
BACKEND=$(detect_backend)

if [[ "$BACKEND" == "none" ]]; then
    echo "Error: neither 'kscreen-doctor' nor 'xrandr' found." >&2
    echo "Install kscreen (KDE) or xrandr (X11): sudo apt install kscreen x11-xserver-utils" >&2
    exit 1
fi

echo "Backend: $BACKEND"
echo ""

if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi

ACTION=""
OUTPUT_NAME=""
ORIENTATION_VAL=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--list)
            ACTION="list"
            shift ;;
        -g|--get)
            ACTION="get"
            if [[ $# -gt 1 && ! "$2" =~ ^- ]]; then
                OUTPUT_NAME="$2"
                shift
            fi
            shift ;;
        -s|--set)
            ACTION="set"
            if [[ $# -lt 3 ]]; then
                echo "Error: --set requires OUTPUT and ORIENTATION" >&2
                usage; exit 1
            fi
            OUTPUT_NAME="$2"
            ORIENTATION_VAL="$3"
            shift 3 ;;
        -h|--help)
            usage; exit 0 ;;
        *)
            echo "Unknown option: $1" >&2
            usage; exit 1 ;;
    esac
done

case "$ACTION" in
    list)
        [[ "$BACKEND" == "kscreen-doctor" ]] && kscreen_list || xrandr_list ;;
    get)
        [[ "$BACKEND" == "kscreen-doctor" ]] && kscreen_get "$OUTPUT_NAME" || xrandr_get "$OUTPUT_NAME" ;;
    set)
        [[ "$BACKEND" == "kscreen-doctor" ]] && kscreen_set "$OUTPUT_NAME" "$ORIENTATION_VAL" \
                                              || xrandr_set "$OUTPUT_NAME" "$ORIENTATION_VAL" ;;
    *)
        usage; exit 1 ;;
esac
