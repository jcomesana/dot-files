-- Plugin nvim-autopairs
require('nvim-autopairs').setup{}


-- Plugin nvim-cmp
local cmp = require'cmp'
cmp.setup({
  snippet = {
	expand = function(args)
	  vim.fn["vsnip#anonymous"](args.body)
	end,
  },
  mapping = {
	['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
	{ name = "buffer" },
  }
})


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
lspconfig.pylsp.setup{ on_attach = on_attach, }
lspconfig.clangd.setup{ on_attach = on_attach, }

local groovy_lsp_jar_path = vim.api.nvim_eval('stdpath("config")') .. "/extras/groovy-language-server-all.jar"
lspconfig.groovyls.setup{
  on_attach = on_attach,
  cmd = { "java", "-jar", groovy_lsp_jar_path },
  filetypes = { "groovy", "Jenkinsfile" },
  root_dir = function()
      return vim.fn.getcwd()
  end
}

-- Plugin nvim-ale-diagnostic
require("nvim-ale-diagnostic")
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = { spacing = 4 },
    signs = true,
    update_in_insert = false,
  }
)

-- Plugin lsp_signature.nvim
require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "single"
  }
})

-- Plugin symbols-outline.nvim
vim.cmd [[nnoremap <silent> <F12> :SymbolsOutline<CR>]]
vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = 'right',
    width = 35,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = { 'Variable', 'Module', 'Field' },
    symbols = {
        File = {icon = "+file  ", hl = "TSURI"},
        Module = {icon = "+module", hl = "TSNamespace"},
        Namespace = {icon = "+namesp", hl = "TSNamespace"},
        Package = {icon = "+package", hl = "TSNamespace"},
        Class = {icon = "+Class ", hl = "TSType"},
        Method = {icon = "-method", hl = "TSMethod"},
        Property = {icon = "-propert", hl = "TSMethod"},
        Field = {icon = "-field ", hl = "TSField"},
        Constructor = {icon = "-constr", hl = "TSConstructor"},
        Enum = {icon = "+Enum  ", hl = "TSType"},
        Interface = {icon = "+inface", hl = "TSType"},
        Function = {icon = "+functi", hl = "TSFunction"},
        Variable = {icon = "-variab", hl = "TSConstant"},
        Constant = {icon = "#const ", hl = "TSConstant"},
        String = {icon = "#string", hl = "TSString"},
        Number = {icon = "#number", hl = "TSNumber"},
        Boolean = {icon = "#bool  ", hl = "TSBoolean"},
        Array = {icon = "#array ", hl = "TSConstant"},
        Object = {icon = "#object", hl = "TSType"},
        Key = {icon = "#key   ", hl = "TSType"},
        Null = {icon = "#NULL  ", hl = "TSType"},
        EnumMember = {icon = "-enum  ", hl = "TSField"},
        Struct = {icon = "+struct", hl = "TSType"},
        Event = {icon = "-event ", hl = "TSType"},
        Operator = {icon = "-operat", hl = "TSOperator"},
        TypeParameter = {icon = "+type  ", hl = "TSParameter"}
    }
}

-- Plugin nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
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
