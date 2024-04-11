--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://neovim.io/doc/user/lua-guide.html

  And then you can explore or search through `:help lua-guide`


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- To be able to use this for lualine
local diagnostics_signs = { Error = '', Warn = ' ', Hint = '', Info = '' }

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
local lazy_opts = {
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    notify = false,
    frequency = 10800,
  },
  git = {
    timeout = 380,
  },
  ui = {
    border = 'rounded',
  },
}
if vim.env.NVIM_LAZY_CONCURRENCY then
  lazy_opts['concurrency'] = tonumber(vim.env.NVIM_LAZY_CONCURRENCY)
end

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Git, P4
  'mhinz/vim-signify',

  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    event = 'VeryLazy',
  },

  -- Remember last position
  'farmergreg/vim-lastplace',

  -- Auto pairs completion
  { 'windwp/nvim-autopairs' },

  -- To surround words, lines with " or [
  'machakann/vim-sandwich',

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Better handling of dangling spaces
  { 'ntpeters/vim-better-whitespace' },

  -- To diff specific parts of 2 files
  {
    'AndrewRadev/linediff.vim',
    cmd = 'Linediff'
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        'williamboman/mason.nvim',
        config = true,
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Better LSP signature help
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
  },

  {
    -- Code actions indicator
    'kosayoda/nvim-lightbulb',
    event = 'VeryLazy',
    opts = {
      sign = {
        text = '󱠂',
      },
      number = {
        enabled = true,
      },
      autocmd = {
        -- Whether or not to enable autocmd creation.
        enabled = true,
        updatetime = 250,
      },
      ignore = {
        clients = { 'ruff_lsp' },
        actions_without_kind = true,
      },
    },
  },

  {
    -- To display diagnostics
    'folke/trouble.nvim',
    opts = {
      icons = true,
      fold_open = '-', -- icon used for open folds
      fold_closed = '+', -- icon used for closed folds
      indent_lines = true, -- add an indent guide below the fold icons
      use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
      auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    }
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Buffer completion
      'hrsh7th/cmp-buffer',

      -- Treesitter completion
      'ray-x/cmp-treesitter',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Add icons to the completion menu
      {
        'onsails/lspkind.nvim',
      },
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
      },
    }
  },

  -- Buffer navigation
  { 'mihaifm/bufstop' },

  {
    -- Beacon
    'rainbowhxch/beacon.nvim',
    opts = {
      size = 100,
      focus_gained = false,
    }
  },

  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  {
    -- File navigation
    'stevearc/oil.nvim',
    event = 'VeryLazy',
    cmd = 'Oil',
    opts = {
      columns = { 'size', 'mtime', 'icon' },
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = 'yes:2',
      },
      keymaps = {
        ['\\o?'] = 'actions.show_help',
        ['\\os'] = 'actions.select_vsplit',
        ['\\oh'] = 'actions.select_split',
        ['\\ot'] = 'actions.select_tab',
        ['\\ov'] = 'actions.preview',
        ['\\ol'] = 'actions.add_to_loclist',
        ['\\oq'] = 'actions.close',
        ['\\or'] = 'actions.refresh',
        ['\\op'] = 'actions.copy_entry_path',
        ['\\of'] = 'actions.change_sort',
        ['\\ox'] = 'actions.open_external',
        ['\\o.'] = 'actions.toggle_hidden',
        ['\\ob'] = 'actions.toggle_trash',
      },
    }
  },
  {
    'refractalize/oil-git-status.nvim',

    dependencies = {
      'stevearc/oil.nvim',
    },

    config = true,
  },

  {
    -- Toggleterm
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = '<C-s>',
      direction = 'vertical',
      shade_terminals = true,
      size = function(term)
          if term.direction == 'horizontal' then
            return 20
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.5
          end
        end,
    }
  },

  {
    -- Secure mode lines
    'ciaranm/securemodelines'
  },

  -- nvim-web-devicons
  { 'nvim-tree/nvim-web-devicons' },

  -- File type specific plugins

  -- Colorschemes
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
  },
  {
    'ajmwagar/vim-dues',
    priority = 1000,
  },
  {
    'bluz71/vim-nightfly-guicolors',
    priority = 1000,
  },
  {
    'dracula/vim',
    name = 'dracula',
    priority = 1000,
  },
  {
    'drewtempelmeyer/palenight.vim',
    priority = 1000,
  },
  {
    'dustypomerleau/tol.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'embark-theme/vim',
    name = 'embark',
    priority = 1000,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'lvim-tech/lvim-colorscheme',
    priority = 1000,
  },
  {
    'ray-x/aurora',
    priority = 1000,
  },
  {
    'ribru17/bamboo.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').load()
    end,
  },
  {
    'rhysd/vim-color-spring-night',
    priority = 1000,
  },
  {
    'sainnhe/edge',
    priority = 1000,
  },
  {
    'sainnhe/everforest',
    priority = 1000,
  },
  {
    'sainnhe/sonokai',
    priority = 1000,
  },
  {
    'srcery-colors/srcery-vim',
    priority = 1000,
  },
  {
    'dam9000/colorscheme-midnightblue',
    priority = 1000,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_b = {
          {
            'filename',
            symbols = {
              readonly = '[RO]',
            },
          },
        }, -- lualine_b
        lualine_c = {'branch',
                     'diff',
                     {
                      'diagnostics',
                      symbols = { error = diagnostics_signs['Error'] .. ' ',
                                  warn = diagnostics_signs['Warn'] .. ' ',
                                  hint = diagnostics_signs['Hint'] .. ' ',
                                  info = diagnostics_signs['Info'] .. ' '},
                      on_click = function() require('trouble').toggle() end
                     }
        }, -- lualine_c
        lualine_x = {
                      {
                        require('lazy.status').updates,
                        cond = require('lazy.status').has_updates,
                        color = { fg = '#ff9e64' },
                        on_click = function() vim.cmd('Lazy sync') end
                      },
                      'encoding',
                      'fileformat',
                      'filetype'
        },
        lualine_y = {'progress'},
        lualine_z = {'location'},
      },
      inactive_sections = {
        lualine_b = {
          {
            'filename',
            symbols = {
              readonly = '[RO]',
            },
          },
        }, -- lualine_b
        lualine_c = {},
      },
      extensions = { 'fugitive', 'toggleterm', 'trouble' }
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {},
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = function()
          if vim.fn.has('win32') == 1 then
            return 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
          end
          return 'make'
        end,
        cond = function()
          if vim.fn.has('win32') == 1 then
            return vim.fn.executable 'cmake' == 1
          end
          return vim.fn.executable 'make' == 1
        end,
      },

      {
        -- Ag for telescope
        'kelly-lin/telescope-ag'
      },

      {
          'isak102/telescope-git-file-history.nvim',
          dependencies = { 'tpope/vim-fugitive' }
      }
    }
  },

  -- FZF
  { 'junegunn/fzf' },
  { 'junegunn/fzf.vim' },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      -- Provide context based on treesitter
      'nvim-treesitter/nvim-treesitter-context',
      -- Indentation engine
      'yioneko/nvim-yati',
    },
    build = ':TSUpdate',
  },

  {
    -- auto-save plugin
    'willothy/savior.nvim',
    dependencies = { 'j-hui/fidget.nvim' },
    event = { 'InsertEnter', 'TextChanged' },
    config = true,
    opts = {
      throttle_ms = 5000,
      interval_ms = 35000,
      defer_ms = 1000
    }
  },

  {
    -- GUI shim
    'equalsraf/neovim-gui-shim'
  },

  {
    -- Handle big files
    'LunarVim/bigfile.nvim',
    opts = {
      filesize = 20 -- 20 MB
    }
  },

  -- File type specific plugins
  {
    'blankname/vim-fish',
    ft = 'fish'
  },
  {
    'martinda/Jenkinsfile-vim-syntax',
    ft = 'Jenkinsfile'
  },
  {
    'ckipp01/nvim-jenkinsfile-linter',
    ft = 'Jenkinsfile'
  },
  {
    'PProvost/vim-ps1',
    ft = 'ps1'
  },
  {
    'Vimjas/vim-python-pep8-indent',
    ft = 'python'
  },
  {
    'alvan/vim-closetag',
    ft = { 'html', 'xml' }
  },
  {
    'MTDL9/vim-log-highlighting'
  }

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, lazy_opts)

