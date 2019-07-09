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
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mattn/calendar-vim', { 'on': ['Calendar', 'CalendarH', 'CalendarT', 'CalendarVR'] }
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-fugitive'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'yegappan/grep'
Plug 'itchyny/lightline.vim'
Plug 'ciaranm/securemodelines'
Plug 'sheerun/vim-polyglot'
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
Plug 'danilo-augusto/vim-afterglow'
Plug 'fneu/breezy'
Plug 'hzchirs/vim-material'
Plug 'jnurmine/Zenburn'
Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'
Plug 'lmintmate/blue-mood-vim'
Plug 'lu-ren/SerialExperimentsLain'
Plug 'mkarmona/colorsbox'
Plug 'nightsense/seagrey'
Plug 'nightsense/willy'
Plug 'NLKNguyen/papercolor-theme'
Plug 'reewr/vim-monokai-phoenix'
Plug 'rhysd/vim-color-spring-night'
Plug 'roosta/vim-srcery'
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

" ---- Auto close parentheses
inoremap ( ()<Left>
inoremap <expr> ) getline('.')[getpos('.')[2] - 1] == ')' ? '<Right>' : ')'
inoremap { {}<Left>
inoremap <expr> } getline('.')[getpos('.')[2] - 1] == '}' ? '<Right>' : '}'
inoremap [ []<Left>
inoremap <expr> ] getline('.')[getpos('.')[2] - 1] == ']' ? '<Right>' : ']'
inoremap <expr> " getline('.')[getpos('.')[2] - 1] == '"' ? '<Right>' : '""<Left>'
inoremap <expr> ' getline('.')[getpos('.')[2] - 1] == "'" ? '<Right>' : "''<Left>"

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
" with cursorline highlight just the number
au ColorScheme * highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
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

" Plugin NERDTree
nnoremap <silent> <F11> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$', '\.bak'] "ignore files in NERDTree

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

" Plugin lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'lsp_diagnostics', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'lsp_diagnostics': 'ShowDiagnosticsCount'
      \ },
      \ }

" Plugin vim-lsp
" Function for showing diagnostics copied from ALE
function! ShowDiagnosticsCount() abort
    let l:counts = lsp#get_buffer_diagnostics_counts()

    return l:counts.error + l:counts.warning + l:counts.information + l:counts.hint == 0 ? '[Ok]' : printf(
    \   '[E:%d, W:%d, I:%d, H:%d]',
    \   l:counts["error"],
    \   l:counts["warning"],
    \   l:counts["information"],
    \   l:counts["hint"],
    \)
endfunction

let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_signs_error = {'text': 'e'}
let g:lsp_signs_warning = {'text': 'w'}
let g:lsp_signs_hint = {'text': '*'}
let g:lsp_signs_information = {'text': 'i'}
let g:lsp_textprop_enabled = 0 " only on debian

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp'],
        \ })
elseif executable('ccls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': {'cache': {'directory': '.ccls_cache' }},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
elseif executable('cquery')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'cquery',
          \ 'cmd': {server_info->['cquery']},
          \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
          \ 'initialization_options': { 'cacheDirectory': '.cquery_cache' },
          \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
          \ })
endif

if executable('pyls')
    " All settings: https://github.com/palantir/python-language-server/blob/develop/vscode-client/package.json
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:false},
        \                                           'pyflakes': {'enabled': v:true},
        \                                           'mccabe': {'enabled': v:true},
        \                                           'pycodestyle': {'enabled': v:true, 'maxLineLength': 250},
        \                                           'jedi_hover': {'enabled': v:true},
        \                                           'jedi_completion': {'enabled': v:true}}}},
        \ })
endif

" Plugin asyncomplete
set completeopt+=preview
set belloff+=ctrlg
set shortmess+=c
let g:asyncomplete_auto_popup = 1

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction
"
" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ asyncomplete#force_refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor')
    \ }))
