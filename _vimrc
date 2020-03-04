" Create initial folders
if has('nvim')
    " let s:editor_root=expand("~/.config/nvim")
    let s:editor_root=expand("~/.vim")
else
    let s:editor_root=expand("~/.vim")
endif

if !isdirectory(s:editor_root . '/autoload')
    call mkdir(s:editor_root, 'p')
    call mkdir(s:editor_root . '/autoload', 'p')
    call mkdir(s:editor_root . '/backups', 'p')
    call mkdir(s:editor_root . '/swap', 'p')
    call mkdir(s:editor_root . '/undodir', 'p')
    :echom system('curl -fLo '.s:editor_root.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'))
endif
if has('win32') || has('win64') || has('nvim')
    let &rtp = &rtp . ',' . s:editor_root . ',' . s:editor_root.'/after'
endif
" ---- Windows ----
if (has('win32') || has('win64')) && !has('nvim')
    set shell=c:\windows\system32\cmd.exe   " shell
endif

" ---- vim-plug ----
call plug#begin(s:editor_root.'/plugged')
" My plugins here
"
Plug 'vim-scripts/CharTab'
Plug 'yegappan/mru'
Plug 'w0rp/ale'
Plug 'ajh17/VimCompletesMe'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'mattn/calendar-vim', { 'on': ['Calendar', 'CalendarH', 'CalendarT', 'CalendarVR'] }
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'ciaranm/securemodelines'
Plug 'sheerun/vim-polyglot'
Plug 'tmsvg/pear-tree'
" For python
Plug 'Vimjas/vim-python-pep8-indent'
" color themes
Plug 'vim-scripts/earendel'
Plug 'vim-scripts/moria'
Plug 'ajmwagar/vim-dues'
Plug 'alessandroyorba/alduin'
Plug 'alessandroyorba/sierra'
Plug 'altercation/vim-colors-solarized'
Plug 'ayu-theme/ayu-vim'
Plug 'benburrill/potato-colors'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'danilo-augusto/vim-afterglow'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'fneu/breezy'
Plug 'flrnd/candid.vim'
Plug 'hzchirs/vim-material'
Plug 'jnurmine/Zenburn'
Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'
Plug 'lmintmate/blue-mood-vim'
Plug 'lu-ren/SerialExperimentsLain'
Plug 'mkarmona/colorsbox'
Plug 'nightsense/seagrey'
Plug 'NLKNguyen/papercolor-theme'
Plug 'reewr/vim-monokai-phoenix'
Plug 'rhysd/vim-color-spring-night'
Plug 'roosta/vim-srcery'
Plug 'sainnhe/edge'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/vim-color-forest-night'
Plug 'schickele/vim'
Plug 'skreek/skeletor.vim'
Plug 'sonobre/briofita_vim'
Plug 'szorfein/fromthehell.vim'
Plug 'tjammer/blayu.vim'
Plug 'vim-scripts/mayansmoke'
Plug 'vim-scripts/Sift'
Plug 'yuttie/hydrangea-vim'
Plug 'zcodes/vim-colors-basic'

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
set number
set signcolumn=yes
set noshowmode      " mode handled by lightline
set showcmd         " show partial command in the last line of the screen
set cmdheight=2     " number of lines for the command-line
set history=50      " keep 50 lines of command line history
set wildmenu        " visual autocomplete for command menu
set wildignore=*.bak,*.o,*~,*.pyc,*.lib,*.swp
set wildmode=list:longest,full
set shortmess=at    " abbreviate messages (file names too long, etc)
set lazyredraw      " redraw only when it is needed
set updatetime=1000 " milliseconds, period of inactivity before writting to swap file
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
set noignorecase      " case sensitive searching ...
set smartcase       " ... except when using capital letters
set noinfercase     " ... and in keyword completion

" ---- Indentation and formating ----
set autoindent
filetype indent on  " filetype specific indent rules
set cinkeys=0{,0},0),:,0#,!^F,o,O,e,;,.,-,*<Return>,;,=
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(s,us,U0,w0,m0,j0,)20,*30
set formatoptions=cqt

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
" and ignore qf
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" ---- Completion options ----
set completeopt+=menuone
set completeopt+=noinsert
set completeopt+=noselect
set shortmess+=c    " Shut off completion messages
set belloff+=ctrlg  " If Vim beeps during completion

" ---- Backups, autoread, autosave ----
set autoread                        " read a file automatically when it changes outside
set autowrite                       " write the contents of a file when moving to another buffer
if !has('nvim')
set swapsync=""                     " to keep changes in the swap file more time in memory
endif
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
" with cursorline highlight just the number
" au ColorScheme * highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
if !has('nvim') && !empty($VIMCOLOR)
    let env_vim_color = $VIMCOLOR
elseif has('nvim') && !empty($NVIMCOLOR)
    let env_vim_color = $NVIMCOLOR
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
" file is large from 10mb
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
    au!
    autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function! LargeFile()
    " no syntax highlighting etc
    set eventignore+=FileType
    " save memory when other file is viewed
    setlocal bufhidden=unload
    " is read-only (write with :w new_filename)
    setlocal buftype=nowrite
    " no undo possible
    setlocal undolevels=-1
    setlocal noundofile
    " disable swap file
    setlocal noswapfile
    " disable asyncomplete
    let b:asyncomplete_enable = 2
    " display message
    autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

