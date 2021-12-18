set nocompatible

" Create initial folders
let s:editor_root=stdpath('config')
let s:autoloaddir=s:editor_root . '/autoload'
let s:backupdir=s:editor_root . '/backups'

if empty(glob(s:autoloaddir . '/plug.vim'))
    call mkdir(s:editor_root, 'p')
    call mkdir(s:autoloaddir, 'p')
    call mkdir(s:backupdir, 'p')
    :echom system('curl -fLo '.s:autoloaddir.'/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Folders
let &backupdir=s:backupdir
set backup                          " backup and location
set undofile                        " infinite undo and location

" For random colorscheme selection
let s:colorschemes_list = []

" ---- vim-plug ----
call plug#begin(s:editor_root.'/plugged')
" My plugins here
"
Plug 'lewis6991/impatient.nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'mihaifm/bufstop', { 'on': ['BufstopFast', 'BufstopPreview', 'Bufstop'] }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-omni'
" Plug 'folke/trouble.nvim'
Plug 'dense-analysis/ale'
Plug 'folke/lsp-colors.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git', 'Gclog', 'Gllog', 'Gcd', 'Gedit', 'Gsplit', 'Gvsplit', 'Gread', 'Gwrite', 'Gdiffsplit', 'Gvdiffsplit', 'GBrowse', 'GDelete', 'Commits'] }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'on': ['FZF', 'Lines', 'Rg', 'Ag', 'W', 'Commits'] }
Plug 'junegunn/fzf.vim', { 'on': ['FZF', 'Lines', 'Rg', 'Ag', 'W', 'Commits'] }
Plug 'mhinz/vim-signify', { 'on': ['SignifyToggle', 'SignifyEnable', 'SignifyEnableAll'] }
Plug 'ciaranm/securemodelines'
" Plug 'nvim-treesitter/nvim-treesitter'
Plug 'windwp/nvim-autopairs'
Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesEnable', 'IndentGuidesToggle'] }
Plug 'ilyachur/cmake4vim', { 'on': ['CMake', 'CMakeBuild', 'CMakeClean', 'CMakeInfo'] }
Plug 'AndrewRadev/linediff.vim', { 'on': ['Linediff'] }
Plug 'equalsraf/neovim-gui-shim'
" File type specific plugins
Plug 'vim-jp/vim-cpp', { 'for': ['c', 'cpp'] }
Plug 'bfrg/vim-cpp-modern', { 'for': ['c', 'cpp'] }
Plug 'pboettch/vim-cmake-syntax', { 'for': 'CMake' }
Plug 'blankname/vim-fish', { 'for': 'fish' }
Plug 'martinda/Jenkinsfile-vim-syntax', { 'for': 'Jenkinsfile' }
Plug 'PProvost/vim-ps1', { 'for': 'ps1' }
Plug 'elzr/vim-json', { 'for': ['json'] }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'arzg/vim-sh'
Plug 'MTDL9/vim-log-highlighting'
" color themes
Plug 'ajmwagar/vim-dues' | call add(s:colorschemes_list, 'deus')
Plug 'audibleblink/hackthebox.vim' | call add(s:colorschemes_list, 'hackthebox')
Plug 'bluz71/vim-nightfly-guicolors' | call add(s:colorschemes_list, 'nightfly')
Plug 'embark-theme/vim', { 'as': 'embark' } | call add(s:colorschemes_list, 'embark')
Plug 'franbach/miramare' | call add(s:colorschemes_list, 'miramare')
Plug 'jsit/toast.vim' | call add(s:colorschemes_list, 'toast')
Plug 'joshdick/onedark.vim' | call add(s:colorschemes_list, 'onedark')
Plug 'lifepillar/vim-gruvbox8' | call add(s:colorschemes_list, 'gruvbox8_hard')
Plug 'mhartington/oceanic-next' | call add(s:colorschemes_list, 'OceanicNext')
Plug 'raphamorim/lucario' | call add(s:colorschemes_list, 'lucario')
Plug 'ray-x/aurora' | call add(s:colorschemes_list, 'aurora')
Plug 'sainnhe/edge' | call add(s:colorschemes_list, 'edge')
Plug 'sainnhe/everforest' | call add(s:colorschemes_list, 'everforest')
Plug 'sainnhe/sonokai' | call add(s:colorschemes_list, 'sonokai')
Plug 'sonph/onehalf', { 'rtp': 'vim' } | call add(s:colorschemes_list, 'onehalfdark')
Plug 'srcery-colors/srcery-vim' | call add(s:colorschemes_list, 'srcery')

call plug#end()
" ---- End vim-plug ---

