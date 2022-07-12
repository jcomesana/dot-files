set nocompatible

" Create initial folders
let s:editor_root = has('win32') ? expand("~/vimfiles") : expand("~/.vim")
let s:autoloaddir=s:editor_root . '/autoload'
let s:backupdir=s:editor_root . '/backups'
let s:undodir=s:editor_root . '/undodir'
let s:swapdir=s:editor_root . '/swap'
let s:extrasdir=s:editor_root . '/extras'

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

" Shell
if has('win32')
    set shell=c:\windows\system32\cmd.exe   " shell
elseif &shell =~# 'fish$'
    " The fish shell is not very compatible to other shells and unexpectedly
    " breaks things that use 'shell'.
    set shell=/bin/bash
endif

" For random colorscheme selection
let s:colorschemes_list = []

" ---- vim-plug ----
call plug#begin(s:editor_root.'/plugged')
" My plugins here
"
Plug 'itchyny/lightline.vim'
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'omgitsmoe/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'rhysd/vim-lsp-ale'
Plug 'ntpeters/vim-better-whitespace'
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
Plug 'mihaifm/bufstop', { 'on': ['BufstopFast', 'BufstopPreview', 'Bufstop'] }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'machakann/vim-sandwich'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify', { 'on': ['SignifyToggle', 'SignifyEnable', 'SignifyEnableAll'] }
Plug 'ciaranm/securemodelines'
Plug 'cohama/lexima.vim'
Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesEnable', 'IndentGuidesToggle'] }
Plug 'danilamihailov/beacon.nvim'
Plug 'ilyachur/cmake4vim', { 'on': ['CMake', 'CMakeBuild', 'CMakeClean', 'CMakeInfo'] }
Plug 'AndrewRadev/linediff.vim', { 'on': ['Linediff'] }
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
Plug 'bluz71/vim-nightfly-guicolors' | call add(s:colorschemes_list, 'nightfly')
Plug 'catppuccin/vim', { 'as': 'catppuccin' } | call add(s:colorschemes_list, 'catppuccin_mocha')
Plug 'challenger-deep-theme/vim' | call add(s:colorschemes_list, 'challenger_deep')
Plug 'dracula/vim',  { 'as': 'dracula' } | call add(s:colorschemes_list, 'dracula')
Plug 'embark-theme/vim', { 'as': 'embark' } | call add(s:colorschemes_list, 'embark')
Plug 'jsit/toast.vim' | call add(s:colorschemes_list, 'toast')
Plug 'KeitaNakamura/neodark.vim' | call add(s:colorschemes_list, 'neodark')
Plug 'mhartington/oceanic-next' | call add(s:colorschemes_list, 'OceanicNext')
Plug 'sainnhe/edge' | call add(s:colorschemes_list, 'edge')
Plug 'sainnhe/everforest' | call add(s:colorschemes_list, 'everforest')
Plug 'sainnhe/gruvbox-material' | call add(s:colorschemes_list, 'gruvbox-material')
Plug 'sainnhe/sonokai' | call add(s:colorschemes_list, 'sonokai')
Plug 'srcery-colors/srcery-vim' | call add(s:colorschemes_list, 'srcery')

call plug#end()
" ---- End vim-plug ---

" ---- Editing text ----
set nojoinspaces
set langnoremap
set nolangremap

" ---- Spaces and tabs ----
set tabstop=8
set shiftwidth=4
set softtabstop=4
set shiftround
set smarttab
set expandtab

" ---- UI Config ----
set guioptions=grdMe
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
if has('unnamedplus') && has("gui_running")
set clipboard=unnamedplus,autoselectplus " use system clipboard
else
set clipboard=unnamed,autoselect
endif
set timeoutlen=2000 " longer time to react to a control key
set display="lastline,msgsep"
set sidescroll=1
set scrolloff=4
set ttyfast
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set report=0         " always report changed lines
set mouse=nvc

" ---- Syntax highlighting ----
syntax enable
" python specific
let g:python_highlight_all=1
" map space to sync the syntax hilighting on normal mode and redraw the status bar
noremap <silent> <Space> :silent noh <Bar>echo<cr>:syn sync fromstart<cr>:redrawstatus<cr>

" ---- Searching ----
set incsearch       " do incremental searching
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
set formatoptions=cqtjro

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
set swapsync=""                     " to keep changes in the swap file more time in memory
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

" Color scheme settings
let g:gruvbox_material_palette = 'original'
let g:gruvbox_material_background = 'hard'

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
    " disable asyncomplete
    let b:asyncomplete_enable = 2
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

" ---- Plugins ----
let s:python_binary = 'python3'

" Plugin vim-json
let g:vim_json_syntax_conceal = 0

" Plugin vim-sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

" Plugin fzf
nnoremap <leader>ff :FZF<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fa :Ag<CR>
nnoremap <leader>fb :W<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fc :Commits<CR>