-- [[ Setting options ]]
-- See `:help vim.o`

-- Editing text --
vim.o.joinspaces = false
vim.o.langnoremap = true
vim.o.langremap = false

-- Spaces and tabs --
vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.shiftround = true
vim.o.smarttab = true
vim.o.expandtab = true

-- UI Config --
vim.o.title = true
vim.o.modeline = true
vim.wo.number = true
vim.wo.signcolumn = 'yes:4'
vim.o.showmode = false
vim.o.showcmd = true
vim.o.cmdheight = 2
vim.o.history = 50
vim.o.wildmenu = true
vim.o.wildignore = '*.bak,*.o,*~,*.pyc,*.lib,*.swp'
vim.o.wildoptions = 'pum,tagfile'
vim.o.shortmess = 'atc'
vim.o.lazyredraw = false
vim.o.updatetime = 250
vim.o.cursorline = false
vim.o.ruler = true
vim.o.laststatus = 2
vim.o.visualbell = true
vim.o.belloff = 'all'
vim.o.errorbells = false
vim.o.encoding = 'utf8'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.clipboard = 'unnamedplus'
vim.o.timeout = true
vim.o.timeoutlen = 2000
vim.o.ttimeoutlen = 100
vim.o.display = 'lastline,msgsep'
vim.o.sidescroll = 1
vim.o.scrolloff = 4
vim.o.ttyfast = true
vim.o.listchars = 'tab:> ,trail:-,extends:>,precedes:<,nbsp:␣'
vim.o.report = 0

