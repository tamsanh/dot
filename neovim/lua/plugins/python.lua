-- Python DAP configuration: auto-detects virtualenv / conda / system Python.
-- LazyVim's python extra already installs nvim-dap-python and debugpy; this
-- file just configures the adapter and adds useful launch configurations.
return {
  {
    "mfussenegger/nvim-dap-python",
    -- LazyVim's python extra declares this plugin; we extend it here.
    config = function()
      -- Resolve the Python interpreter: prefer the active virtualenv, then
      -- a local .venv, then fall back to whatever is on PATH.
      local function resolve_python()
        local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
        if venv then
          return venv .. "/bin/python"
        end
        local local_venv = vim.fn.getcwd() .. "/.venv/bin/python"
        if vim.fn.executable(local_venv) == 1 then
          return local_venv
        end
        return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3")
          or vim.fn.exepath("python")
          or "python"
      end

      require("dap-python").setup(resolve_python())

      -- Additional launch configurations (appended to the defaults provided
      -- by nvim-dap-python).
      local dap = require("dap")
      vim.list_extend(dap.configurations.python or {}, {
        {
          type = "python",
          request = "launch",
          name = "Run current file with arguments",
          program = "${file}",
          args = function()
            local args = vim.fn.input("Arguments: ")
            return vim.split(args, " ", { trimempty = true })
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Run module (python -m ...)",
          module = function()
            return vim.fn.input("Module name: ")
          end,
        },
      })
    end,
  },
}
