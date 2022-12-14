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
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
  debounce_text_changes = 500,
  allow_incremental_sync = true,
}

lspconfig['pylsp'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  single_file_support = false,
  root_dir = lspconfig.util.root_pattern('.git', '.hg', '.ignore', 'requirements.txt'),
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
          args = {'--max-line-length 200'}
        },
      }
    }
  }
}

lspconfig['clangd'].setup{
  on_attach = on_attach,
  cmd = {
    'clangd', '--background-index', '--suggest-missing-includes', '--clang-tidy',
    '--header-insertion=iwyu'
  },
  filetypes = {'c', 'cpp', 'objc', 'objcpp'},
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
  root_dir = lspconfig.util.root_pattern('.groovylintrc.json', '.git', '.ignore', '.hg'),
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
  rootMarkers = {'.groovylintrc.json', '.git', '.ignore', '.hg'},
  filetypes = {'groovy', 'Jenkinsfile'},
  single_file_support = true,
  settings = {
  },
  flags = {
    debounce_text_changes = 400,
  },
}

-- Plugin telescope
local telescope = require('telescope')
telescope.load_extension('ag')
telescope.setup {
  defaults = {
    preview = {
      check_mime_type = false
    },
    layout_strategy = 'horizontal',
    layout_config = {
      height = 0.95,
      width = 0.90,
      prompt_position = 'top',
    },
  }
}

local telescope_builtin = require('telescope.builtin')
local default_map_opts = {noremap = true}
vim.keymap.set('n', '<leader>tf', telescope_builtin.find_files, default_map_opts)
vim.keymap.set('n', '<leader>tg', telescope_builtin.live_grep, default_map_opts)
vim.keymap.set('n', '<leader>tb', telescope_builtin.buffers, default_map_opts)
vim.keymap.set('n', '<leader>th', telescope_builtin.help_tags, default_map_opts)
vim.keymap.set('n', '<leader>tl', telescope_builtin.live_grep, default_map_opts)
vim.keymap.set('n', '<leader>tc', telescope_builtin.git_commits, default_map_opts)
vim.keymap.set('n', '<leader>tR', telescope_builtin.lsp_references, default_map_opts)
vim.keymap.set('n', '<leader>ts', telescope_builtin.lsp_document_symbols, default_map_opts)
vim.keymap.set('n', '<leader>tW', telescope_builtin.lsp_workspace_symbols, default_map_opts)
vim.keymap.set('n', '<leader>td', telescope_builtin.diagnostics, default_map_opts)
vim.keymap.set('n', '<leader>tt', telescope_builtin.treesitter, default_map_opts)

-- Plugin nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = true,
  },
  yati = {
    enable = true,
    -- Disable by languages, see `Supported languages`
    disable = { },
    -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
    default_lazy = true,
    -- Determine the fallback method used when we cannot calculate indent by tree-sitter
    --   "auto": fallback to vim auto indent
    --   "asis": use current indent as-is
    --   "cindent": see `:h cindent()`
    -- Or a custom function return the final indent result.
    default_fallback = 'auto'
  },
  ensure_installed = {
    'python',
    'cpp',
    'yaml',
    'json',
    'cmake',
  },
}

-- Plugin FTern
local FTerm = require 'FTerm'
FTerm.setup({
  border = 'rounded',
  cmd = os.getenv('SHELL') or 'cmd',
  dimensions  = {
      height = 0.9,
      width = 0.95,
  },
})

vim.keymap.set('n', '<A-t>', FTerm.toggle)
vim.keymap.set('t', '<A-t>', FTerm.toggle)