-- Syntax highlighting --
vim.o.syntax = 'ON'
vim.g['python_highlight_all'] = 1

-- Searching --
vim.o.incsearch = true
vim.o.inccommand = 'split'
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Indentation and formating --
vim.o.autoindent = true
vim.o.breakindent = true
vim.o.preserveindent = true
vim.o.copyindent = true
vim.o.smartindent = true
vim.o.cinkeys = '0{,0},0),:,0#,!^F,o,O,e,;,.,-,*<Return>,;,='
vim.o.cinoptions = '>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(s,us,U0,w0,m0,j0,)20,*30'
vim.o.formatoptions = 'cqtjro'

-- Folding --
vim.o.foldenable = true
vim.o.foldlevelstart = 10
vim.o.foldnestmax = 10
vim.o.foldmethod = 'syntax'

-- Movement --
vim.o.backspace = 'indent,eol,start' -- allow backspacing over everything in insert mode
vim.o.whichwrap = '<,>,[,]' -- wrap lines only with arrow keys
vim.o.startofline = false

-- Completion --
vim.o.completeopt = 'menuone,noselect'

-- Backups, autoread
local backups_dir = vim.fn.stdpath 'config' .. '/backups'
vim.o.undofile = true
vim.o.backup = true
vim.o.backupdir = backups_dir
vim.o.fsync = false
vim.o.autoread = true
vim.o.autowrite = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Color Scheme options
vim.o.background = 'dark'
vim.o.termguicolors = true

-- Disable some providers
vim.g['loaded_python_provider'] = false
vim.g['loaded_perl_provider'] = false
vim.g['loaded_node_provider'] = false
vim.g['loaded_ruby_provider'] = false

vim.g['python3_host_prog'] = 'python3'
vim.g['python_recommended_style'] = 0

-- [[ Keymaps ]]

-- remaps for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Page up and down and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', { expr = false, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { expr = false, silent = true })

-- move through buffers with F8 and F9
vim.keymap.set('n', '<F8>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Go to previous buffer' })
vim.keymap.set('n', '<F9>', ':bnext<CR>', { noremap = true, silent = true, desc = 'Go to next buffer'  })
-- to skip the quicklist buffer when going through buffers
local qf_augroup = vim.api.nvim_create_augroup('qf', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  group = qf_augroup,
  command = 'set nobuflisted'
})

-- Disable highlighting and redraw
vim.keymap.set({ 'n', 'v' }, '<Space>', ':noh<CR>:syn sync fromstart<CR>:redrawstatus<CR>', { silent = true })

-- Keymaps to copy the current filename to the clipboard
vim.keymap.set('n', ',cs', ':let @+=expand("%")<CR>', { noremap = true, silent = false, desc = 'Copy short file name to clipboard' })
vim.keymap.set('n', ',cl', ':let @+=expand("%:p")<CR>', { noremap = true, silent = false, desc = 'Copy long file name to clipboard' })

