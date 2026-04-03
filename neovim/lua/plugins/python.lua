-- Python DAP + LSP configuration.
-- Configures pyright/basedpyright to use the local .venv when present.
local function venv_python(root_dir)
  local venv_env = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv_env then return venv_env .. "/bin/python" end
  local local_venv = (root_dir or vim.fn.getcwd()) .. "/.venv/bin/python"
  if vim.fn.executable(local_venv) == 1 then return local_venv end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          on_new_config = function(config, root_dir)
            local python = venv_python(root_dir)
            if python then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = python
            end
          end,
        },
        basedpyright = {
          on_new_config = function(config, root_dir)
            local python = venv_python(root_dir)
            if python then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = python
            end
          end,
        },
      },
    },
  },
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
