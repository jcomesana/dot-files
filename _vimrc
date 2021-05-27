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
    :echom system('curl -fLo '.s:editor_root.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
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
Plug 'dense-analysis/ale'
Plug 'ajh17/VimCompletesMe'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'liuchengxu/vista.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'jlanzarotta/bufexplorer'
" Plug 'jmckiern/vim-shoot', { 'do': '\"./install.py\" geckodriver' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'ciaranm/securemodelines'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'
Plug 'nathanaelkane/vim-indent-guides'
" For python
Plug 'Vimjas/vim-python-pep8-indent'
" color themes
Plug 'ajmwagar/vim-dues'
Plug 'benburrill/potato-colors'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'chuling/equinusocio-material.vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'embark-theme/vim', { 'as': 'embark' }
Plug 'flrnd/candid.vim'
Plug 'franbach/miramare'
Plug 'itchyny/landscape.vim'
Plug 'jacoborus/tender.vim'
Plug 'jsit/toast.vim'
Plug 'joshdick/onedark.vim'
Plug 'kaicataldo/material.vim'
Plug 'kinoute/vim-hivacruz-theme'
Plug 'lifepillar/vim-gruvbox8'
Plug 'lmintmate/blue-mood-vim'
Plug 'mhartington/oceanic-next'
Plug 'owozsh/amora'
Plug 'raphamorim/lucario'
Plug 'ray-x/aurora'
Plug 'reewr/vim-monokai-phoenix'
Plug 'romgrk/doom-one.vim'
Plug 'sainnhe/edge'
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'srcery-colors/srcery-vim'

call plug#end()
" ---- End vim-plug ---

set nocompatible
filetype on

" ---- Spaces and tabs ----
set tabstop=4
set softtabstop=4

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
" map space to sync the syntax hilighting on normal mode
noremap <silent> <Space> :silent noh <Bar>echo<cr>:syn sync fromstart<cr>

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
let env_vim_color = ''
if !has('nvim') && !empty($VIMCOLOR)
    let env_vim_color = $VIMCOLOR
elseif has('nvim') && !empty($NVIMCOLOR)
    let env_vim_color = $NVIMCOLOR
endif

if !empty(env_vim_color)
    execute 'colorscheme '.env_vim_color
else
    autocmd VimEnter * RandomColorScheme
endif

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
let g:ale_set_highlights = 1
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
      \ }

function! s:lightline_colorschemes() abort
    return map(globpath(&rtp,"autoload/lightline/colorscheme/*.vim",1,1), "fnamemodify(v:val,':t:r')")
endfunction

function! s:lightline_update()
    try
        let l:lightline_colorschemes_list = s:lightline_colorschemes()
        let l:lightline_cs = substitute(g:colors_name, '-', '_', 'g')
        if index(l:lightline_colorschemes_list, l:lightline_cs) == -1
            let l:lightline_cs = "default"
        endif
        let g:lightline.colorscheme = l:lightline_cs
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
    catch
    endtry
endfunction

augroup LightlineColorscheme
    autocmd!
    autocmd ColorScheme * call s:lightline_update()
augroup END
call s:lightline_update()

" Plugin asyncomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

" auto_popup
let g:asyncomplete_auto_popup = 0
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" preview window
" allow modifying the completeopt variable, or it will
" be overridden all the time
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Plugin vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_signs_error = {'text': 'e'}
let g:lsp_signs_warning = {'text': 'w'}
let g:lsp_signs_hint = {'text': '*'}
let g:lsp_signs_information = {'text': 'i'}

" Plugin asyncomplete-lsp.vim
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" Plugin asyncomplete-buffer.vim
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

" Plugin asyncomplete-file.vim
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

" Plugin auto-pairs
let g:AutoPairsShortcutFastWrap = '<C-Right>'
let g:AutoPairsMapSpace = 0
" au Filetype cpp let g:AutoPairsMapCR = 0

" Plugin vim-colorscheme-switcher
let g:colorscheme_switcher_define_mappings = 0
let g:colorscheme_switcher_exclude_builtins = 1
:let g:colorscheme_switcher_exclude = ['solarized8_low', 'OceanicNextLight']

" Plugin vista
nnoremap <silent> <F12> :Vista!!<CR>
let g:vista_sidebar_width=45
let g:vista_executive_for = {
  \ 'cpp': 'vim_lsp',
  \ 'python': 'vim_lsp',
  \ }
let g:vista#renderer#enable_icon = 0
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_ignore_kinds = ["Variable"]

" Plugin vim-indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Color scheme settings
let g:gruvbox_filetype_hi_groups = 1
let g:gruvbox_plugin_hi_groups = 1
