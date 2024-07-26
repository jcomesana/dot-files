" Enable Mouse
set mouse=a
set mousehide

" Try to render font ligatures
if exists(':GuiRenderLigatures')
    GuiRenderLigatures 0
endif

" Override the default Qt Style/Theme
if exists(':GuiAdaptiveStyle')
    GuiAdaptiveStyle Fusion
endif

" Try to use nvim theme in the GUI
if exists(':GuiAdaptiveColor')
    GuiAdaptiveColor 1
endif

" Use the current `GuiFont` to decorate the GUI
if exists(':GuiAdaptiveFont')
    GuiAdaptiveFont 1
endif

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    if !empty($NVIM_GUI_FONT)
        execute 'GuiFont! ' . $NVIM_GUI_FONT
    else
        if has('win32')
            GuiFont! CaskaydiaCove Nerd Font:h10
        elseif has('macunix')
            GuiFont! CaskaydiaCove Nerd Font:h12
            GuiLinespace -2
        else
            GuiFont! CaskaydiaCove Nerd Font:h10
            GuiLinespace -2
        endif
    endif
endif

" Enable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Settings for fvim
if exists('g:fvim_loaded')
    if g:fvim_os == 'windows' || g:fvim_render_scale > 1.0
        set guifont=Iosevka\ SS04:h12
    else
        set guifont=Iosevka\ SS04:h13
    endif

    " Title bar tweaks
    FVimCustomTitleBar v:true

    " Font tweaks
    FVimFontAntialias v:true
    FVimFontAutohint v:true
    FVimFontHintLevel 'full'
    FVimFontLigature v:true
    FVimFontSubpixel v:true
    FVimFontLineHeight '+2.0'

    " Try to snap the fonts to the pixels, reduces blur
    " in some situations (e.g. 100% DPI).
    FVimFontAutoSnap v:true

    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
endif

" Settings for neovide
if exists("g:neovide")
    if has('win32')
        set guifont=CaskaydiaCove\ Nerd\ Font:h8
    elseif has('macunix')
        set guifont=CaskaydiaCove\ Nerd\ Font:h12
    else
        set guifont=CaskaydiaCove\ Nerd\ Font:h10
    endif
    let g:neovide_hide_mouse_when_typing = v:true
    let g:neovide_cursor_animation_length = 0.10
    let g:neovide_cursor_trail_size = 0.5
endif
