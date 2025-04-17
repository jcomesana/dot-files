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

-- For lualine, to disable some options in narrow windows
local function is_narrow_window() return vim.fn.winwidth(0) < 100 end

-- To be able to use this for lualine
local diagnostics_signs = { Error = "", Warn = " ", Hint = "", Info = "" }

-- To detect if it is running on termux
local is_termux = not not vim.env.TERMUX_APP_PID

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
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
    border = "rounded",
  },
  rocks = { enabled = false },
}
if vim.env.NVIM_LAZY_CONCURRENCY then
  lazy_opts["concurrency"] = tonumber(vim.env.NVIM_LAZY_CONCURRENCY)
end

---@module "snacks"

require("lazy").setup({
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = {
        enabled = true,
        size = 20 * 1024 * 1024,
        ---@param ctx {buf: number, ft:string}
        setup = function(ctx)
          vim.bo[ctx.buf].bufhidden = "unload"
          vim.bo[ctx.buf].buftype = "nowrite"
          vim.bo[ctx.buf].undolevels = -1
          vim.bo[ctx.buf].undofile = false
          vim.bo[ctx.buf].swapfile = false
          vim.cmd([[NoMatchParen]])
          Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
          -- require("cmp").setup({ enabled = false })
        end,
      },
      dashboard = {
        enabled = true,
        width= 54,
        preset = {
          header = " Neovim v" .. tostring(vim.version()),
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files', { ignored = true, hidden = true })" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "t", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep', { ignored = true, hidden = true })" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰁜 ", key = "S", desc = "Select Session", action = ":PickerSessions" },
            {
              icon = "󰊢 ",
              key = "G",
              desc = "Lazygit",
              action = ":lua Snacks.lazygit()",
              enabled = function ()
                return Snacks.git.get_root() ~= nil
              end
            },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "startup", padding = 1 },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 2,
          },
        },
      },
      gitbrowse = {
        enabled = true,
      },
      indent = {
        enabled = true,
      },
      input = {
        enabled = true,
      },
      lazygit = {
        enabled = true,
        win = {
          width = 0.94,
          height = 0.94,
        },
      },
      notifier = {
        enabled = true,
        style = "fancy",
        timeout = 3500,
      },
      picker = {
        enabled = true,
        ui_select = true,
        win = {
          -- input window
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<F1>"] = { "toggle_help", mode = { "n", "i" } },
            }
          },
        },
      },
      quickfile = { enabled = true },
      scope = {
        enabled = true,
      },
      scratch = {
        enabled = true,
      },
      scroll = {
        enabled = false,
      },
      statuscolumn = {
        enabled = true,
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign", "SignifySign" },
        },
      },
      terminal = {
        enabled = true,
      },
      words = { enabled = true },
    },
    keys = {
      { "<Leader>G", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<Leader>gB", function() Snacks.gitbrowse() end, desc = "[G]it [B]rowse" },
      { "<Leader>gL", function() Snacks.git.blame_line() end, desc = "[G]it Blame [L]ine" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazy[G]it Current [F]ile History" },
      { "<Leader>nh", function() Snacks.notifier.show_history() end, desc = "[N]otifications [H]istory" },
      { "<C-s>", function() Snacks.terminal(vim.o.shell, { win = { style = "terminal", position = "right" } }) end, desc = "Toggle Terminal" },
      { "<Leader>wn", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "<Leader>wp", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      { "<Leader>s.", function() Snacks.scratch() end, desc = "Toggle [S]cratch Buffer" },
      { "<Leader>ss", function() Snacks.scratch.select() end, desc = "[S]elect a [S]cratch Buffer" },
      { "<Leader>pf", function() Snacks.picker.pick("files", { ignored = true, hidden = true }) end, desc = "[F]iles" },
      { "<Leader>pF", function() Snacks.picker.pick("files", { args = { vim.fn.expand("<cword>") }, ignored = true, hidden = true }) end, desc = "[F]ile under the cursor" },
      { "<Leader>pb", function() Snacks.picker.pick("buffers", { current = false }) end, desc = "[B]uffers" },
      { "<Leader>b", function() Snacks.picker.pick("buffers", { current = false }) end, desc = "[B]uffers" },
      { "<Leader>po", function() Snacks.picker.pick("recent") end, desc = "Recent or [O]ld files" },
      { "<Leader>pr", function() Snacks.picker.pick("grep", { ignored = true, hidden = true }) end, desc = "G[R]ep" },
      { "<Leader>pw", function() Snacks.picker.pick("grep_word", { ignored = true, hidden = true }) end, desc = "Grep [W]ord" },
      { "<Leader>pc", function() Snacks.picker.pick("grep_buffers") end, desc = "Buffers [c]ontent" },
      { "<Leader>pt", function() Snacks.picker.pick("treesitter") end, desc = "[t]reesitter" },
      { "<Leader>pM", function() Snacks.picker.pick("man") end, desc = "[M]an" },
      { "<Leader>pn", function() Snacks.picker.pick("notifications") end, desc = "[N]otifications" },
      { "<Leader>ph", function() Snacks.picker.pick("help") end, desc = "[H]elp" },
      { "<Leader>pi", function() Snacks.picker.pick("icons", { icon_sources = { "nerd_fonts" } }) end, desc = "[I]cons" },
      { "<Leader>pgb", function() Snacks.picker.pick("git_branches",
          {
            all = true,
            win = {
              input = {
                keys = {
                  ["<c-a>"] = { "git_branch_add", mode = { "n", "i" } },
                  ["<c-x>"] = { "git_branch_del", mode = { "n", "i" } },
                  ["<c-y>"] = { "yank_branch", mode = { "n", "i" }, desc = "yank branch name" },
                },
              },
            },
            actions = {
              yank_branch = { action = "yank", field = "branch" }
            },
          }) end, desc = "[G]it [B]ranches" },
      { "<Leader>pgs", function() Snacks.picker.pick("git_status") end, desc = "[G]it [S]tatus" },
      { "<Leader>pl", function() Snacks.picker.pick("loclist") end, desc = "[L]oc[L]ist" },
      { "<Leader>pq", function() Snacks.picker.pick("qflist") end, desc = "[Q]flist" },
      { "<Leader>pm", function() Snacks.picker.pick("resume") end, desc = "Resu[m]e last query" },
    },
  },

  {
    -- A session manager
    "olimorris/persisted.nvim",
    lazy = false, -- make sure the plugin is always loaded at startup
    opts = {
      autostart = false,
      use_git_branch = true,
    },
    config = true
  },

  {
    -- Diff integration
    "sindrets/diffview.nvim",
    config = true,
    cmd = { "DiffviewOpen", "DiffviewFileHistory" }
  },

  -- Git, P4
  "mhinz/vim-signify",

  -- Detect tabstop and shiftwidth automatically
  {
    "tpope/vim-sleuth",
    event = "VeryLazy",
  },

  -- Remember last position
  "farmergreg/vim-lastplace",

  -- Auto pairs completion
  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {
        map = "<M-w>",
      },
    },
    event = "InsertEnter",
  },

  -- To surround words, lines with " or [
  {
    "machakann/vim-sandwich",
    event = "InsertEnter",
  },

  -- To close html or xml tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true -- Auto close on trailing </
      },
    }
  },

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    event = "InsertEnter",
    opts = {}
  },

  -- Better handling of dangling spaces
  {
    "cappyzawa/trim.nvim",
    opts = {
      ft_blocklist = { "markdown", "oil" },
      highlight = true,
      trim_on_write = false,
      trim_trailing = true,
      trim_last_line = true,
      trim_first_line = true,
    },
    event = "VeryLazy",
  },

  -- To diff specific parts of 2 files
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff"
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        config = true,
      },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  },

  {
    -- Better LSP signature help
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
  },

  {
    -- Code actions indicator
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      sign = {
        text = "󱠂",
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
        clients = { "ruff" },
        actions_without_kind = true,
      },
    },
  },

  {
    -- Integrates linters with the diagnostics system
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
  },

  {
    -- To display diagnostics
    "folke/trouble.nvim",
    opts = {
      auto_preview = false,
    },
    event = "VeryLazy",
  },

  {
    -- For using LuaLS with neovim config files
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = "make install_jsregexp",
        version = "v2.*",
        dependencies = {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end
        },
      },
      "giuxtaposition/blink-cmp-copilot",
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "default",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-h>"] = { "show_documentation", "hide_documentation", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = {
          auto_show = true
        },
        menu = {
          draw = {
            columns = { { "kind_icon", "kind", gap = 1 }, { "label", "label_description", gap = 1 },  },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "snippets", "buffer", "copilot" },

        providers = {
          snippets = {
            min_keyword_length = 1,
            score_offset = 4,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      signature = {
        enabled = true,
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },

  -- Useful plugin to show you pending keybinds.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
    }
  },

  {
    -- File navigation
    "stevearc/oil.nvim",
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = { "icon", "size", "mtime", "permissions" },
      view_options = {
        show_hidden = true,
      },
      win_options = {
        signcolumn = "yes:2",
        statuscolumn = "",
      },
      constrain_cursor = "editable",
      keymaps = {
        ["\\o?"] = "actions.show_help",
        ["\\os"] = "actions.select_vsplit",
        ["\\oh"] = "actions.select_split",
        ["\\ot"] = "actions.select_tab",
        ["\\ow"] = "actions.preview",
        ["\\ol"] = "actions.add_to_loclist",
        ["\\oq"] = "actions.close",
        ["\\or"] = "actions.refresh",
        ["\\op"] = "actions.copy_entry_path",
        ["\\of"] = "actions.copy_entry_filename",
        ["\\oo"] = "actions.change_sort",
        ["\\oe"] = "actions.open_external",
        ["\\ox"] = {
          callback = function ()
            local opts = {
              cwd = require("oil").get_current_dir(),
              win = { style = "terminal", position = "right" },
            }
            Snacks.terminal(vim.o.shell, opts)
          end,
          desc = "Open a terminal in current directory",
          mode = "n"
        },
        ["\\o."] = "actions.toggle_hidden",
        ["\\ob"] = "actions.toggle_trash",
        ["\\oz"] = {
          callback = function()
            require("fzf-lua").files({ cwd = require("oil").get_current_dir() })
          end,
          desc = "Find files with fzf-lua",
          mode = "n"
        },
        ["\\og"] = {
          callback = function()
            require("fzf-lua").live_grep_native({ cwd = require("oil").get_current_dir() })
          end,
          desc = "Grep files with fzf-lua",
          mode = "n"
        },
        ["\\oF"] = {
          callback = function()
            Snacks.picker("files", { cwd = require("oil").get_current_dir(), ignored = true, hidden = true })
          end,
          desc = "Find files with Snacks.picker",
          mode = "n"
        },
        ["\\oG"] = {
          callback = function()
            Snacks.picker("grep", { cwd = require("oil").get_current_dir(), ignored = true, hidden = true })
          end,
          desc = "Grep files with Snacks.picker",
          mode = "n"
        },
      },
    }
  },
  {
      "FerretDetective/oil-git-signs.nvim",
      ft = "oil",
      opts = {},
  },

  {
    -- Secure mode lines
    "ciaranm/securemodelines"
  },

  -- nvim-web-devicons
  { "nvim-tree/nvim-web-devicons" },
  { "echasnovski/mini.icons", opts = {} },

  -- Colorschemes
  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
  },
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000,
  },
  {
    "drewtempelmeyer/palenight.vim",
    priority = 1000,
  },
  {
    "eldritch-theme/eldritch.nvim",
    priority = 1000,
  },
  {
    "embark-theme/vim",
    name = "embark",
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "oonamo/ef-themes.nvim",
    priority = 1000,
  },
  {
    "sainnhe/everforest",
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = {
          { "mode", fmt = function(str) return is_narrow_window() and str:sub(1, 3) or str end },
        },
        lualine_b = {
          {
            "filename",
            symbols = {
              readonly = "[RO]",
            },
          },
        }, -- lualine_b
        lualine_c = {"branch",
                     "diff",
                     {
                      "diagnostics",
                      symbols = { error = diagnostics_signs["Error"] .. " ",
                                  warn = diagnostics_signs["Warn"] .. " ",
                                  hint = diagnostics_signs["Hint"] .. " ",
                                  info = diagnostics_signs["Info"] .. " ",
                      },
                      on_click = function() require("trouble").toggle({ mode = "diagnostics", focus = false }) end,
                     },
        }, -- lualine_c
        lualine_x = {
                      {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        color = { fg = "#ff9e64" },
                        on_click = function() vim.cmd("Lazy sync") end
                      },
                      { "lsp_status", ignore_lsp = { "copilot" } },
                      "copilot",
                      "searchcount",
                      "encoding",
                      { "fileformat", fmt = function(str) return is_narrow_window() and "" or str end },
                      { "filetype", fmt = function(str) return is_narrow_window() and str:sub(1, 1) or str end },
        },
        lualine_y = { { "progress", fmt = function(str) return is_narrow_window() and "" or str end } },
        lualine_z = {"location"},
      },
      inactive_sections = {
        lualine_b = {
          {
            "filename",
            symbols = {
              readonly = "[RO]",
            },
          },
        }, -- lualine_b
        lualine_c = {},
      },
      extensions = {
        "fugitive",
        "toggleterm",
        "trouble",
        {
          sections = {
            lualine_a = {
                function()
                    local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
                    local adapter_url, path = require("oil.util").parse_url(buf_name)
                    assert(adapter_url ~= nil and path ~= nil, "invalid oil url")

                    local adapter_name = require("oil.config").adapters[adapter_url]

                    return ("%s: %s"):format(adapter_name:upper(), vim.fn.fnamemodify(path, ":~"))
                end,
            },
            lualine_b = {
                "branch",
                "oil_git_signs_diff",
            },
            lualine_x = {},
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
          filetypes = { "oil" },
        },
      },
    },
  },

  {
    -- Library used by several plugins
    "nvim-lua/plenary.nvim",
  },

  -- FZF
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- Provide context based on treesitter
      "nvim-treesitter/nvim-treesitter-context",
      -- Indentation engine
      "yioneko/nvim-yati",
    },
    build = ":TSUpdate",
  },

  {
    -- auto-save plugin
    "okuuva/auto-save.nvim",
    version = "*",
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      debounce_delay = 20000,
    },
  },

  {
    -- GUI shim
    "equalsraf/neovim-gui-shim",
    cond = vim.fn.has("gui_running") == 1,
  },

  {
    -- Copilot
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {},
  },

  {
    "AndreM222/copilot-lualine"
  },

  {
    "olimorris/codecompanion.nvim",
    opts = {
      send_code = false,
    },
  },

  -- File type specific plugins
  {
    "blankname/vim-fish",
    ft = "fish"
  },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    ft = "Jenkinsfile"
  },
  {
    "PProvost/vim-ps1",
    ft = "ps1"
  },
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python"
  },
  {
    "MTDL9/vim-log-highlighting",
    ft = "log"
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  },

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
vim.o.fixeol = vim.env.NVIM_FIXEOL == "0" and false or (vim.env.NVIM_FIXEOL == "1" or not vim.env.NVIM_FIXEOL)

