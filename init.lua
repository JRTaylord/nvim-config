-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.diagnostics").setup()

require("mason-lspconfig").setup({
  automatic_installation = { exclude = { "vtsls" } },
  ensure_installed = { "ts_ls" }, -- Use ts_ls, not tsserver!
})
