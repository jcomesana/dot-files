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

" Shell
if &shell =~# 'fish$'
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
Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'machakann/vim-sandwich'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'gfanto/fzf-lsp.nvim'
Plug 'mhinz/vim-signify', { 'on': ['SignifyToggle', 'SignifyEnable', 'SignifyEnableAll'] }
Plug 'ciaranm/securemodelines'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'windwp/nvim-autopairs'
Plug 'nathanaelkane/vim-indent-guides', { 'on': ['IndentGuidesEnable', 'IndentGuidesToggle'] }
Plug 'danilamihailov/beacon.nvim'
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
Plug 'bluz71/vim-nightfly-guicolors' | call add(s:colorschemes_list, 'nightfly')
Plug 'catppuccin/vim', { 'as': 'catppuccin' } | call add(s:colorschemes_list, 'catppuccin_mocha')
Plug 'challenger-deep-theme/vim' | call add(s:colorschemes_list, 'challenger_deep')
Plug 'dracula/vim',  { 'as': 'dracula' } | call add(s:colorschemes_list, 'dracula')
Plug 'embark-theme/vim', { 'as': 'embark' } | call add(s:colorschemes_list, 'embark')
Plug 'jsit/toast.vim' | call add(s:colorschemes_list, 'toast')
Plug 'mhartington/oceanic-next' | call add(s:colorschemes_list, 'OceanicNext')
Plug 'sainnhe/edge' | call add(s:colorschemes_list, 'edge')
Plug 'sainnhe/everforest' | call add(s:colorschemes_list, 'everforest')
Plug 'sainnhe/gruvbox-material' | call add(s:colorschemes_list, 'gruvbox-material')
Plug 'sainnhe/sonokai' | call add(s:colorschemes_list, 'sonokai')
Plug 'srcery-colors/srcery-vim' | call add(s:colorschemes_list, 'srcery')
Plug 'rebelot/kanagawa.nvim' | call add(s:colorschemes_list, 'kanagawa')
Plug 'rhysd/vim-color-spring-night' | call add(s:colorschemes_list, 'spring-night')

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
set shiftround
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
set laststatus=3    " global status line at the bottom
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
set timeout timeoutlen=2000 ttimeoutlen=100
set display="lastline,msgsep"
set sidescroll=1
set scrolloff=4
set ttyfast
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set report=0         " always report changed lines

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
set completeopt=menu,menuone,noselect

" ---- Backups, autoread, autosave ----
set autoread                        " read a file automatically when it changes outside
set autowrite                       " write the contents of a file when moving to another buffer
set nofsync                         " do not call fsync when writing a file
:au FocusLost * silent! wa          " autosave when focus is lost
set viminfo+=!                      " the viminfo file stores the history of commands and so on
" go back to the previous position
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" make autoread work
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification after file change
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

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
nnoremap <leader>si :SignifyEnableAll<CR>
let g:signify_disable_by_default = 1
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '*'
let g:signify_sign_change_delete     = 'd'

" Plugin trouble.nvim
nnoremap <leader>xt <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap <leader>xR <cmd>TroubleToggle lsp_references<cr>

" Plugin beacon.nvim
let g:beacon_size = 24
let g:beacon_minimal_jump = 15
let g:beacon_ignore_filetypes = ['fzf']

" Custom statusline
" left side
set statusline=%#Visual#%{StatuslineMode()}%*\|%t\ %r%m
" right side
set statusline+=%=%{LspStatus()}%{&ff}\|%{strlen(&fenc)?&fenc:'none'}\|%y\|%#Visual#%3p%%%5l:%3c%*

function! StatuslineMode()
    let l:mode=mode()
    if l:mode==#"n"
        return "NORM"
    elseif l:mode==?"v"
        return "VIS"
    elseif l:mode==#"i"
        return "INS"
    elseif l:mode==#"R"
        return "REPL"
    elseif l:mode==?"s"
        return "SEL"
    elseif l:mode==#"t"
        return "TERM"
    elseif l:mode==#"c"
        return "COM"
    elseif l:mode==#"!"
        return "SH"
    endif
endfunction

function! LspStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
        let l:error_count = luaeval('#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })')
        let l:warning_count = luaeval('#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })')
        let l:info_count = luaeval('#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })')
        let l:hint_count = luaeval('#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })')
        if (l:error_count || l:warning_count || l:info_count || l:hint_count)
            return '[E:' . l:error_count . ' W:' .l:warning_count . ' I:' . l:info_count . ' H:' . l:hint_count . ']|'
        else
            return '[Ok]|'
        endif
    endif
    return ''
endfunction

" Color scheme
function s:UniformRand(x, y) " random uniform between x and y
    call v:lua.math.randomseed(localtime())
    return v:lua.math.random(a:x, a:y)
endfunction

function! s:ChooseColorScheme()
    let l:color_index =  s:UniformRand(0, len(s:colorschemes_list) - 1)
    execute 'colorscheme ' . s:colorschemes_list[l:color_index]
endfunction
call s:ChooseColorScheme()