-- UI Config --
vim.o.title = true
vim.o.modeline = true
vim.wo.number = true
vim.o.showmode = false
vim.o.showcmd = true
vim.o.cmdheight = 2
vim.o.history = 50
vim.o.wildmenu = true
vim.o.wildignore = "*.bak,*.o,*~,*.pyc,*.lib,*.swp"
vim.o.wildoptions = "pum,tagfile"
vim.o.shortmess = "atc"
vim.o.lazyredraw = false
vim.o.updatetime = 250
vim.o.cursorline = false
vim.o.ruler = true
vim.o.laststatus = 2
vim.o.visualbell = true
vim.o.belloff = "all"
vim.o.errorbells = false
vim.o.encoding = "utf8"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.clipboard = "unnamedplus"
vim.o.timeout = true
vim.o.timeoutlen = 2000
vim.o.ttimeoutlen = 100
vim.o.display = "lastline,msgsep"
vim.o.sidescroll = 1
vim.o.scrolloff = 4
vim.o.ttyfast = true
vim.o.listchars = "tab:> ,trail:-,extends:>,precedes:<,nbsp:␣"
vim.o.report = 0
vim.o.guicursor = "n-v-c:block,i-ci-ve:ver45,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff600-blinkon450-Cursor/lCursor,sm:block-blinkwait175-blinkoff350-blinkon375"
vim.o.pumwidth = 32
if vim.fn.has("nvim-0.11") == 1 then
  vim.o.winborder = "rounded"
