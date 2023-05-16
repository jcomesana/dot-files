-- impatient.nvim replacement
if vim.fn.has('nvim-0.9') then
  vim.loader.enable()
end

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
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'omni' },
    { name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
  },
  cmp.setup.filetype('Jenkinsfile', {
    sources = {
      {
        name = 'jenkinsfile',
        option = { jenkins_url = vim.env.JENKINS_URL, },
      },
    },
  }),
})

-- Plugin nvim-lspconfig and LSP settings

-- Plugin lsp_signature.nvim
local lsp_signature = require('lsp_signature')
lsp_signature.setup({
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

local keymap_opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>ll', vim.diagnostic.open_float, keymap_opts)
vim.keymap.set('n', '<Leader>lk', vim.diagnostic.goto_prev, keymap_opts)
vim.keymap.set('n', '<Leader>lj', vim.diagnostic.goto_next, keymap_opts)

-- diagnostic
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
local signs = { Error = 'E ', Warn = 'W ', Hint = 'H ', Info = 'I ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers['textDocument/hover'] =  vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})
vim.lsp.handlers['textDocument/signatureHelp'] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})

local on_attach = function(client, bufnr)

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

  lsp_signature.on_attach()
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local default_lsp_flags = {
  debounce_text_changes = 180,
  allow_incremental_sync = true,
}

lspconfig['pylsp'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = default_lsp_flags,
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
  flags = default_lsp_flags,
}

local extras_path = lspconfig.util.path.join(vim.api.nvim_eval('stdpath("config")'), 'extras')

local groovy_lsp_jar_path = lspconfig.util.path.join(extras_path, 'groovy-language-server-all.jar')
local groovy_lsp_classpath = {}
if vim.env.GROOVY_HOME then
  local groovy_lib = vim.env.GROOVY_HOME .. '/lib'
  table.insert(groovy_lsp_classpath, groovy_lib)
end
lspconfig['groovyls'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = default_lsp_flags,
  cmd = { 'java', '-jar', groovy_lsp_jar_path },
  filetypes = { 'groovy', 'Jenkinsfile' },
  root_dir = lspconfig.util.root_pattern('.groovylintrc.json', '.git', '.ignore', '.hg'),
  single_file_support = false,
  settings = {
    groovy = {
      classpath = groovy_lsp_classpath,
    }
  }
}

local efm_folder = lspconfig.util.path.join(extras_path, 'efm-langserver')
local efm_command = lspconfig.util.path.join(efm_folder, 'efm-langserver')
vim.env.EFMLANGSERVER = efm_folder
local efm_config = lspconfig.util.path.join(extras_path, 'efm-langserver', 'config.yaml')
lspconfig['efm'].setup {
  init_options = {documentFormatting = true},
  cmd = {efm_command, '-c', efm_config},
  root_dir = lspconfig.util.root_pattern('.groovylintrc.json', '.git', '.ignore', '.hg'),
  filetypes = {'groovy', 'Jenkinsfile'},
  single_file_support = false,
  settings = {
  },
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 1500,
    allow_incremental_sync = false,
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
local default_map_opts = {noremap=true, silent=true}
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
vim.keymap.set('n', '<leader>tz', telescope_builtin.current_buffer_fuzzy_find, default_map_opts)
-- telescope-fzf-native.nvim extension
require('telescope').load_extension('fzf')

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
    'vim',
  },
}

-- Plugin trouble.nvim
require('trouble').setup {
  icons = false,
  fold_open = '-', -- icon used for open folds
  fold_closed = '+', -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
  auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
}
vim.keymap.set('n', '<Leader>xt', '<cmd>TroubleToggle<cr>', default_map_opts)
vim.keymap.set('n', '<Leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', default_map_opts)
vim.keymap.set('n', '<Leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', default_map_opts)
vim.keymap.set('n', '<Leader>xl', '<cmd>TroubleToggle loclist<cr>', default_map_opts)
vim.keymap.set('n', '<Leader>xq', '<cmd>TroubleToggle quickfix<cr>', default_map_opts)
vim.keymap.set('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>', default_map_opts)

if vim.env.JENKINS_URL then
  -- Plugin nvim-jenkinsfile-linter
  local jenkinsfile_linter = require('jenkinsfile_linter')
  vim.keymap.set('n', '<Leader>jv', jenkinsfile_linter.validate, default_map_opts)

  -- Run with autocommand too
  vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter', 'BufWritePost'}, {
    pattern = {'*.Jenkinsfile'},
    callback = jenkinsfile_linter.validate,
  })
end

-- Plugin fidget.nvim
require'fidget'.setup{}

-- Plugin toggleterm.nvim
require('toggleterm').setup({
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
})

-- Plugin which-key
require("which-key").setup()
