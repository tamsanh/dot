return {
  "akinsho/toggleterm.nvim",
  tag = "*",
  config = true,
  keys = {
    { "<C-_>", "<cmd>ToggleTerm size=23 direction=horizontal<cr>" },
  },
  opts = { winbar = { enabled = false } },
}