end

-- Syntax highlighting --
vim.o.syntax = "ON"
vim.g["python_highlight_all"] = 1

-- Searching --
vim.o.incsearch = true
vim.o.inccommand = "split"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Indentation and formating --
vim.o.autoindent = true
vim.o.breakindent = true
vim.o.preserveindent = true
vim.o.copyindent = true
vim.o.smartindent = true
vim.o.cinkeys = "0{,0},0),:,0#,!^F,o,O,e,;,.,-,*<Return>,;,="
vim.o.cinoptions = ">s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(s,us,U0,w0,m0,j0,)20,*30"
vim.o.formatoptions = "cqtjro"

-- Folding --
vim.o.foldenable = true
vim.o.foldlevelstart = 10
vim.o.foldnestmax = 10
vim.o.foldmethod = "syntax"

-- Movement --
vim.o.backspace = "indent,eol,start" -- allow backspacing over everything in insert mode
vim.o.whichwrap = "<,>,[,]" -- wrap lines only with arrow keys
vim.o.startofline = false

-- Completion --
vim.o.completeopt = "menuone,noselect"

-- Backups, autoread
local backups_dir = vim.fn.stdpath "config" .. "/backups"
vim.o.undofile = true
vim.o.backup = true
vim.o.backupdir = backups_dir
vim.o.fsync = false
vim.o.autoread = true
vim.o.autowrite = true

