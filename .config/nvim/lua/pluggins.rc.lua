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
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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

local keymap_opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>ll', vim.diagnostic.open_float, keymap_opts)
vim.keymap.set('n', '<Leader>lk', vim.diagnostic.goto_prev, keymap_opts)
vim.keymap.set('n', '<Leader>lj', vim.diagnostic.goto_next, keymap_opts)
vim.keymap.set('n', '<Leader>xt', vim.diagnostic.setloclist, keymap_opts)

-- diagnostic
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = true,
  severity_sort = true,
  float = { border = 'rounded' },
})
local signs = { Error = 'E ', Warn = 'W ', Hint = 'H ', Info = 'I ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.api.nvim_create_augroup('diagnostics', { clear = true })
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = 'diagnostics',
  callback = function()
    vim.diagnostic.setloclist({ open = false })
  end,
})

local on_attach = function(client, bufnr)
  lsp_signature.on_attach()

  vim.lsp.handlers['textDocument/hover'] =  vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})
  vim.lsp.handlers['textDocument/signatureHelp'] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})

  -- if client.server_capabilities.documentHighlightProvider then
  --     -- Highlight text at cursor position
  --     local lsp_doc_highlight_aug = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
  --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  --       callback = vim.lsp.buf.document_highlight,
  --       desc = 'Highlight references to current symbol under cursor',
  --       group = lsp_doc_highlight_aug,
  --       buffer = bufnr,
  --     })
  --     vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
  --       callback = vim.lsp.buf.clear_references,
  --       desc = 'Clear highlights when cursor is moved',
  --       group = lsp_doc_highlight_aug,
  --       buffer = bufnr,
  --     })
  -- end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local keymap_bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.declaration, keymap_bufopts)
  vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, keymap_bufopts)
  vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, keymap_bufopts)
  vim.keymap.set('n', '<Leader>li', vim.lsp.buf.implementation, keymap_bufopts)
  vim.keymap.set('n', '<Leader>lt', vim.lsp.buf.type_definition, keymap_bufopts)
  vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, keymap_bufopts)
  vim.keymap.set('n', '<Leader>lR', vim.lsp.buf.references, keymap_bufopts)
end

-- clients
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_flags = {
  debounce_text_changes = 130,
}

lspconfig['pylsp'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  single_file_support = false,
  root_dir = lspconfig.util.root_pattern('.git', '.ignore', '.gitignore', 'requirements.txt'),
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
          args = {'--max-line-length', '200'}
        },
      }
    }
  }
}

lspconfig['clangd'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

local extras_path = lspconfig.util.path.join(vim.api.nvim_eval('stdpath("config")'), 'extras')

local groovy_lsp_jar_path = lspconfig.util.path.join(extras_path, 'groovy-language-server-all.jar')
local groovy_lib = ''
if vim.env.GROOVY_HOME then
  groovy_lib = vim.env.GROOVY_HOME .. '/lib'
end
lspconfig['groovyls'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
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
lspconfig['efm'].setup {
  init_options = {documentFormatting = true},
  cmd = {efm_command, '-c', efm_config},
  rootMarkers = {'.git', '.ignore'},
  filetypes = {'groovy', 'Jenkinsfile'},
  single_file_support = true,
  settings = {
  },
  flags = {
    debounce_text_changes = 400,
  },
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

-- Plugin nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    'python',
    'cpp',
    'yaml',
    'json',
    'cmake',
  },
}
