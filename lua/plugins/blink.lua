return {
  {
    "saghen/blink.cmp",
    opts = {
      -- Disable blink's ghost text to let minuet handle it
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      -- Remove minuet from sources if it gets added automatically
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