-- Session
vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

-- Enable mouse mode
vim.o.mouse = "a"

-- Color Scheme options
vim.o.background = "dark"
vim.o.termguicolors = true

-- Disable some providers
vim.g["loaded_python_provider"] = false
vim.g["loaded_perl_provider"] = false
vim.g["loaded_node_provider"] = false
vim.g["loaded_ruby_provider"] = false

vim.g["python3_host_prog"] = "python3"
vim.g["python_recommended_style"] = 0

-- [[ Keymaps ]]

-- remaps for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Page up and down and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { expr = false, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { expr = false, silent = true })

-- move through buffers with F8 and F9
vim.keymap.set("n", "<F8>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Go to previous buffer" })
vim.keymap.set("n", "<F9>", ":bnext<CR>", { noremap = true, silent = true, desc = "Go to next buffer"  })
-- to skip the quicklist buffer when going through buffers
local qf_augroup = vim.api.nvim_create_augroup("qf", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  group = qf_augroup,
  command = "set nobuflisted"
})

-- Disable highlighting and redraw
vim.keymap.set({ "n", "v" }, "<Space>", ":noh<CR>:syn sync fromstart<CR>:redrawstatus<CR>", { silent = true })

-- Keymaps to copy the current filename to the clipboard
vim.keymap.set("n", ",cs", ':let @+=expand("%")<CR>', { noremap = true, silent = false, desc = "Copy short file name to clipboard" })
vim.keymap.set("n", ",cl", ':let @+=expand("%:p")<CR>', { noremap = true, silent = false, desc = "Copy long file name to clipboard" })

-- Copy the current buffer
vim.keymap.set("n", ",yA", ":%y<CR>", { noremap = true, silent = false, desc = "[Y]ank [A]ll" })

-- Split windows
vim.keymap.set("n", "<Leader>ih", ":split<CR>", { noremap = true, silent = false, desc = "[H]orizontal window spl[i]t" })
vim.keymap.set("n", "<Leader>iv", ":vsplit<CR>", { noremap = true, silent = false, desc = "[V]ertical window spl[i]t" })
vim.keymap.set("n", "<Leader>in", ":vsplit<CR>:bnext<CR>", { noremap = true, silent = false, desc = "[V]ertical window split & [N]ext buffer" })
vim.keymap.set("n", "<Leader>ip", ":vsplit<CR>:bprevious<CR>", { noremap = true, silent = false, desc = "[V]ertical window split & [P]revious buffer" })

-- Remove empty lines
vim.keymap.set("n", "<Leader>se", ":g/^$/d<CR>", { noremap = true, silent = false, desc = "Remove [E]mpty lines" })

-- Remove leading spaces
vim.keymap.set("n", "<Leader>sb", ":%s/^\\s\\+//ge<CR>", { noremap = true, silent = false, desc = "Remove spaces at the [B]egining of the line" })

-- Keymaps for P4 operations
vim.keymap.set("n", "<Leader>p4a", ':!p4 add "%"<CR>', { noremap = true, silent = false, desc = "P4 open for [a]dd" })
vim.keymap.set("n", "<Leader>p4e", ':!p4 edit "%"<CR>', { noremap = true, silent = false, desc = "P4 open for [e]dit" })
vim.keymap.set("n", "<Leader>p4r", ':!p4 revert "%"<CR>', { noremap = true, silent = false, desc = "P4 [r]evert" })

