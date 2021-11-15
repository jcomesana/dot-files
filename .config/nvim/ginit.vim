" Enable Mouse
set mouse=a
set mousehide

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    if !empty($NVIM_GUI_FONT)
        execute 'GuiFont! ' . $NVIM_GUI_FONT
    else
        GuiFont! Iosevka Medium:h10
    endif
endif

" Enable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 1
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Try to use nvim theme in the GUI
if exists(':GuiAdaptativeColor')
    GuiAdaptativeColor 1
endif

" Try to render font ligatures
if exists(':GuiRenderLigatures')
    GuiRenderLigatures 1
endif
