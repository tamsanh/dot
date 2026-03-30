local map = vim.keymap.set

-- DAP (Debug Adapter Protocol) keymaps
map("n", "<C-2>",      function() require("dap").continue() end,          { desc = "Debug: Continue" })
map("n", "<C-3>",      function() require("dap").step_over() end,         { desc = "Debug: Step Over" })
map("n", "<C-4>",      function() require("dap").step_into() end,         { desc = "Debug: Step Into" })
map("n", "<C-5>",      function() require("dap").step_out() end,          { desc = "Debug: Step Out" })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })
map("n", "<leader>dr", function() require("dap").repl.open() end,         { desc = "Debug: Open REPL" })
map("n", "<leader>dl", function() require("dap").run_last() end,          { desc = "Debug: Run Last" })
map("n", "<leader>dq", function()
  require("dap").terminate()
  require("dapui").close()
end, { desc = "Debug: Quit" })

-- Delete without clobbering the yank register
map({ "n", "v" }, "d",  '"_d',  { desc = "Delete to black hole" })
map({ "n", "v" }, "D",  '"_D',  { desc = "Delete to end of line (black hole)" })
map("n",          "dd", '"_dd', { desc = "Delete line (black hole)" })
map({ "n", "v" }, "x",  '"_x',  { desc = "Delete char (black hole)" })

-- Overseer (task runner) keymaps
map("n", "<leader>oo", "<cmd>OverseerRun<cr>",    { desc = "Overseer: Run Task" })
map("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Overseer: Toggle Panel" })
map("n", "<leader>ol", "<cmd>OverseerLoadBundle<cr>", { desc = "Overseer: Load Bundle" })