-- Keymaps for Git operations
vim.keymap.set("n", "<Leader>gp", ':!git pull && git submodule update --init --recursive<CR>', { noremap = true, silent = false, desc = "Git pull and submodules" })

-- which-key
vim.keymap.set("n", "<Leader>wk", "<CMD>WhichKey<CR>", { noremap = true, silent = false, desc = "[W]hich [K]ey" })

-- Make current file executable
vim.keymap.set("n", "<Leader>sx", ":!chmod +x %<CR>", { noremap = true, silent = false, desc = "Make current [S]cript e[X]ecutable" })

-- Custom commands
-- CDC = Change to Directory of Current file
vim.api.nvim_create_user_command("CDC", "cd %:p:h", {})

-- [[ Workaround for autoread not working, use autocommands ]]
local autoread_fix_augroup = vim.api.nvim_create_augroup("autoread_fix", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  group = autoread_fix_augroup,
  command = "if mode() != 'c' | checktime | endif"
})
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  group = autoread_fix_augroup,
  callback = function (ev)
    if ev.file ~= nil then
      local filename = vim.fs.basename(ev.file)
      Snacks.notify.warn(("File `%s` changed on disk. Buffer reloaded."):format(filename), { title = "File modified" })
    end
  end
})

-- [[ New filetypes ]]
vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
    ["Jenkinsfile"] = "groovy",
    ["Jenkinsfile.*"] = "groovy",
    ["*.Jenkinsfile"] = "groovy",
  },
  extension = {
    ["jobdsl"] = "groovy"
  }
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Configure fzf-lua ]]
require("fzf-lua").setup({
  "fzf-native",
  fzf_colors = true,
  grep = {
    rg_opts = "--no-ignore-vcs " .. require("fzf-lua").defaults.grep.rg_opts
  },
  lsp = {
    -- make lsp requests synchronous so they work with null-ls
    async_or_timeout = 3000,
  },
})

vim.keymap.set("n", "<Leader>ff", require("fzf-lua").files, { desc = "FZF Files" })
vim.keymap.set("n", "<Leader>fF", function()
  return require("fzf-lua").files({ cmd = "fd --hidden --no-ignore-vcs --exclude .git/ " .. vim.fn.expand("<cword>") })
end, { desc = "[F]iles under cursor" })
vim.keymap.set("n", "<Leader>fo", require("fzf-lua").oldfiles, { desc = "Recent or [O]ld files" })
vim.keymap.set("n", "<Leader>fr", require("fzf-lua").grep, { desc = "G[R]ep" })
vim.keymap.set("n", "<Leader>fv", require("fzf-lua").grep_visual, { desc = "Grep [V]isual selection" })
vim.keymap.set("n", "<Leader>fn", require("fzf-lua").live_grep_native, { desc = "Live grep [N]ative" })
vim.keymap.set("n", "<Leader>fp", require("fzf-lua").grep_project, { desc = "Grep [P]roject" })
vim.keymap.set("n", "<Leader>fm", require("fzf-lua").live_grep_resume, { desc = "Resu[m]e last query" })
vim.keymap.set("n", "<Leader>fw", require("fzf-lua").grep_cword, { desc = "Ripgrep with word under cursor" })
vim.keymap.set("n", "<Leader>fc", require("fzf-lua").lines, { desc = "FZF Lines of open buffers" })
vim.keymap.set("n", "<Leader>fgc", require("fzf-lua").git_commits, { desc = "[G]it [C]ommits" })
vim.keymap.set("n", "<Leader>fgh", require("fzf-lua").git_bcommits, { desc = "[G]it buffer commits ([H]istory)" })
vim.keymap.set("n", "<Leader>fgb", require("fzf-lua").git_branches, { desc = "[G]it [B]ranches" })
vim.keymap.set("n", "<Leader>fgf", require("fzf-lua").git_files, { desc = "[G]it [F]iles" })
vim.keymap.set("n", "<Leader>fgs", require("fzf-lua").git_status, { desc = "[G]it [S]tatus" })
vim.keymap.set("n", "<Leader>fd", require("fzf-lua").diagnostics_workspace, { desc = "[D]iagnostics" })
vim.keymap.set("n", "<Leader>fh", require("fzf-lua").helptags, { desc = "[H]elp tags" })
vim.keymap.set("n", "<Leader>fla", require("fzf-lua").lsp_code_actions, { desc = "[L]SP [A]ctions" })
vim.keymap.set("n", "<Leader>flf", require("fzf-lua").lsp_finder, { desc = "[L]SP [F]inder" })
vim.keymap.set("n", "<Leader>flr", require("fzf-lua").lsp_references, { desc = "[L]SP [R]eferences" })
vim.keymap.set("n", "<Leader>fls", require("fzf-lua").lsp_document_symbols, { desc = "[L]SP document [s]ymbols" })
vim.keymap.set("n", "<Leader>flS", require("fzf-lua").lsp_workspace_symbols, { desc = "[L]SP workspace [S]ymbols" })
vim.keymap.set("n", "<Leader>ft", require("fzf-lua").treesitter, { desc = "[T]reesitter symbols" })
vim.keymap.set("n", "<Leader>fll", require("fzf-lua").loclist, { desc = "[L]oc[L]ist" })
vim.keymap.set("n", "<Leader>fq", require("fzf-lua").quickfix, { desc = "[Q]uickfix" })
vim.keymap.set("n", "<Leader>fM", require("fzf-lua").manpages, { desc = "[M]an" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of "nvim {filename}"
vim.defer_fn(function()
---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { "c", "cmake", "cpp", "dockerfile", "groovy", "html", "java", "json", "kotlin", "lua", "python", "regex", "rust", "swift", "toml", "vimdoc", "vim", "xml", "yaml", "yang" },

    auto_install = false,
    sync_install = false,
    ignore_install = {},

    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { "groovy", "python", "xml", }
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "]<space>",
        node_incremental = "]<space>",
        scope_incremental = "]i",
        node_decremental = "]d",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  }
end, 0)

-- [[ Diagnostics ]]
local diagnostic_opts = {
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    scope = "line",
    source = true,
    severity_sort = true,
  },
}
if vim.fn.has("nvim-0.11") == 1 then
  diagnostic_opts["virtual_lines"] = { current_line = true }
  diagnostic_opts["signs"] = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostics_signs["Error"],
      [vim.diagnostic.severity.WARN]  = diagnostics_signs["Warn"],
      [vim.diagnostic.severity.HINT]  = diagnostics_signs["Hint"],
      [vim.diagnostic.severity.INFO]  = diagnostics_signs["Info"],
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    },
  }
