set nocompatible

" Create initial folders
let s:editor_root=stdpath('config')
let s:autoloaddir=s:editor_root . '/autoload'
let s:backupdir=s:editor_root . '/backups'
let s:undodir=s:editor_root . '/undodir'
let s:swapdir=s:editor_root . '/swap'

if empty(glob(s:autoloaddir . '/plug.vim'))
    call mkdir(s:editor_root, 'p')
    call mkdir(s:autoloaddir, 'p')
    call mkdir(s:backupdir, 'p')
    call mkdir(s:swapdir, 'p')
    call mkdir(s:undodir, 'p')
    :echom system('curl -fLo '.s:autoloaddir.'/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Folders
let &backupdir=s:backupdir
let &undodir=s:undodir
let &directory=s:swapdir
set backup                          " backup and location
set undofile                        " infinite undo and location

" ---- vim-plug ----
call plug#begin(s:editor_root.'/plugged')
" My plugins here
"
Plug 'lewis6991/impatient.nvim'
Plug 'dense-analysis/ale'
Plug 'ajh17/VimCompletesMe'
Plug 'ntpeters/vim-better-whitespace'
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'scrooloose/nerdcommenter'
Plug 'mihaifm/bufstop', { 'on': ['BufstopFast', 'BufstopPreview', 'Bufstop'] }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/vim-vsnip'
Plug 'nathunsmitty/nvim-ale-diagnostic'
Plug 'folke/lsp-colors.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mhinz/vim-signify'
Plug 'itchyny/lightline.vim'
Plug 'ciaranm/securemodelines'
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'windwp/nvim-autopairs'
Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesEnable', 'IndentGuidesToggle'] }
Plug 'ilyachur/cmake4vim', { 'on': ['CMake', 'CMakeBuild', 'CMakeClean', 'CMakeInfo'] }
Plug 'AndrewRadev/linediff.vim', { 'on': ['Linediff'] }
Plug 'equalsraf/neovim-gui-shim'
" color themes
Plug 'ajmwagar/vim-dues'
Plug 'audibleblink/hackthebox.vim'
Plug 'benburrill/potato-colors'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'embark-theme/vim', { 'as': 'embark' }
Plug 'flrnd/candid.vim'
Plug 'franbach/miramare'
Plug 'jsit/toast.vim'
Plug 'joshdick/onedark.vim'
Plug 'kaicataldo/material.vim'
Plug 'kinoute/vim-hivacruz-theme'
Plug 'lifepillar/vim-gruvbox8'
Plug 'mhartington/oceanic-next'
Plug 'raphamorim/lucario'
Plug 'ray-x/aurora'
Plug 'sainnhe/edge'
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'srcery-colors/srcery-vim'

call plug#end()
" ---- End vim-plug ---

" Plugin impatient
lua require('impatient')

" ---- Editing text ----
set nojoinspaces
set langnoremap
set nolangremap

" ---- Spaces and tabs ----
set tabstop=4
set softtabstop=4
set smarttab

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
set wildoptions="pum,tagfile"
set shortmess=at    " abbreviate messages (file names too long, etc)
set lazyredraw      " redraw only when it is needed
set updatetime=100  " milliseconds, period of inactivity before writting to swap file
set nocursorline    " don´t highlight current line
set ruler           " show the cursor position all the time
set laststatus=2    " show always the status line
set visualbell      " no beeps, visual bell
set belloff="all"   " do not ring the bell at all
set noerrorbells    " no flash/beep on errors
set encoding=utf8
set splitbelow      " horizontal splits below
set splitright      " vertical splits to the right
set clipboard=unnamed " use system clipboard
set timeoutlen=2000 " longer time to react to a control key
set display="lastline,msgsep"
set sidescroll=1
set scrolloff=4
set ttyfast

" ---- Syntax highlighting ----
syntax enable
" python specific
let g:python_highlight_all=1
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
set preserveindent
set copyindent
set smartindent
filetype plugin indent on
set cinkeys=0{,0},0),:,0#,!^F,o,O,e,;,.,-,*<Return>,;,=
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(s,us,U0,w0,m0,j0,)20,*30
set formatoptions=cqtj

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
set hidden
set nostartofline