-- Copy the current buffer
vim.keymap.set('n', ',yA', ':%y<CR>', { noremap = true, silent = false, desc = '[Y]ank [A]ll' })

-- Split windows
vim.keymap.set('n', '<Leader>ih', ':split<CR>', { noremap = true, silent = false, desc = '[H]orizontal window spl[i]t' })
vim.keymap.set('n', '<Leader>iv', ':vsplit<CR>', { noremap = true, silent = false, desc = '[V]ertical window spl[i]t' })
vim.keymap.set('n', '<Leader>in', ':vsplit<CR>:bnext<CR>', { noremap = true, silent = false, desc = '[V]ertical window split & [N]ext buffer' })
vim.keymap.set('n', '<Leader>ip', ':vsplit<CR>:bprevious<CR>', { noremap = true, silent = false, desc = '[V]ertical window split & [P]revious buffer' })

-- Keymaps for P4 operations
vim.keymap.set('n', '<Leader>pa', ':!p4 add "%"<CR>', { noremap = true, silent = false, desc = 'P4 open for [a]dd' })
vim.keymap.set('n', '<Leader>pe', ':!p4 edit "%"<CR>', { noremap = true, silent = false, desc = 'P4 open for [e]dit' })
vim.keymap.set('n', '<Leader>pr', ':!p4 revert "%"<CR>', { noremap = true, silent = false, desc = 'P4 [r]evert' })

-- which-key
vim.keymap.set('n', '<Leader>wk', ':WhichKey<CR>', { noremap = true, silent = false, desc = '[W]hich [K]ey' })

-- Custom commands
-- CDC = Change to Directory of Current file
vim.api.nvim_create_user_command('CDC', 'cd %:p:h', {})

-- [[ Workaround for autoread not working, use autocommands ]]
local autoread_fix_augroup = vim.api.nvim_create_augroup('autoread_fix', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  group = autoread_fix_augroup,
  command = "if mode() != 'c' | checktime | endif"
})
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
  pattern = '*',
  group = autoread_fix_augroup,
  command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None'
})