else
  for type, icon in pairs(diagnostics_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end
vim.diagnostic.config(diagnostic_opts)

-- Diagnostic keymaps
if vim.fn.has("nvim-0.11") == 1 then
  vim.keymap.set("n", "[d", function ()
    vim.diagnostic.jump({ count = -1, float = false })
  end, { desc = "Go to previous diagnostic message" })
  vim.keymap.set("n", "]d", function ()
    vim.diagnostic.jump({ count = 1, float = false })
  end, { desc = "Go to next diagnostic message" })
else
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
end
vim.keymap.set("n", "<Leader>dm", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<Leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure trouble.nvim ]]
vim.keymap.set("n", "<Leader>xd", "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>", { noremap = true, silent = true, desc = "Toggle trouble.nvim with diagnostics" })
vim.keymap.set("n", "<Leader>xl", "<cmd>Trouble lsp toggle focus=false<cr>", { noremap = true, silent = true, desc = "Toggle trouble.nvim with lsp" })

-- [[ Configure LSP ]]
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.npm_groovy_lint.with({ filetypes = { "groovy", "Jenkinsfile" }, })
  },
})

vim.lsp.inlay_hint.enable()

-- [[ Configure lsp_signature ]]
require("lsp_signature").setup({
  bind = true, -- This is mandatory, otherwise border config won"t get registered.
  doc_lines = 4,
  handler_opts = {
    border = "rounded"
  },
  hint_enable = false,
  hint_prefix = "» ",
  always_trigger = true,
  fix_pos = true,
})

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don"t have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  require "lsp_signature".on_attach()

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<Leader>ln", vim.lsp.buf.rename, "Re[N]ame")
  nmap("<Leader>la", vim.lsp.buf.code_action, "Code [A]ction")
  nmap("<Leader>ld", vim.lsp.buf.definition, "Goto [D]efinition")
  nmap("<Leader>lr", require("fzf-lua").lsp_references, "[R]eferences")
  nmap("<Leader>li", require("fzf-lua").lsp_implementations, "Goto [I]mplementation")
  nmap("<Leader>lt", require("fzf-lua").lsp_typedefs, "[T]ype Definition")
  nmap("<Leader>lm", require("fzf-lua").lsp_document_symbols, "Document Sy[M]bols")
  nmap("<Leader>lh", vim.lsp.buf.hover, "[H]over Documentation")
  nmap("<Leader>ls", vim.lsp.buf.signature_help, "[S]ignature Documentation")
  nmap("<Leader>ly", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, "Toggle inla[Y] hints")

  -- Lesser used LSP functionality
  nmap("<Leader>lD", vim.lsp.buf.declaration, "Goto [D]eclaration")
  nmap("<Leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<Leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<Leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

if vim.fn.has("nvim-0.11") == 0 then
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end
-- Enable the language servers
local groovy_lsp_classpath = {}
if vim.env.GROOVY_HOME then
  local groovy_lib = vim.env.GROOVY_HOME .. "/lib"
  table.insert(groovy_lsp_classpath, groovy_lib)
end

local lsp_servers = {
  clangd = {
    mason = false,
    cmd = {
      "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu"
    },
  },

  dockerls = {
    mason = not is_termux,
  },

  docker_compose_language_service = {
    mason = not is_termux,
  },

  groovyls = {
    mason = not is_termux,
    filetypes = { "groovy", "Jenkinsfile"},
    settings = {
      groovy = {
        classpath = groovy_lsp_classpath,
      },
    },
    cmd = { "groovy-language-server" },
  },

  lua_ls = {
    mason = not is_termux,
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },

  pylsp = {
    settings = {
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
            args = {"--max-line-length 200"}
          },
        }
      },
    },
  },

  ruff = {
    mason = not is_termux,
  },

  rust_analyzer = {
    mason = not is_termux,
    skip_lspconfig_setup = true,
  },

  sourcekit = {
    mason = false,
    filetypes = { "swift" }
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require "mason-lspconfig"

vim.g.rustaceanvim = {
  server = {
    cmd = function()
local mason_registry = require("mason-registry")
if mason_registry.is_installed("rust-analyzer") then
	-- This may need to be tweaked depending on the operating system.
	local ra = mason_registry.get_package("rust-analyzer")
	local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
	return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
else
	-- global installation
	return { "rust-analyzer" }
end
    end,
    on_attach = on_attach,
  },
}

local lsp_servers_handled_with_mason = {}
if (not is_termux) then
  table.insert(lsp_servers_handled_with_mason, { "npm-groovy-lint", version = "15.1.0" })
end

for server_name, server_config in pairs(lsp_servers) do
  if server_config.mason or server_config.mason == nil then
    table.insert(lsp_servers_handled_with_mason, server_name)
  else
    -- Manualy handled LSP servers
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = (server_config or {}).settings,
      filetypes = (server_config or {}).filetypes,
      cmd = (server_config or {}).cmd,
      flags = (server_config or {}).flags,
    }
  end
