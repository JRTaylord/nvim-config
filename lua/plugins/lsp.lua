local hostname = vim.fn.hostname()
local is_low_memory = hostname == "JAMES-FRAMEWORK"
print("is_low_memory:", is_low_memory)

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                workspaceDelay = is_low_memory and -1 or 1000, -- Disable workspace diagnostics
              },
            },
          },
        },
      },
    },
  },
}
