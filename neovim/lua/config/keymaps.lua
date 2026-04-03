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

-- Standard vim paste behavior (explicit, so plugins can't silently override)
map({ "n", "v" }, "p", "p", { noremap = true, desc = "Paste after cursor" })
map({ "n", "v" }, "P", "P", { noremap = true, desc = "Paste before cursor" })

-- Go to Definition; if already at the definition, find references instead (CTRL+B)
map("n", "<C-b>", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
    if not result or vim.tbl_isempty(result) then
      vim.lsp.buf.definition()
      return
    end
    local current_uri = vim.uri_from_bufnr(0)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local locs = vim.tbl_islist(result) and result or { result }
    local at_def = false
    for _, loc in ipairs(locs) do
      local uri = loc.uri or loc.targetUri
      local range = loc.range or loc.targetSelectionRange
      if uri == current_uri and range then
        local def_line = range.start.line + 1  -- convert to 1-indexed
        if cursor[1] == def_line then
          at_def = true
          break
        end
      end
    end
    if at_def then
      vim.lsp.buf.references()
    else
      vim.lsp.buf.definition()
    end
  end)
end, { desc = "Go to Definition / Find References" })

-- Toggle Neo-tree (CTRL+E)
map("n", "<C-e>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })

-- Find files (CTRL+P)
map("n", "<C-p>", function() LazyVim.pick("files")() end, { desc = "Find Files (Root Dir)" })

-- Delete without clobbering the yank register
map({ "n", "v" }, "d",  '"_d',  { desc = "Delete to black hole" })
map({ "n", "v" }, "D",  '"_D',  { desc = "Delete to end of line (black hole)" })
map("n",          "dd", '"_dd', { desc = "Delete line (black hole)" })
map({ "n", "v" }, "x",  '"_x',  { desc = "Delete char (black hole)" })

-- Overseer (task runner) keymaps
map("n", "<leader>oo", "<cmd>OverseerRun<cr>",    { desc = "Overseer: Run Task" })
map("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Overseer: Toggle Panel" })
map("n", "<leader>ol", "<cmd>OverseerLoadBundle<cr>", { desc = "Overseer: Load Bundle" })
