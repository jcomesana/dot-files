-- Plugin nvim-cmp
local cmp = require('cmp')
cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
      expand = function(args)
      	vim.fn['vsnip#anonymous'](args.body)
      end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping({ i = cmp.mapping.confirm({ select = true }), c = cmp.mapping.confirm({ select = false }), }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
    { name = 'omni' },
  }
})

-- Plugin nvim-lspconfig and LSP settings

-- Plugin lsp_signature.nvim
local lsp_signature = require('lsp_signature')

lsp_signature.setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = 'rounded'
  },
  wrap = true,
  fix_pos = true,
  hint_enable = false,
  hint_prefix = '» ',
  hi_parameter = 'LspSignatureActiveParameter',
  always_trigger = true,
  timer_interval = 180,
  toggle_key = '<M-s>',
})

local on_attach = function(client, bufnr)
  lsp_signature.on_attach()

  vim.lsp.handlers['textDocument/hover'] =  vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})
  vim.lsp.handlers['textDocument/signatureHelp'] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})
  -- diagnostic
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
  })

  local signs = { Error = 'E ', Warn = 'W ', Hint = 'H ', Info = 'I ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

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
  buf_set_keymap('n', '<Leader>ll', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<Leader>lk', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<Leader>lj', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>lc', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
end

-- clients
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.pylsp.setup{
  on_attach = on_attach,
  capabilities = capabilities,
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
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

local extras_path = lspconfig.util.path.join(vim.api.nvim_eval('stdpath("config")'), 'extras')

local groovy_lsp_jar_path = lspconfig.util.path.join(extras_path, 'groovy-language-server-all.jar')
local groovy_lib = ''
if vim.env.GROOVY_HOME then
  groovy_lib = vim.env.GROOVY_HOME .. '/lib'
end
lspconfig.groovyls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { 'java', '-jar', groovy_lsp_jar_path },
  filetypes = { 'groovy', 'Jenkinsfile' },
  root_dir = lspconfig.util.root_pattern('.git', '.ignore', '.gitignore'),
  single_file_support = true,
  settings = {
    groovy = {
      classpath = { groovy_lib },
    }
  }
}

local efm_command = lspconfig.util.path.join(extras_path, 'efm-langserver', 'efm-langserver')
local efm_config = lspconfig.util.path.join(extras_path, 'efm-langserver', 'config.yaml')
lspconfig.efm.setup {
  init_options = {documentFormatting = true},
  cmd = {efm_command, '-c', efm_config},
  rootMarkers = {'.git', '.ignore'},
  filetypes = {'groovy', 'Jenkinsfile'},
  single_file_support = true,
  settings = {
  }
}

-- Plugin telescope
-- require 'telescope'.setup {
--   defaults = {
--     preview = {
--       check_mime_type = false
--     },
--   }
-- }

-- local map = vim.api.nvim_set_keymap
-- local default_map_opts = {noremap = true}
-- map('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files({ hidden=true, })<CR>", default_map_opts)
-- map('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", default_map_opts)
-- map('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", default_map_opts)
-- map('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", default_map_opts)
-- map('n', '<leader>fl', "<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>", default_map_opts)
-- map('n', '<leader>fc', "<cmd>lua require('telescope.builtin').git_commits()<CR>", default_map_opts)
-- map('n', '<leader>fR', "<cmd>lua require('telescope.builtin').lsp_references()<CR>", default_map_opts)
-- map('n', '<leader>ft', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", default_map_opts)
-- map('n', '<leader>fd', "<cmd>lua require('telescope.builtin').diagnostics()<CR>", default_map_opts)

-- Plugin trouble.nvim
require('trouble').setup {
  icons = false,
  fold_open = '-', -- icon used for open folds
  fold_closed = '+', -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  signs = {
    -- icons / text used for a diagnostic
    error = 'error',
    warning = 'warn',
    hint = 'hint',
    information = 'info'
  },
  use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
}

-- Plugin nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "python",
    "cpp",
    "yaml",
    "json",
    "cmake",
  },
}