-- [[ New filetypes ]]
local new_filetypes_augroup = vim.api.nvim_create_augroup('new_filetypes', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.jobdsl' },
  group = new_filetypes_augroup,
  command = 'setfiletype groovy'
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<RightMouse>'] = require('telescope.actions').close,
        ['<LeftMouse>'] = require('telescope.actions').select_default,
        ['<ScrollWheelDown>'] = require('telescope.actions').move_selection_next,
        ['<ScrollWheelUp>'] = require('telescope.actions').move_selection_previous,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
-- Enable telescope-git-history
pcall(require('telescope').load_extension, 'git_file_history')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<Leader>to', require('telescope.builtin').oldfiles, { desc = 'Telescope recently [O]pened files' })
vim.keymap.set('n', '<Leader>tb', require('telescope.builtin').buffers, { desc = 'Telescope [B]uffers' })
vim.keymap.set('n', '<Leader>tz', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Telescope fu[Z]zily in current buffer' })

vim.keymap.set('n', '<Leader>tg', require('telescope.builtin').git_files, { desc = 'Telescope [G]it files' })
vim.keymap.set('n', '<Leader>tc', require('telescope.builtin').git_commits, { desc = 'Telescope git [C]ommits' })
vim.keymap.set('n', '<Leader>tf', require('telescope.builtin').find_files, { desc = 'Telescope [F]iles' })
vim.keymap.set('n', '<Leader>tF', function()
  return require('telescope.builtin').find_files({ find_command = { 'fd', '--hidden', vim.fn.expand('<cword>') } })
end, { desc = 'Telescope [F]iles under cursor' })
vim.keymap.set('n', '<Leader>th', require('telescope.builtin').help_tags, { desc = 'Telescope [H]elp' })
vim.keymap.set('n', '<Leader>tw', require('telescope.builtin').grep_string, { desc = 'Telescope current [W]ord' })
vim.keymap.set('n', '<Leader>tl', require('telescope.builtin').live_grep, { desc = 'Telescope [L]ive grep' })
vim.keymap.set('n', '<Leader>td', require('telescope.builtin').diagnostics, { desc = 'Telescope [D]iagnostics' })
vim.keymap.set('n', '<Leader>tt', require('telescope.builtin').treesitter, { desc = 'Telescope [T]reesitter' })
vim.keymap.set('n', '<Leader>ts', require('telescope.builtin').lsp_document_symbols, { desc = 'Telescope document [s]ymbols' })
vim.keymap.set('n', '<Leader>tS', require('telescope.builtin').lsp_workspace_symbols, { desc = 'Telescope workspace [S]ymbols' })
vim.keymap.set('n', '<Leader>tr', require('telescope.builtin').lsp_references, { desc = 'Telescope LSP [R]eferences' })
vim.keymap.set('n', '<Leader>tI', require('telescope.builtin').lsp_implementations, { desc = 'Telescope LSP [I]mplementation' })
vim.keymap.set('n', '<Leader>tm', require('telescope.builtin').resume, { desc = 'Telescope search resu[m]e' })
vim.keymap.set('n', '<Leader>tH', require('telescope').extensions.git_file_history.git_file_history, { desc = 'Telescope git [H]istory' })

-- [[ Configure FZF ]]
vim.keymap.set('n', '<Leader>ff', ':FZF<CR>', { desc = 'FZF Files' })
vim.keymap.set('n', '<Leader>fg', ':Rg<CR>', { desc = 'Ripgrep' })
vim.keymap.set('n', '<Leader>fG', ':Rg <C-R><C-W><CR>', { desc = 'Ripgrep with word under cursor' })
vim.keymap.set('n', '<Leader>fa', ':Ag <C-R><C-W><CR>', { desc = 'Ag with word under cursor' })
vim.keymap.set('n', '<Leader>fA', ':Ag <C-R><C-W><CR>', { desc = 'Ag with word under cursor' })
vim.keymap.set('n', '<Leader>fb', ':W<CR>', { desc = 'FZF Buffers' })
vim.keymap.set('n', '<Leader>fl', ':Lines<CR>', { desc = 'FZF Lines of open buffers' })
vim.keymap.set('n', '<Leader>fc', ':Commits<CR>', { desc = 'FZF Commits' })
vim.g['fzf_layout'] = {['up'] = '~94%',
                       ['window'] = { ['width'] = 0.9,
                                      ['height'] = 0.9,
                                      ['yoffset'] = 0.5,
                                      ['xoffset'] = 0.5,
                                      ['border'] = 'sharp' } }
vim.env.FZF_DEFAULT_OPTS = '--layout=reverse -i --color=dark --ansi'
vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!node_modules" --glob "!.git"'

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cmake', 'cpp', 'dockerfile', 'groovy', 'html', 'java', 'json', 'kotlin', 'lua', 'python', 'swift', 'vimdoc', 'vim', 'xml', 'yaml', 'yang' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { 'python', 'xml', }
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = ']<space>',
        node_incremental = ']<space>',
        scope_incremental = ']i',
        node_decremental = ']d',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Diagnostics ]]
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  -- source = true,
  float = {
    border = 'rounded',
    source = true,
    severity_sort = true,
  },
})
for type, icon in pairs(diagnostics_signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<Leader>dm', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<Leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure trouble.nvim ]]
-- require('trouble').setup {
vim.keymap.set('n', '<Leader>xt', '<cmd>TroubleToggle<cr>', { noremap = true, silent = true, desc = 'Toggle trouble.nvim' })
vim.keymap.set('n', '<Leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', { noremap = true, silent = true, desc = 'Toggle trouble.nvim workspace diagnostics' })
vim.keymap.set('n', '<Leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', { noremap = true, silent = true, desc = 'Toggle trouble.nvim document diagnostics' })
vim.keymap.set('n', '<Leader>xl', '<cmd>TroubleToggle loclist<cr>', { noremap = true, silent = true, desc = 'Toggle trouble.nvim to loclist' })
vim.keymap.set('n', '<Leader>xq', '<cmd>TroubleToggle quickfix<cr>', { noremap = true, silent = true, desc = 'Toggle trouble.nvim to [q]uickfix' })
vim.keymap.set('n', '<Leader>xr', '<cmd>TroubleToggle lsp_references<cr>', { noremap = true, silent = true, desc = 'Toggle trouble.nvim LSP [r]efs' })

-- [[ Configure LSP ]]

-- [[ Configure lsp_signature ]]
require('lsp_signature').setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  doc_lines = 4,
  handler_opts = {
    border = 'rounded'
  },
  hint_enable = false,
  hint_prefix = '» ',
  always_trigger = true,
  fix_pos = true,
})

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  require 'lsp_signature'.on_attach()

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<Leader>ln', vim.lsp.buf.rename, 'Re[N]ame')
  nmap('<Leader>la', vim.lsp.buf.code_action, 'Code [A]ction')
  nmap('<Leader>ld', vim.lsp.buf.definition, 'Goto [D]efinition')
  nmap('<Leader>lr', vim.lsp.buf.references, '[R]eferences')
  nmap('<Leader>li', vim.lsp.buf.implementation, 'Goto [I]mplementation')
  nmap('<Leader>lt', vim.lsp.buf.type_definition, '[T]ype Definition')
  nmap('<Leader>lh', vim.lsp.buf.hover, '[H]over Documentation')
  nmap('<Leader>ls', vim.lsp.buf.signature_help, '[S]ignature Documentation')

  -- Lesser used LSP functionality
  nmap('<Leader>lD', vim.lsp.buf.declaration, 'Goto [D]eclaration')
  nmap('<Leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<Leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<Leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

vim.lsp.handlers['textDocument/hover'] =  vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local extras_path = require('lspconfig').util.path.join(vim.fn.stdpath('config'), 'extras')
vim.env.NVIM_EXTRAS_DIR = extras_path
local efm_config_file = ''
if (vim.fn.has('win32') == 1) then
  efm_config_file = require('lspconfig').util.path.join(extras_path, 'efm-config-win32.yaml')
else
  efm_config_file = require('lspconfig').util.path.join(extras_path, 'efm-config-unix.yaml')
end

local groovy_lsp_classpath = {}
if vim.env.GROOVY_HOME then
  local groovy_lib = vim.env.GROOVY_HOME .. '/lib'
  table.insert(groovy_lsp_classpath, groovy_lib)
end

local is_termux = not not vim.env.TERMUX_APP_PID

local lsp_servers = {
  clangd = {
    mason = false,
    cmd = {
      'clangd', '--background-index', '--suggest-missing-includes', '--clang-tidy', '--header-insertion=iwyu'
    },
  },

  dockerls = {
    mason = not is_termux,
  },

  efm = {
    mason = not is_termux,
    filetypes = { 'groovy', 'Jenkinsfile'},
    flags = {
      debounce_text_changes = 1500,
      allow_incremental_sync = false,
    },
    cmd = { 'efm-langserver', '-c', efm_config_file }
  },

  groovyls = {
    mason = not is_termux,
    filetypes = { 'groovy', 'Jenkinsfile'},
    groovy = {
      classpath = groovy_lsp_classpath,
    },
    cmd = { 'groovy-language-server' },
  },

  lua_ls = {
    mason = not is_termux,
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },

  pylsp = {
    pylsp = {
      plugins = {
        flake8 = {
          enabled = false,
          maxLineLength = 200,
        },
        pycodestyle = {
          maxLineLength = 200,
        },
        pylint = {
          enabled = true,
          args = {'--max-line-length 200'}
        },
      }
    },
  },

  ruff_lsp = {
    mason = not is_termux,
  },

  sourcekit = {
    mason = false,
    filetypes = { 'swift' }
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

local lsp_servers_handled_with_mason = {}
for server_name, server_config in pairs(lsp_servers) do
  if server_config.mason or server_config.mason == nil then
    table.insert(lsp_servers_handled_with_mason, server_name)
  else
    -- Manualy handled LSP servers
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = server_config,
      filetypes = (server_config or {}).filetypes,
      cmd = (server_config or {}).cmd,
      flags = (server_config or {}).flags,
    }
  end
end
require('mason-tool-installer').setup {
  ensure_installed = lsp_servers_handled_with_mason,
  auto_update = true,
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = lsp_servers[server_name],
      filetypes = (lsp_servers[server_name] or {}).filetypes,
      cmd = (lsp_servers[server_name] or {}).cmd,
      flags = (lsp_servers[server_name] or {}).flags,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = { completeopt = 'menu,menuone,noinsert' },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
        indexing_batch_size = 1200,
      }
    },
    { name = 'treesitter' },
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      preset = 'codicons',
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
    })
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}

