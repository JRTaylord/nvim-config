-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.diagnostics").setup()
vim.lsp.log.set_level("trace")
vim.lsp.enable("jdtls")