end
require("mason-tool-installer").setup {
  ensure_installed = lsp_servers_handled_with_mason,
  auto_update = true,
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local server_config = lsp_servers[server_name] or {}
    if not server_config.skip_lspconfig_setup then
      require("lspconfig")[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = server_config.settings,
        filetypes = server_config.filetypes,
        cmd = server_config.cmd,
        flags = server_config.flags,
      }
    end
  end
}

-- [[ Configure signify ]]
vim.g["signify_sign_add"]               = "+"
vim.g["signify_sign_delete"]            = "-"
vim.g["signify_sign_delete_first_line"] = "‾"
vim.g["signify_sign_change"]            = "*"
vim.g["signify_sign_change_delete"]     = "d"
vim.keymap.set("n", "<Leader>gh", "<CMD>SignifyHunkDiff<CR>", { noremap = true, silent = false, desc = "Si[g]nify [H]unk diff" })
vim.keymap.set("n", "<Leader>gd", "<CMD>SignifyDiff<CR>", { noremap = true, silent = false, desc = "Si[g]nify [D]iff" })
vim.keymap.set("n", "<Leader>gu", "<CMD>SignifyHunkUndo<CR>", { noremap = true, silent = false, desc = "Si[g]nify hunk [U]ndo" })

-- [[ Configure vim-sandwich ]]
vim.g["sandwich#recipes"] = vim.deepcopy(vim.g["sandwich#default_recipes"])

-- [[ Configure oil ]]
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<Leader>od", "<CMD>Oil " .. vim.fn.stdpath("data") .. "<CR>", { desc = "Open [D]ata directory" })
vim.keymap.set("n", "<Leader>ol", "<CMD>Oil " .. vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") .. "<CR>", { desc = "Open [L]azy data directory" })

-- [[ Configure trim.nvim ]]
vim.keymap.set("n", "<Leader>st", "<CMD>Trim<CR>", { noremap = true, silent = true, desc = "Trim [T]railing whitespace" })

-- [[ Configure persisted.nvim ]]

local persisted_config = require("persisted.config")

local function get_session_name_and_branch(session_file)
  local file = session_file:sub(#persisted_config.save_dir + 1, -5)
  local dir_path, branch = unpack(vim.split(file, "@@", { plain = true }))
  dir_path = dir_path:gsub("%%", "/")
  if jit.os:find("Windows") then
    dir_path = dir_path:gsub("^(%w)/", "%1:/")
  end

  dir_path = vim.fn.fnamemodify(dir_path, ":p:~"):sub(3, -2)
  if branch then
    return dir_path .. "  (" .. branch .. ")", branch
  end
  return dir_path, nil
end

local function get_persisted_sessions()
	local items = {}
	local sessions_list = require("persisted").list()
  for _, session_file in ipairs(sessions_list) do
    local session_name, branch = get_session_name_and_branch(session_file)
		table.insert(items, { text = session_name, file = session_file, branch = branch })
  end
	return items
end

function Show_persisted_sessions()
  Snacks.picker.pick({
	  source = "persisted",
	  finder = get_persisted_sessions,
	  preview = "none",
	  layout = { preset = "vscode" },
	  title = "Persisted Sessions",
	  format = "text",
	  confirm = function(picker, item)
		  picker:close()
      vim.api.nvim_input("<ESC>:%bd!<CR>")
      vim.schedule(function()
		    require("persisted").load({ session = item.file})
      end)
	  end,
	  actions = {
	    delete_session = function(picker)
        local uv = vim.uv or vim.loop
        for _, selected_item in ipairs(picker:selected({ fallback = true })) do
	        local selected_session_file = selected_item.file
	        if selected_session_file and uv.fs_stat(selected_session_file) then
            if vim.fn.confirm("Delete [" .. selected_item.text .. "]?", "&Yes\n&No") == 1 then
              vim.fn.delete(selected_item.file)
            end
	        end
          picker.list:unselect(selected_item)
	      end
        local cursor = picker.list.cursor
        picker:find({
          on_done = function()
            picker.list:view(cursor)
          end,
        })
	    end
	  },
    win = {
      input = {
        keys = {
          ["<c-x>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete session" },
        },
      },
    },
  })
end
vim.api.nvim_create_user_command("PickerSessions", ":lua Show_persisted_sessions()", {})

vim.keymap.set("n", "<Leader>pS", Show_persisted_sessions, { noremap = true, silent = true, desc = "Persisted [S]essions" })
vim.keymap.set("n", "<Leader>mr", "<CMD>SessionStart<CR>", { noremap = true, silent = false, desc = "Start [R]ecording session" })
vim.keymap.set("n", "<Leader>mt", "<CMD>SessionStop<CR>", { noremap = true, silent = false, desc = "S[T]op recording session" })
vim.keymap.set("n", "<Leader>mv", "<CMD>SessionSave<CR>", { noremap = true, silent = false, desc = "Session sa[V]e" })
vim.keymap.set("n", "<Leader>ml", "<CMD>SessionLoad<CR>", { noremap = true, silent = false, desc = "Session [L]oad for current dir" })
vim.keymap.set("n", "<Leader>ms", "<CMD>PickerSessions<CR>", { noremap = true, silent = false, desc = "Session [S]elect" })

local persisted_group = vim.api.nvim_create_augroup("persisted_group", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistedStart",
  callback = function()
    Snacks.notify.info("Session started", { title = "persisted.nvim" })
  end,
  group = persisted_group,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistedStop",
  callback = function()
    Snacks.notify.info("Session stopped", { title = "persisted.nvim" })
  end,
  group = persisted_group,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistedLoadPost",
  callback = function()
    local message = "Session loaded"
    if vim.g.persisted_loaded_session then
      local session_name, branch = get_session_name_and_branch(vim.g.persisted_loaded_session)
      message = ("%s: `%s`"):format(message, session_name)
      if branch then
        local dir_branch = vim.fn.systemlist("git branch --show-current")[1]
        if vim.v.shell_error == 0 and dir_branch and branch ~= dir_branch then
          vim.fn.systemlist("git switch " .. branch)
          if vim.v.shell_error == 0 then
            Snacks.notify.info(("Switched to git branch: `%s`"):format(branch), { title = "picker" })
          end
        end
      end
    end
    Snacks.notify.info(message, { title = "persisted.nvim" })
  end,
  group = persisted_group,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "PersistedSavePost",
  callback = function()
    Snacks.notify.info("Session saved", { title = "persisted.nvim" })
  end,
  group = persisted_group,
})

-- [[ Configure nvim-jenkinsfile-linter ]]
if vim.env.JENKINS_URL then
  vim.keymap.set("n", "<Leader>jv", require("jenkinsfile_linter").validate, { noremap = true, silent = false, desc = "Jenkinsfile Validation" })

  -- Run with autocommand too
  local jenkinsfile_linter_group = vim.api.nvim_create_augroup("jenkinsfile_linter_group", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost" }, {
    pattern = {"*.Jenkinsfile"},
    callback = require("jenkinsfile_linter").validate,
    group = jenkinsfile_linter_group
  })