cmp.event:on(
  'confirm_done',
  require('nvim-autopairs.completion.cmp').on_confirm_done()
)

-- [[ Configure signify ]]
vim.g['signify_sign_add']               = '+'
vim.g['signify_sign_delete']            = '-'
vim.g['signify_sign_delete_first_line'] = '‾'
vim.g['signify_sign_change']            = '*'
vim.g['signify_sign_change_delete']     = 'd'

-- [[ Configure vim-sandwich ]]
vim.g['sandwich#recipes'] = vim.deepcopy(vim.g['sandwich#default_recipes'])

-- [[ Configure nvim-autopairs ]]
require('nvim-autopairs').setup({
  fast_wrap = {
    map = '<M-w>',
  }
})

-- [[ Configure bufstop ]]
vim.keymap.set('n', '<F7>', ':BufstopFast<CR>', { noremap = true, silent = false, desc = 'Open buflist with BufstopFast' })
vim.keymap.set('n', '<Leader>bv', ':Bufstop<CR>', { noremap = true, silent = false, desc = 'Open buflist with Bufstop' })
vim.keymap.set('n', '<Leader>bp', ':BufstopPreview<CR>', { noremap = true, silent = false, desc = 'Open buflist with BufstopPreview' })
vim.g.BufstopFileSymbolFunc = function (path)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = vim.fn.fnamemodify(path, ':e')
  return require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
