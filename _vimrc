" Create initial folders

if !isdirectory($HOME.'/.vim')
    call mkdir($HOME.'/.vim', 'p')
    call mkdir($HOME.'/.vim/backups', 'p')
    call mkdir($HOME.'/.vim/swap', 'p')
    call mkdir($HOME.'/.vim/undodir', 'p')
    :echom system('git clone https://github.com/VundleVim/Vundle.vim.git '.$HOME.'/.vim/bundle/Vundle.vim')
endif
" ---- Windows ----
if has('win32') || has('win64')
    " use '.vim' instead of 'vimfiles'
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set shell=c:\windows\system32\cmd.exe   " shell
endif

" ---- Vundle ----
" Start vundle
filetype off                   " required!

set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'VundleVim/Vundle.vim'

" My Bundles here:
"
Plugin 'CharTab'
Plugin 'yegappan/mru'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'davidhalter/jedi-vim'
Plugin 'Rip-Rip/clang_complete'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'mattn/calendar-vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
" Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'tpope/vim-fugitive'
Plugin 'jiangmiao/auto-pairs'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'inkarkat/vim-mark'
" Games
Plugin 'johngrib/vim-game-snake'
Plugin 'vim-scripts/TeTrIs.vim'
Plugin 'johngrib/vim-game-code-break'
" For python
Plugin 'w0rp/ale'
Plugin 'Vimjas/vim-python-pep8-indent'
" color themes
Plugin 'Darkdevel'
Plugin 'earendel'
Plugin 'iceberg'
Plugin 'Lucius'
Plugin 'moria'
Plugin 'ajh17/Spacegray.vim'
Plugin 'ajmwagar/vim-dues'
Plugin 'alessandroyorba/alduin'
Plugin 'alessandroyorba/sierra'
Plugin 'altercation/vim-colors-solarized'
Plugin 'arcticicestudio/nord-vim'
Plugin 'ayu-theme/ayu-vim'
Plugin 'baines/vim-colorscheme-thaumaturge'
Plugin 'beigebrucewayne/hacked_ayu.vim'
Plugin 'danilo-augusto/vim-afterglow'
Plugin 'dikiaap/minimalist'
Plugin 'elmindreda/vimcolors'
Plugin 'exitface/synthwave.vim'
Plugin 'fneu/breezy'
Plugin 'hzchirs/vim-material'
Plugin 'jnurmine/Zenburn'
Plugin 'KabbAmine/yowish.vim'
Plugin 'lifepillar/vim-solarized8'
Plugin 'ltlollo/diokai'
Plugin 'lu-ren/SerialExperimentsLain'
Plugin 'mkarmona/colorsbox'
Plugin 'monkoose/boa.vim'
Plugin 'morhetz/gruvbox'
Plugin 'nightsense/carbonized'
Plugin 'nightsense/seabird'
Plugin 'nightsense/vim-crunchbang'
Plugin 'nightsense/willy'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'reewr/vim-monokai-phoenix'
Plugin 'rhysd/vim-color-spring-night'
Plugin 'roosta/vim-srcery'
Plugin 'sjl/badwolf'
Plugin 'sonobre/briofita_vim'
Plugin 'vim-scripts/mayansmoke'
Plugin 'vim-scripts/peaksea'
Plugin 'vim-scripts/Sift'
Plugin 'yuttie/hydrangea-vim'
Plugin 'zcodes/vim-colors-basic'
Plugin 'zeis/vim-kolor'

call vundle#end()            " required
filetype plugin indent on    " required
" Final vundle
"
set nocompatible
filetype on

" ---- Spaces and tabs ----
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" ---- UI Config ----
set title           " set the window title
set modeline
set showmode        " show the current mode
set showcmd         " show partial command in the last line of the screen
set cmdheight=2     " number of lines for the command-line
set history=50      " keep 50 lines of command line history
set wildmenu        " visual autocomplete for command menu
set wildignore=*.bak,*.o,*~,*.pyc,*.lib,*.swp
set wildmode=list:longest,full
set shortmess=at    " abbreviate messages (file names too long, etc)
set lazyredraw      " redraw only when it is needed
set updatetime=2000 " milliseconds, period of inactivity before writting to swap file
set cursorline      " highlight current line
set ruler           " show the cursor position all the time
set laststatus=2    " show always the status line
set visualbell      " no beeps, visual bell
set noerrorbells    " no flash/beep on errors
set encoding=utf8
set splitbelow      " horizontal splits below
set splitright      " vertical splits to the right
set clipboard=unnamed " use system clipboard
set timeoutlen=2000 " longer time to react to a control key
" status line
set statusline=%t       " tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}] " file format
set statusline+=%h      " help file flag
set statusline+=%m      " modified flag
set statusline+=%r      " read only flag
set statusline+=%y      " filetype
set statusline+=%=      " left/right separator
set statusline+=[%{ALEGetStatusLine()}]\  " ale status
set statusline+=C:%03c,\  " cursor column
set statusline+=L:%03l    " line
set statusline+=\ %P       " percent through file