let g:fzf_layout = {'up':'~94%', 'window': { 'width': 0.9, 'height': 0.9,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline -i'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!node_modules" --glob "!.git"'

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
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'E'
let g:ale_sign_info = 'I'
let g:ale_sign_warning = 'W'
" list
let g:ale_open_list = 0
" python
let g:ale_python_flake8_executable = s:python_binary
let g:ale_python_flake8_options = '-m flake8 --max-line-length='.s:python_max_len
let g:ale_python_pylint_executable = s:python_binary
let g:ale_python_pylint_options = '-m pylint'
let g:ale_python_mypy_options = '--ignore-missing-imports'
" C++
let g:ale_cpp_clang_executable = 'clang++'
let g:ale_cpp_clang_options = '-Wall -Wextra -std=c++20'
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

    return l:counts.total == 0 ? '[Ok]' : printf(
    \   '[E:%d, W:%d, I:%d]',
    \   all_errors,
    \   all_warnings,
    \   l:counts.info
    \)
endfunction
nnoremap <leader>xt <cmd>lopen<cr>

" Plugin asyncomplete
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_min_chars = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Plugin vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <Leader>ld <plug>(lsp-definition)
    nmap <buffer> <Leader>lR <plug>(lsp-references)
    nmap <buffer> <Leader>lr <plug>(lsp-rename)
    nmap <buffer> <Leader>li <plug>(lsp-implementation)
    nmap <buffer> <Leader>lD <plug>(lsp-type-definition)
    nmap <buffer> <Leader>lr <plug>(lsp-rename)
    nmap <buffer> <Leader>lk <Plug>(lsp-previous-diagnostic)
    nmap <buffer> <Leader>lj <Plug>(lsp-next-diagnostic)
    nmap <buffer> <Leader>lh <plug>(lsp-hover)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_use_event_queue = 1
let g:lsp_ignorecase = 0
let g:lsp_diagnostics_enabled = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_show_workspace_edits = 1
let g:lsp_signs_error = {'text': 'E'}
let g:lsp_signs_warning = {'text': 'W'}
let g:lsp_signs_hint = {'text': '*'}
let g:lsp_signs_information = {'text': 'I'}
let g:lsp_semantic_enabled = 1

" Plugin asyncomplete-lsp.vim
if executable('pylsp')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ 'workspace_config': {'pylsp': {'plugins': {'flake8': {'enabled': v:true, 'maxLineLength': s:python_max_len}}}}
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

if executable('java') && isdirectory(s:extrasdir)
    if !empty($GROOVY_HOME)
        let s:groovy_lib = $GROOVY_HOME.'/lib'
    else
        let s:groovy_lib = ''
    endif
    au User lsp_setup call lsp#register_server({
        \ 'name': 'groovy-language-server',
        \ 'cmd': {server_info->['java', '-jar', s:extrasdir.'/groovy-language-server-all.jar']},
        \ 'allowlist': ['groovy', 'Jenkinsfile'],
        \ 'workspace_config': {'groovy': {'classpath': [s:groovy_lib]} },
        \ })
endif

if executable('npm-groovy-lint')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'npm-groovy-lint',
        \ 'cmd': {server_info->[s:extrasdir.'/efm-langserver/efm-langserver', '-c', s:extrasdir.'/efm-langserver/config.yaml']},
        \ 'allowlist': ['groovy', 'Jenkinsfile']
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
    \ 'allowlist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

" Plugin vista
nnoremap <silent> <F12> :Vista!!<CR>
let g:vista_sidebar_width=45
let g:vista_executive_for = {
  \ 'cpp': 'vim_lsp',
  \ 'python': 'vim_lsp',
  \ 'groovy': 'vim_lsp',
  \ 'Jenkinsfile': 'vim_lsp',
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
nnoremap <leader>si :SignifyEnableAll<CR>
let g:signify_disable_by_default = 1
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '*'
let g:signify_sign_change_delete     = 'd'

" Plugin beacon.nvim
let g:beacon_size = 24
let g:beacon_minimal_jump = 15
let g:beacon_ignore_filetypes = ['fzf']

" Plugin lightline
let g:lightline = {
      \ 'active': {
      \   'left': [['mode', 'paste'],
      \            ['gitbranch', 'readonly', 'filename', 'modified']],
      \   'right': [['lineinfo'],
      \             ['percent'],
      \             ['alestatus', 'fileformat', 'fileencoding', 'filetype']]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'alestatus': 'LinterStatus'
      \ },
      \ 'component': {
      \   'lineinfo': '%4l:%-3v',
      \ },
      \ 'mode_map': {
        \ 'n' : 'NORM',
        \ 'i' : 'INS',
        \ 'R' : 'REPL',
        \ 'v' : 'VIS',
        \ 'V' : 'VISL',
        \ "\<C-v>": 'VISB',
        \ 'c' : 'COM',
        \ 's' : 'SEL',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'TERM',
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
" call s:lightline_update()

" Color scheme
function! s:ChooseColorScheme()
    let l:seed = srand()
    call rand(l:seed)
    let l:color_index =  rand(l:seed) % len(s:colorschemes_list)
    execute 'colorscheme ' . s:colorschemes_list[l:color_index]
endfunction
call s:ChooseColorScheme()