end

-- [[ Configure oil ]]
vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' })

-- [[ Configure better-whitespace ]]
vim.g['better_whitespace_filetypes_blacklist'] = {'diff', 'git', 'gitcommit',
                                                  'unite', 'qf', 'help', 'markdown',
                                                  'fugitive', 'toggleterm'}

-- [[ Configure nvim-jenkinsfile-linter ]]
if vim.env.JENKINS_URL then
  vim.keymap.set('n', '<Leader>jv', require('jenkinsfile_linter').validate, { noremap = true, silent = false, desc = 'Jenkinsfile Validation' })

  -- Run with autocommand too
  local jenkinsfile_linter_group = vim.api.nvim_create_augroup('jenkinsfile_linter_group', { clear = true })
  vim.api.nvim_create_autocmd({'BufWinEnter', 'BufWritePost'}, {
    pattern = {'*.Jenkinsfile'},
    callback = require('jenkinsfile_linter').validate,
    group = jenkinsfile_linter_group
  })
end

-- [[ Configure vim-closetag ]]
vim.g['closetag_filenames'] = '*.html,*.xhtml,*.phtml,*.xml'
vim.g['closetag_filetypes'] = 'html,xhtml,phtml,xml'

-- [[ Configure Comment.nvim ]]
local comment_ft = require('Comment.ft')
comment_ft.set('Jenkinsfile', {'//%s', '/*%s*/'})

-- [[ random colorscheme ]]

local function select_colorscheme()
  local colorschemes_table = {}
  local excluded_colorschemes = {
    'blue',
    'default',
    'delek',
    'desert',
    'elflord',
    'evening',
    'habamax',
    'industry',
    'koehler',
    'lunaperche',
    'morning',
    'murphy',
    'pablo',
    'peachpuff',
    'quiet',
    'ron',
    'shine',
    'slate',
    'torte',
    'zellner',
    'lvim-light',
    'tokyonight-day',
  }

  local color_files = vim.fn.globpath(vim.o.runtimepath, 'colors/*.vim', false, true)
  for _, lua_color_file in ipairs(vim.fn.globpath(vim.o.runtimepath, 'colors/*.lua', false, true)) do
    table.insert(color_files, lua_color_file)
  end
  for _, color_file in ipairs(color_files) do
    local colorscheme_name = vim.fn.fnamemodify(color_file, ':t:r')
    if (not vim.tbl_contains(excluded_colorschemes, colorscheme_name)) then
      table.insert(colorschemes_table, colorscheme_name)
    end
  end
  math.randomseed(os.time())
  local selected_index = math.random(#colorschemes_table)
  vim.cmd.colorscheme(colorschemes_table[selected_index])
end
select_colorscheme()

-- vim: ts=2 sts=2 sw=2 et