" ---- yaml settings ----
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab

" ---- netrw settings ----
let g:netrw_liststyle=3

" ---- Plugins ----
let g:python_binary = 'python3'
if has('win32') || has('win64')
    py3 import os; sys.executable=os.path.join(sys.prefix, 'python.exe')
endif

" Plugin calendar
let g:calendar_monday = 1
let g:calendar_mruler = 'Xan,Feb,Mar,Abr,Mai,Xuñ,Xul,Ago,Sep,Out,Nov,Dec'
let g:calendar_wruler = 'Do Lu Ma Me Xo Ve Sa'

" Plugin tagbar
nnoremap <silent> <F12> :TagbarToggle<CR>
let g:tagbar_left = 0
let g:tagbar_width = 45
let g:tagbar_expand = 0

" Plugin mru
highlight link MRUFileName LineNr
let MRU_Max_Menu_Entries = 20
let MRU_Max_Entries = 1000

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

" Plugin bufexplorer
nmap <F7> \be

" Plugin Mark
let g:mwDefaultHighlightingPalette = 'extended'

" Plugin ale
let g:ale_linters = {
\   'python': ['pylint', 'flake8'],
\   'cpp': ['clang'],
\}
let g:ale_completion_enabled = 1
let g:ale_set_balloons = 1
let g:ale_set_highlights =1
let g:ale_set_signs = 1
let g:python_max_len = 200
" when to lint
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 500
let g:ale_lint_on_enter = 1
let g:ale_sign_column_always = 0
" list
let g:ale_open_list = 0
" python
let g:ale_python_flake8_executable = g:python_binary
let g:ale_python_flake8_options = '-m flake8 --max-line-length='.g:python_max_len
let g:ale_python_pylint_executable = g:python_binary
let g:ale_python_pylint_options = '-m pylint'
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_python_pyls_use_global = 1
" https://github.com/palantir/python-language-server/blob/develop/vscode-client/package.json
let g:ale_python_pyls_config = {'pyls': {'plugins': {'pydocstyle': {'enabled': v:false},
         \                                           'pyflakes': {'enabled': v:true},
         \                                           'mccabe': {'enabled': v:true},
         \                                           'pycodestyle': {'enabled': v:true, 'maxLineLength': 250},
         \                                           'jedi_hover': {'enabled': v:true},
         \                                           'jedi_completion': {'enabled': v:true}}}}
" C++
let g:ale_cpp_clang_executable = 'clang++-9'
let g:ale_cpp_clang_options = '-Wall -Wextra -std=c++17'
" movement
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)
" status format
let g:ale_statusline_format = ['E:%d', 'W:%d', 'Ok']
" Function for ALE copied from the docs
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_warnings = l:counts.warning + l:counts.style_warning

    return l:counts.total == 0 ? '[Ok]' : printf(
    \   '[E:%d, W:%d, I:%d]',
    \   all_errors,
    \   all_warnings,
    \   l:counts.info
    \)
endfunction

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
      \ 'component': {
      \   'lineinfo': '%4l:%-3v',
      \ },
      \ 'colorscheme': env_vim_color,
      \ }

" Plugin LanguageClient-neovim
set hidden " Required for operations modifying multiple buffers like rename.

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'c': ['ccls'],
    \ 'cpp': ['ccls'],
    \ 'objc': ['ccls']
    \ }
let g:LanguageClient_diagnosticsEnable = 1
let g:LanguageClient_diagnosticsDisplay = {
      \ 1: {
      \     "name": "Error",
      \     "texthl": "ALEError",
      \     "signText": "e",
      \     "signTexthl": "ALEErrorSign",
      \     "virtualTexthl": "Error",
      \ },
      \ 2: {
      \     "name": "Warning",
      \     "texthl": "ALEWarning",
      \     "signText": "w",
      \     "signTexthl": "ALEWarningSign",
      \     "virtualTexthl": "Todo",
      \ },
      \ 3: {
      \     "name": "Information",
      \     "texthl": "ALEInfo",
      \     "signText": "i",
      \     "signTexthl": "ALEInfoSign",
      \     "virtualTexthl": "Todo",
      \ },
      \ 4: {
      \     "name": "Hint",
      \     "texthl": "ALEInfo",
      \     "signText": "?",
      \     "signTexthl": "ALEInfoSign",
      \     "virtualTexthl": "Todo",
      \ },
\ }

let g:LanguageClient_diagnosticsList = "Location"

" mappings
function SetLSPShortcuts()
  nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType cpp,c,python call SetLSPShortcuts()
augroup END

" language server settings
" pyls https://github.com/palantir/python-language-server/blob/develop/vscode-client/package.json
au! BufNewFile,BufReadPost *.{py} let g:LanguageClient_settingsPath=expand("~/.vim/pyls_settings.json")


" Plugin deoplete
let g:deoplete#enable_at_startup = 1

" Plugin pear-tree
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
