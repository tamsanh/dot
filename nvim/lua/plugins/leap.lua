-- Override leap to remove the 's' key
-- We need to keep leap so that 'flit' can still work
return {
  "ggandor/leap.nvim",
  config = function(_, _)
    vim.keymap.del({ "n", "x", "o" }, "s")
    vim.keymap.del({ "n", "x", "o" }, "S")
  end,
}
