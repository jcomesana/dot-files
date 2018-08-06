" Create initial folders

if !isdirectory($HOME.'/.vim')
    call mkdir($HOME.'/.vim', 'p')
    call mkdir($HOME.'/.vim/autoload', 'p')
    call mkdir($HOME.'/.vim/backups', 'p')
    call mkdir($HOME.'/.vim/swap', 'p')
    call mkdir($HOME.'/.vim/undodir', 'p')
    :echom system('curl -fLo '.$HOME.'/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
endif
" ---- Windows ----
if has('win32') || has('win64')
    " use '.vim' instead of 'vimfiles'
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set shell=c:\windows\system32\cmd.exe   " shell
endif

" ---- vim-plug ----
call plug#begin('~/.vim/plugged')
" My plugins here
"
Plug 'vim-scripts/CharTab'
Plug 'yegappan/mru'
Plug 'lifepillar/vim-mucomplete'
Plug 'Rip-Rip/clang_complete'
Plug 'davidhalter/jedi-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mattn/calendar-vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'skywind3000/asyncrun.vim'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'yegappan/grep'
Plug 'itchyny/lightline.vim'
" Games
Plug 'johngrib/vim-game-snake'
Plug 'vim-scripts/TeTrIs.vim'
Plug 'johngrib/vim-game-code-break'
" For python
Plug 'w0rp/ale'
Plug 'Vimjas/vim-python-pep8-indent'
" color themes
Plug 'vim-scripts/Darkdevel'
Plug 'vim-scripts/earendel'
Plug 'vim-scripts/Lucius'
Plug 'vim-scripts/moria'
Plug 'ajh17/Spacegray.vim'
Plug 'ajmwagar/vim-dues'
Plug 'alessandroyorba/alduin'
Plug 'alessandroyorba/sierra'
Plug 'altercation/vim-colors-solarized'
Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'Badacadabra/vim-archery'
Plug 'baines/vim-colorscheme-thaumaturge'
Plug 'cocopon/iceberg.vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'dikiaap/minimalist'
Plug 'elmindreda/vimcolors'
Plug 'exitface/synthwave.vim'
Plug 'fneu/breezy'
Plug 'hzchirs/vim-material'
Plug 'jnurmine/Zenburn'
Plug 'KabbAmine/yowish.vim'
Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'
Plug 'lmintmate/blue-mood-vim'
Plug 'ltlollo/diokai'
Plug 'lu-ren/SerialExperimentsLain'
Plug 'mkarmona/colorsbox'
Plug 'monkoose/boa.vim'
Plug 'morhetz/gruvbox'
Plug 'nightsense/carbonized'
Plug 'nightsense/nemo'
Plug 'nightsense/office'
Plug 'nightsense/seabird'
Plug 'nightsense/seagrey'
Plug 'nightsense/stellarized'
Plug 'nightsense/vim-crunchbang'
Plug 'nightsense/willy'
Plug 'NLKNguyen/papercolor-theme'
Plug 'reewr/vim-monokai-phoenix'
Plug 'rhysd/vim-color-spring-night'
Plug 'romainl/flattened'
Plug 'roosta/vim-srcery'
Plug 'schickele/vim'
Plug 'Siphalor/vim-atomified'
Plug 'sjl/badwolf'
Plug 'skreek/skeletor.vim'
Plug 'sonobre/briofita_vim'
Plug 'vim-scripts/mayansmoke'
Plug 'vim-scripts/peaksea'
Plug 'vim-scripts/Sift'
Plug 'yuttie/hydrangea-vim'
Plug 'zcodes/vim-colors-basic'
Plug 'zeis/vim-kolor'

call plug#end()
" ---- End vim-plug ---

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
set noshowmode        " mode handled by lightline
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
" Function for ALE copied from the docs
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '[Ok]' : printf(
    \   '[E:%d, W:%d]',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
"set statusline=%t       " tail of the filename
"set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
"set statusline+=%{&ff}] " file format
"set statusline+=%h      " help file flag
"set statusline+=%m      " modified flag
"set statusline+=%r      " read only flag
"set statusline+=%y      " filetype
"set statusline+=%=      " left/right separator
"set statusline+=%{LinterStatus()}
"set statusline+=C:%03c,\  " cursor column
"set statusline+=L:%03l    " line
"set statusline+=\ %P       " percent through file

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
if !empty($VIMCOLOR)
    let env_vim_color = $VIMCOLOR
else
    let env_vim_color = 'darkblue'
endif
execute 'colorscheme '.env_vim_color

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
let g:python_binary = 'python3'

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

" Plugin mru
highlight link MRUFileName LineNr
let MRU_Max_Menu_Entries = 20
let MRU_Max_Entries = 1000

" Plugin vim-mucomplete
set completeopt+=menuone
set completeopt+=noselect
set completeopt+=noinsert
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion
let g:mucomplete#enable_auto_at_startup = 1

" Plugin clang_complete
if has('win32') || has('win64')
    let g:clang_library_path = 'd:\Program Files\LLVM\bin\libclang.dll'
elseif filereadable('/usr/lib/x86_64-linux-gnu/libclang-6.0.so')
    let g:clang_library_path = '/usr/lib/x86_64-linux-gnu/libclang-6.0.so'
else
    let g:clang_library_path = '/usr/lib/arm-linux-gnueabihf/libclang-6.0.so.1'
endif
let g:clang_user_options = '-std=c++17'
let g:clang_complete_auto = 1

" Plugin jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#use_splits_not_buffers = "bottom"
let g:jedi#show_call_signatures = "0"
let g:pymode_rope = 1

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
\   'cpp': ['clang'],
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
let g:ale_python_flake8_executable = g:python_binary
let g:ale_python_flake8_options = '-m flake8 --max-line-length='.g:python_max_len
let g:ale_python_pylint_executable = g:ale_python_flake8_executable
let g:ale_python_pylint_options = '-m pylint'
let g:ale_python_mypy_options = '--ignore-missing-imports'
" C++
let g:ale_cpp_clang_executable = 'clang++-6.0'
let g:ale_cpp_clang_options = '-Wall -Wextra -std=c++1z'
" movement
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)
" status format
let g:ale_statusline_format = ['E:%d', 'W:%d', 'Ok']

" Plugin bufexplorer
nmap <F2> \be

" Plugin auto-pairs
let g:AutoPairsShortcutFastWrap = '<C-Right>'
" au Filetype cpp let g:AutoPairsMapCR = 0
" suggested mucomplete config to avoid conflicts with auto-pairs
let g:AutoPairsMapSpace = 0
imap <silent> <expr> <space> pumvisible()
    \ ? "<space>"
    \ : "<c-r>=AutoPairsSpace()<cr>"

" Plugin Mark
let g:mwDefaultHighlightingPalette = 'extended'

" Plugin lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'alestatus', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'alestatus': 'LinterStatus'
      \ },
      \ }