" Plugin impatient
lua require('impatient')

" ---- Editing text ----
set nojoinspaces
set langnoremap
set nolangremap

" ---- Spaces and tabs ----
set tabstop=8
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab

" ---- UI Config ----
set title           " set the window title
set modeline
set number
set signcolumn=yes
set noshowmode      " mode handled by the status line
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
if has('unnamedplus')
set clipboard=unnamedplus
else
set clipboard=unnamed
endif
set timeoutlen=2000 " longer time to react to a control key
set display="lastline,msgsep"
set sidescroll=1
set scrolloff=4
set ttyfast
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" ---- Syntax highlighting ----
syntax enable
" python specific
let g:python_highlight_all=1
" map space to sync the syntax hilighting on normal mode and redraw the status bar
noremap <silent> <Space> :silent noh <Bar>echo<cr>:syn sync fromstart<cr>:redrawstatus<cr>

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
set nosmartindent
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
    let l:color_index =  s:UniformRand(0, len(s:colorschemes_list) - 1)
    execute 'colorscheme ' . s:colorschemes_list[l:color_index]
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
    autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call s:LargeFile() | endif
augroup END

function! s:LargeFile()
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

" Custom commands
" CDC = Change to Directory of Current file
command CDC cd %:p:h
" Command for make|copen
command MC :silent make<bar>copen

" ---- netrw settings ----
let g:netrw_liststyle=3

" ---- groovy settings ---
autocmd FileType groovy setlocal makeprg=npm-groovy-lint\ --no-insight\ --files\ \"**/%:t\"
autocmd FileType Jenkinsfile setlocal makeprg=npm-groovy-lint\ --no-insight\ --files\ \"**/%:t\"

" Disable some providers
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0

" Additional configuration files
for f in split(glob(s:editor_root.'/lua/*.*'), '\n')
		exe 'source' f
endfor

" ---- Plugins ----
let g:python3_host_prog = 'python3'

" Plugin vim-json
let g:vim_json_syntax_conceal = 0

" Plugin bufstop
map <F7> :BufstopFast<CR>
map <leader>b :Bufstop<CR>             " get a visual on the buffers
map <leader>w :BufstopPreview<CR>      " switch files by moving inside the window

" Plugin ALE
let g:ale_linters = {
\   'python': ['vim-lsp', 'pylint', 'flake8'],
\   'cpp': ['vim-lsp', 'clang'],
\   'groovy': ['vim-lsp'],
\   'Jenkinsfile': ['vim-lsp'],
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
function! s:IsLinterAvailable() abort
  return get(g:, 'ale_enabled', 0) == 1
    \ && getbufvar(bufnr(''), 'ale_enabled', 1)
    \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
    \ && ale#engine#IsCheckingBuffer(bufnr('')) == 0
endfunction
" Function for ALE copied from the docs
function! LinterStatus() abort
    if !s:IsLinterAvailable()
        return ''
    endif
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_warnings = l:counts.warning + l:counts.style_warning

    return l:counts.total == 0 ? '[Ok] | ' : printf(
    \   '[E:%d, W:%d, I:%d] | ',
    \   all_errors,
    \   all_warnings,
    \   l:counts.info
    \)
endfunction
nnoremap <leader>xt <cmd>lopen<cr>

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
nnoremap <leader>si :SignifyEnable<CR>
let g:signify_disable_by_default = 1
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '*'
let g:signify_sign_change_delete     = 'd'

" Plugin trouble.nvim
" nnoremap <leader>xt <cmd>TroubleToggle<cr>
" nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
" nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
" nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
" nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
" nnoremap <leader>xR <cmd>TroubleToggle lsp_references<cr>

" Color scheme settings
let g:gruvbox_filetype_hi_groups = 1
let g:gruvbox_plugin_hi_groups = 1

" Custom statusline
" left side
set statusline=%#Visual#%{StatuslineMode()}%*\ \|\ %t\ %r%m
" right side
set statusline+=%=%{LinterStatus()}%{&ff}\ \|\ %{strlen(&fenc)?&fenc:'none'}\ \|\ %y\ \|\ %#Visual#%3p%%\ %5l:%3c%*

function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#"n"
        return "NORMAL"
    elseif l:mode==?"v"
        return "VISUAL"
    elseif l:mode==#"i"
        return "INSERT"
    elseif l:mode==#"R"
        return "REPLACE"
    elseif l:mode==?"s"
        return "SELECT"
    elseif l:mode==#"t"
        return "TERMINAL"
    elseif l:mode==#"c"
        return "COMMAND"
    elseif l:mode==#"!"
        return "SHELL"
    endif
endfunction