" ---- Completion options ----
set shortmess+=c    " Shut off completion messages
set complete=".,w,b,u,t"

" ---- Backups, autoread, autosave ----
set autoread                        " read a file automatically when it changes outside
set autowrite                       " write the contents of a file when moving to another buffer
set nofsync                         " do not call fsync when writing a file
:au FocusLost * silent! wa          " autosave when focus is lost
set viminfo+=!                      " the viminfo file stores the history of commands and so on
" go back to the previous position
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Session options
set sessionoptions="unix,slash"

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
function s:UniformRand(x, y) " random uniform between x and y
    call v:lua.math.randomseed(localtime())
    return v:lua.math.random(a:x, a:y)
endfunction

function! s:ChooseColorScheme()
    let l:colorschemes_list = [
                \ 'OceanicNext', 'aurora', 'candid',
                \ 'everforest', 'deus', 'edge', 'embark',
                \ 'gruvbox8', 'gruvbox8_hard', 'gruvbox8_soft', 'hackthebox',
                \ 'hivacruz', 'onedark', 'lucario', 'material',
                \ 'miramare', 'nightfly', 'onehalfdark', 'sonokai',
                \ 'potato', 'srcery', 'toast',]
    let l:color_index =  s:UniformRand(0, len(l:colorschemes_list) - 1)
    execute 'colorscheme ' . l:colorschemes_list[l:color_index]
endfunction

autocmd VimEnter * call s:ChooseColorScheme()

" ---- Extra functionallity ----
" to visualize manpages
if has('unix')
    source $VIMRUNTIME/ftplugin/man.vim
    nmap K \K
endif

" Protect large files from sourcing and other overhead. Files become read only
" http://vim.wikia.com/wiki/Faster_loading_of_large_files
let g:LargeFile = 1024 * 1024 * 20
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
let g:python3_host_prog = 'python3'

" Additional configuration files
 for f in split(glob(s:editor_root.'/lua/*.*'), '\n')
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
let g:NERDCustomDelimiters = { 'c': { 'left': '/**', 'right': '*/' } }
" allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Plugin bufstop
map <F7> :BufstopFast<CR>
map <leader>b :Bufstop<CR>             " get a visual on the buffers
map <leader>w :BufstopPreview<CR>      " switch files by moving inside the window

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
let g:ale_disable_lsp = 1
let g:ale_warn_about_trailing_whitespace = 1
let s:python_max_len = 200
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
let g:ale_python_flake8_executable = g:python3_host_prog
let g:ale_python_flake8_options = '-m flake8 --max-line-length='.s:python_max_len
let g:ale_python_pylint_executable = g:python3_host_prog
let g:ale_python_pylint_options = '-m pylint'
let g:ale_python_mypy_options = '--ignore-missing-imports'
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

" Plugin vista
nnoremap <silent> <F12> :Vista!!<CR>
let g:vista_sidebar_width=45
let g:vista_executive_for = {
  \ 'cpp': 'nvim_lsp',
  \ 'python': 'nvim_lsp',
  \ 'groovy': 'nvim_lsp',
  \ 'Jenkinsfile': 'nvim_lsp',
  \ }
let g:vista#renderer#enable_icon = 0
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_ignore_kinds = ["Variable", "Module"]

" Plugin vim-indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Plugin cmake4vim
let g:cmake_build_type = 'Debug'
let g:cmake_compile_commands = 1
let g:cmake_usr_args='-GNinja'

" Plugin signify
let g:signify_sign_add               = '>+'
let g:signify_sign_delete            = '>-'
let g:signify_sign_delete_first_line = '>‾'
let g:signify_sign_change            = '>*'
let g:signify_sign_change_delete     = '>d'

" Plugin telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>fl <cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>

" Color scheme settings
let g:gruvbox_filetype_hi_groups = 1
let g:gruvbox_plugin_hi_groups = 1
