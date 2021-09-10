" Create initial folders

if !isdirectory(stdpath('config') . '/autoload')
    call mkdir(stdpath('config'), 'p')
    call mkdir(stdpath('config') . '/autoload', 'p')
    call mkdir(stdpath('config') . '/backups', 'p')
    call mkdir(stdpath('config') . '/swap', 'p')
    call mkdir(stdpath('config') . '/undodir', 'p')
    :echom system('curl -fLo '.stdpath('config').'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
endif

" ---- vim-plug ----
call plug#begin(stdpath('config').'/plugged')
" My plugins here
"
Plug 'dense-analysis/ale'
Plug 'ajh17/VimCompletesMe'
Plug 'ntpeters/vim-better-whitespace'
Plug 'simrat39/symbols-outline.nvim'
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'scrooloose/nerdcommenter'
Plug 'mihaifm/bufstop'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/vim-vsnip'
Plug 'nathunsmitty/nvim-ale-diagnostic'
Plug 'folke/lsp-colors.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-bookmark.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-signify'
Plug 'itchyny/lightline.vim'
Plug 'ciaranm/securemodelines'
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'windwp/nvim-autopairs'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'
Plug 'nathanaelkane/vim-indent-guides', { 'on': 'IndentGuidesEnable' }
Plug 'ilyachur/cmake4vim'
Plug 'AndrewRadev/linediff.vim'
" color themes
Plug 'ajmwagar/vim-dues'
Plug 'audibleblink/hackthebox.vim'
Plug 'benburrill/potato-colors'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'chuling/equinusocio-material.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'embark-theme/vim', { 'as': 'embark' }
Plug 'flrnd/candid.vim'
Plug 'franbach/miramare'
Plug 'jsit/toast.vim'
Plug 'joshdick/onedark.vim'
Plug 'kaicataldo/material.vim'
Plug 'kinoute/vim-hivacruz-theme'
Plug 'lifepillar/vim-gruvbox8'
Plug 'mhartington/oceanic-next'
Plug 'owozsh/amora'
Plug 'raphamorim/lucario'
Plug 'ray-x/aurora'
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
set updatetime=100  " milliseconds, period of inactivity before writting to swap file
set nocursorline    " don´t highlight current line
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
set inccommand=split
set hlsearch        " highlight search matches
set noignorecase      " case sensitive searching ...
set smartcase       " ... except when using capital letters
set noinfercase     " ... and in keyword completion

" ---- Indentation and formating ----
set autoindent
filetype on
filetype indent on  " filetype specific indent rules
filetype plugin on
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
set backup                          " backup and location
let g:backupdir=expand(stdpath('config') . '/backups').',.'
let &backupdir=g:backupdir
:au FocusLost * silent! wa          " autosave when focus is lost
set undofile                        " infinite undo and location
let g:undodir=expand(stdpath('config') . '/undodir')
let &undodir=g:undodir
set viminfo+=!                      " the viminfo file stores the history of commands and so on
let g:swapdir=expand(stdpath('config') . '/swap')
let &directory=g:swapdir
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
if !empty($VIMCOLOR)
    let env_vim_color = $VIMCOLOR
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

" Abbreviation for make|copen
cabbrev mc :make<bar>copen<CR>

" ---- yaml settings ----
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab

" ---- netrw settings ----
let g:netrw_liststyle=3

" ---- groovy settings ---
autocmd FileType groovy setlocal makeprg=npm-groovy-lint\ --no-insight\ --noserver\ --files\ **/%:t
autocmd FileType Jenkinsfile setlocal makeprg=npm-groovy-lint\ --no-insight\ --noserver\ --files\ **/%:t

" ---- Plugins ----
let g:python_binary = 'python3'
if has('win32') || has('win64')
    py3 import os; sys.executable=os.path.join(sys.prefix, 'python.exe')
endif

" Additional configuration files
 for f in split(glob(stdpath('config').'/lua/*.*'), '\n')
     exe 'source' f
 endfor

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

" Plugin bufstop
map <F7> :BufstopFast<CR>
map <leader>b :Bufstop<CR>             " get a visual on the buffers
map <leader>w :BufstopPreview<CR>      " switch files by moving inside the window

" Plugin Mark
let g:mwDefaultHighlightingPalette = 'extended'

" Plugin ALE
let g:ale_linters = {
\   'python': ['pylint', 'flake8'],
\   'cpp': ['clang'],
\}
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['autopep8'],
    \ 'c': ['clang-format'],
    \ 'cpp': ['clang-format']}
let g:ale_completion_enabled = 0
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
" https://github.com/python-lsp/python-lsp-server/blob/develop/pylsp/config/schema.json
let g:ale_python_pyls_config = {'pylsp': {'plugins': {'pydocstyle': {'enabled': v:false},
         \                                            'pyflakes': {'enabled': v:true},
         \                                            'mccabe': {'enabled': v:true},
         \                                            'pycodestyle': {'enabled': v:true, 'maxLineLength': 250},
         \                                            'jedi_hover': {'enabled': v:true},
         \                                            'jedi_completion': {'enabled': v:true}}}}
" C++
let g:ale_cpp_clang_executable = 'clang++'
let g:ale_cpp_clang_options = '-Wall -Wextra -std=c++17'
" movement
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)
" status format
let g:ale_statusline_format = ['E:%d', 'W:%d', 'Ok']
" Copied from
" https://github.com/maximbaz/lightline-ale/blob/master/autoload/lightline/ale.vim
function! IsLinterAvailable() abort
  return get(g:, 'ale_enabled', 0) == 1
    \ && getbufvar(bufnr(''), 'ale_enabled', 1)
    \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
    \ && ale#engine#IsCheckingBuffer(bufnr('')) == 0
endfunction
" Function for ALE copied from the docs
function! LinterStatus() abort
    if !IsLinterAvailable()
        return ''
    endif
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
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ],
      \           ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'alestatus', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'alestatus': 'LinterStatus',
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

" Plugin vim-colorscheme-switcher
let g:colorscheme_switcher_define_mappings = 0
let g:colorscheme_switcher_exclude_builtins = 1
let g:colorscheme_switcher_exclude = ['solarized8_low', 'OceanicNextLight', 'onehalflight']

" Plugin vim-indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Plugin cmake4vim
let g:cmake_build_type = 'Debug'
let g:cmake_compile_commands = 1
let g:cmake_usr_args='-GNinja'

" Plugin fern
let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1
let g:fern#drawer_width = 40
nnoremap <silent> - :Fern . -drawer -reveal=%<CR>
autocmd FileType fern setlocal nonumber

function! s:init_fern() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> d <Plug>(fern-action-remove)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> M <Plug>(fern-action-rename)
  nmap <buffer> h <Plug>(fern-action-hidden-toggle)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> b <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> * <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)endfunction
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

" Plugin signify
let g:signify_sign_add               = '>+'
let g:signify_sign_delete            = '>-'
let g:signify_sign_delete_first_line = '>‾'
let g:signify_sign_change            = '>*'
let g:signify_sign_change_delete     = '>d'

" Plugin vista
let g:vista_sidebar_width=45
let g:vista_executive_for = {
  \ 'cpp': 'nvim_lsp',
  \ 'python': 'nvim_lsp',
  \ 'groovy': 'nvim_lsp',
  \ 'Jenkinsfile': 'nvim_lsp',
  \ }
let g:vista#renderer#enable_icon = 0
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_ignore_kinds = ["Variable"]

" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

" Color scheme settings
let g:gruvbox_filetype_hi_groups = 1
let g:gruvbox_plugin_hi_groups = 1