" ---- Syntax highlighting ----
syntax enable
" python specific
let python_highlight_all=1
let python_slow_sync=1
let python_highlight_indent_errors=0

" ---- Searching ----
set incsearch       " do incremental searching
set hlsearch        " highlight search matches
set ignorecase      " case insensitive searching ...
set smartcase       " ... except when using capital letters

" ---- Indentation and formating ----
set autoindent
filetype indent on  " filetype specific indent rules
set cinkeys=0{,0},0),:,0#,!^F,o,O,e,;,.,-,*<Return>,;,=
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(s,us,U0,w0,m0,j0,)20,*30
set formatoptions=cqt
"set omnifunc=syntaxcomplete#Complete    " vim popup completion

" ---- Folding ----
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

" ---- Movement ----
" vertical movement with wrapped lines
nnoremap j gj
nnoremap k gk
" use C-E, C-Y also in insert mode
inoremap <C-E> <C-X><C-E>
inoremap <C-Y> <C-X><C-Y>
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" wrap lines only with arrow keys
set whichwrap=<,>,[,]
" to go through buffers
:map <F8> :bprevious<RETURN>
:map <F9> :bnext<RETURN>
" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" ---- Backups, autoread, autosave ----
set autoread                        " read a file automatically when it changes outside
set autowrite                       " write the contents of a file when moving to another buffer
set swapsync=""                     " to keep changes in the swap file more time in memory
set backup                          " backup and location
set backupdir=~/.vim/backups//,.
:au FocusLost * silent! wa          " autosave when focus is lost
set undofile                        " infinite undo and location
set undodir=~/.vim/undodir//
set viminfo+=!                      " the viminfo file stores the history of commands and so on
set directory=~/.vim/swap//
" go back to the previous position
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" ---- Colors ----
set background=dark
if ! has("gui_running")
    set t_Co=256
endif
if has("termguicolors")
    set termguicolors
    let &t_8f = "[38;2;%lu;%lu;%lum"
    let &t_8b = "[48;2;%lu;%lu;%lum"
endif

" Color scheme
:colo PaperColor

" ---- Extra functionallity ----
" to visualize manpages
:source $VIMRUNTIME/ftplugin/man.vim
:nmap K \K

" Protect large files from sourcing and other overhead. Files become read only
" http://vim.wikia.com/wiki/Faster_loading_of_large_files
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowrite (file is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 10
  augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
    augroup END
endif

" ---- Plugins ----

" Plugin calendar
let g:calendar_monday = 1
let g:calendar_mruler = 'Xan,Feb,Mar,Abr,Mai,Xuñ,Xul,Ago,Sep,Out,Nov,Dec'
let g:calendar_wruler = 'Do Lu Ma Me Xo Ve Sa'

" Plugin tagbar
nnoremap <silent> <F12> :TagbarToggle<CR>
let g:tagbar_left = 0
let g:tagbar_width = 45
let g:tagbar_expand = 0

" Plugin NERDTree
nnoremap <silent> <F11> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$', '\.bak'] "ignore files in NERDTree

" Plugin CtrlP
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" Plugin mru
highlight link MRUFileName LineNr
let MRU_Max_Menu_Entries = 20
let MRU_Max_Entries = 1000

" Plugin vim-mucomplete
set shortmess+=c
set belloff+=ctrlg
set noinfercase
set completeopt+=menuone,noinsert,noselect
" let g:clang_user_options = '-std=c99'
let g:clang_user_options = '-std=c++11'
let g:clang_complete_auto = 1
let g:clang_library_path = 'd:\Program Files\LLVM\bin\libclang.dll'
let g:mucomplete#enable_auto_at_startup = 1
inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")

" Plugin jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#use_splits_not_buffers = "bottom"
let g:jedi#show_call_signatures = "0"

" Plugin vim-fugitive
" run with AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Plugin NERDCommenter
" add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Plugin ale
let g:ale_linters = {
\   'python': ['pylint', 'flake8'],
\   'cpp': ['cppcheck', 'clang'],
\}
let g:python_max_len = 120
" when to lint
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 500
let g:ale_lint_on_enter = 1
let g:ale_sign_column_always = 0
" list
let g:ale_open_list = 0
" python
let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_args = '-m flake8 --max-line-length='.g:python_max_len
let g:ale_python_pylint_executable = g:ale_python_flake8_executable
let g:ale_python_pylint_options = '-m pylint'
" movement
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)
" status format
let g:ale_statusline_format = ['E:%d', 'W:%d', 'Ok']

" Plugin bufexplorer
nmap <F2> \be

" Plugin auto-pairs
au Filetype cpp let g:AutoPairsMapCR = 0
let g:AutoPairsShortcutFastWrap = '<C-Right>'

" Plugin MARK
let g:mwDefaultHighlightingPalette = 'extended'
