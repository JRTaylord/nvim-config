local disable_lua_diagnostics = true
-- print("disable_lua_diagnostics:", disable_lua_diagnostics)

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = false, -- ADD THIS - disables vtsls
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                workspaceDelay = disable_lua_diagnostics and -1 or 1000,
              },
            },
          },
        },
      },
    },
  },
}
