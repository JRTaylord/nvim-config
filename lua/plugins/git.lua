return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- Enable inline blame
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 500, -- Delay in ms before showing blame
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    },
  },
}
