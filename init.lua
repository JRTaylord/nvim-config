-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.diagnostics").setup()
vim.lsp.log.set_level("trace")
vim.lsp.enable("jdtls")

require("mason-lspconfig").setup({
  automatic_installation = { exclude = { "vtsls" } },
  ensure_installed = { "ts_ls" }, -- Use ts_ls, not tsserver!
})
