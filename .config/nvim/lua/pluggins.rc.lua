-- Plugin nvim-cmp
local cmp = require'cmp'
cmp.setup({
  snippet = {
      expand = function(args)
      	vim.fn["vsnip#anonymous"](args.body)
      end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping({ i = cmp.mapping.confirm({ select = true }), c = cmp.mapping.confirm({ select = false }), }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer",
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end },
    { name = "omni" },
  }
})

-- Plugin nvim-autopairs
require('nvim-autopairs').setup{
  enable_afterquote = true,
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- Plugin nvim-lspconfig
vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

-- LSP settings
local border = {
      {"🭽", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"🭾", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"🭿", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"🭼", "FloatBorder"},
      {"▏", "FloatBorder"},
}

local on_attach = function(client, bufnr)
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = false,
    update_in_insert = false,
  })

  require "lsp_signature".on_attach()

  local opts = { noremap=true, silent=true }
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<Leader>lD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<Leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>lR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<Leader>lk', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<Leader>lj', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>lc', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

-- clients
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local lspconfig = require'lspconfig'
lspconfig.pylsp.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    -- https://github.com/python-lsp/python-lsp-server/blob/develop/pylsp/config/schema.json
    pylsp = {
      plugins = {
        flake8 = {
          enabled = true,
          maxLineLength = 200,
        },
        pylint = {
          enabled = true,
        },
      }
    }
  }
}

lspconfig.clangd.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
}

local groovy_lsp_jar_path = lspconfig.util.path.join(vim.api.nvim_eval('stdpath("config")'), "extras", "groovy-language-server-all.jar")
local groovy_lib = ''
if vim.env.GROOVY_HOME then
  groovy_lib = vim.env.GROOVY_HOME .. '/lib'
end
lspconfig.groovyls.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { "java", "-jar", groovy_lsp_jar_path },
  filetypes = { "groovy", "Jenkinsfile" },
  root_dir = lspconfig.util.root_pattern('.git', '.ignore'),
  single_file_mode = true,
  settings = {
    groovy = {
      classpath = { groovy_lib },
    }
  }
}

-- Plugin lsp_signature.nvim
require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "single"
  },
  hint_enable = false,
  hint_prefix = "» ",
})

-- Plugin trouble.nvim
-- require("trouble").setup {
--   icons = false,
--   fold_open = "-", -- icon used for open folds
--   fold_closed = "+", -- icon used for closed folds
--   indent_lines = false, -- add an indent guide below the fold icons
--   signs = {
--     -- icons / text used for a diagnostic
--     error = "error",
--     warning = "warn",
--     hint = "hint",
--     information = "info"
--   },
--   use_lsp_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
-- }

-- Plugin nvim-treesitter
-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "maintained",
--   highlight = {
--     enable = true,
--     disable = {},
--   },
--   indent = {
--     enable = false,
--     disable = {},
--   },
--   ensure_installed = {
--     "python",
--     "cpp",
--     "yaml",
--     "json",
--     "cmake",
--   },
-- }