end

-- [[ Configuration for auto-save ]]
local autosave_augroup = vim.api.nvim_create_augroup("autosave", {})

vim.api.nvim_create_autocmd("User", {
    pattern = "AutoSaveWritePost",
    group = autosave_augroup,
    callback = function(opts)
      if opts.data.saved_buffer ~= nil then
        local filename = vim.fs.basename(vim.api.nvim_buf_get_name(opts.data.saved_buffer))
        if filename ~= "/" and filename ~= "" then
          Snacks.notify.info(("File saved: `%s`"):format(filename), { title = "auto-save" })
        end
      end
    end,
})

-- [[ random colorscheme ]]

local function select_colorscheme()
  local colorschemes_table = {}
  local excluded_colorschemes = {
    "blue",
    "darkblue",
    "default",
    "delek",
    "desert",
    "elflord",
    "evening",
    "habamax",
    "industry",
    "koehler",
    "lunaperche",
    "morning",
    "murphy",
    "pablo",
    "peachpuff",
    "quiet",
    "retrobox",
    "ron",
    "shine",
    "slate",
    "sorbet",
    "torte",
    "unokai",
    "vim",
    "wildcharm",
    "zaibatsu",
    "zellner",
    "tokyonight-day",
    "dayfox",
    "dawnfox",
    "midnightgreen",
    "ef-deuteranopia-light",
    "ef-duo-light",
    "ef-light",
    "ef-owl",
    "ef-reverie",
    "ef-summer",
    "ef-trio-light",
  }

  local color_files = vim.fn.globpath(vim.o.runtimepath, "colors/*.vim", false, true)
  for _, lua_color_file in ipairs(vim.fn.globpath(vim.o.runtimepath, "colors/*.lua", false, true)) do
    table.insert(color_files, lua_color_file)
  end
  for _, color_file in ipairs(color_files) do
    local colorscheme_name = vim.fn.fnamemodify(color_file, ":t:r")
    if (not vim.tbl_contains(excluded_colorschemes, colorscheme_name)) then
      table.insert(colorschemes_table, colorscheme_name)
    end
  end
  math.randomseed(os.time())
  local selected_index = math.random(#colorschemes_table)
  vim.cmd.colorscheme(colorschemes_table[selected_index])
  -- Snacks.notify.info(("  `%s`"):format(colorschemes_table[selected_index]), { title = "colorscheme" })
end
select_colorscheme()

-- Fix for neovide on macOS
if vim.fn.exists("g.neovide") and vim.fn.has("macunix") == 1 then
  if vim.fn.getcwd() == "/" then
    vim.cmd("cd ~")
  end
end

-- vim: ts=2 sts=2 sw=2 et
