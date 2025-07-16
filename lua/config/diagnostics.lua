-- ~/.config/nvim/lua/config/diagnostics.lua
local M = {}

M.setup = function()
  vim.o.updatetime = 250
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  })
end

return M
