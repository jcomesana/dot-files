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
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local lspconfig = require'lspconfig'
lspconfig.pylsp.setup{}
lspconfig.clangd.setup{}
lspconfig.groovyls.setup{
  cmd = { "java", "-jar", vim.api.nvim_eval('stdpath("config")') .. "/extras/groovy-language-server-all.jar" },
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
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)
