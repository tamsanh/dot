-- pnpm task runner (overseer) + Node.js/TypeScript debug configurations.
-- Requires vscode-js-debug which is installed by LazyVim's typescript extra.
return {
  -- ── Task runner ──────────────────────────────────────────────────────────
  {
    "stevearc/overseer.nvim",
    opts = {},
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Read scripts from package.json and offer them as tasks.
      overseer.register_template({
        name = "pnpm: run script",
        desc = "Run a pnpm script from package.json",
        tags = { overseer.TAG.BUILD },
        params = {
          script = {
            type = "enum",
            name = "Script",
            desc = "package.json script",
            choices = function()
              local f = io.open(vim.fn.getcwd() .. "/package.json", "r")
              if not f then return {} end
              local content = f:read("*a")
              f:close()
              local ok, pkg = pcall(vim.json.decode, content)
              if not ok or not pkg.scripts then return {} end
              local scripts = {}
              for k in pairs(pkg.scripts) do
                table.insert(scripts, k)
              end
              table.sort(scripts)
              return scripts
            end,
          },
        },
        builder = function(params)
          return {
            cmd = { "pnpm", "run", params.script },
            name = "pnpm run " .. params.script,
            components = { "default" },
          }
        end,
        condition = {
          callback = function()
            return vim.fn.filereadable(vim.fn.getcwd() .. "/package.json") == 1
          end,
        },
      })

      -- Convenience template: pnpm install
      overseer.register_template({
        name = "pnpm: install",
        desc = "Run pnpm install",
        builder = function()
          return { cmd = { "pnpm", "install" }, name = "pnpm install" }
        end,
        condition = {
          callback = function()
            return vim.fn.filereadable(vim.fn.getcwd() .. "/package.json") == 1
          end,
        },
      })
    end,
  },

  -- ── Node / TypeScript DAP configurations ─────────────────────────────────
  -- vscode-js-debug is installed by lazyvim.plugins.extras.lang.typescript.
  -- We just add pnpm-aware launch configurations here.
  {
    "mxsdev/nvim-dap-vscode-js",
    -- Already declared by the typescript extra; we extend its config.
    opts = function(_, opts)
      opts.adapters = opts.adapters
        or { "pwa-node", "pwa-chrome", "node-terminal" }
      return opts
    end,
    config = function(_, opts)
      require("dap-vscode-js").setup(vim.tbl_extend("force", {
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
      }, opts or {}))

      local dap = require("dap")

      local pnpm_configs = {
        -- Launch a pnpm script with the debugger attached
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug pnpm script",
          runtimeExecutable = "pnpm",
          runtimeArgs = function()
            local script = vim.fn.input("pnpm script: ")
            return { "run", "--", script }
          end,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          console = "integratedTerminal",
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        -- Attach to an already-running Node process (e.g. started with --inspect)
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Node process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        -- Launch the current TypeScript/JS file directly via ts-node / node
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
      }

      for _, lang in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
        dap.configurations[lang] = vim.list_extend(
          dap.configurations[lang] or {},
          pnpm_configs
        )
      end
    end,
  },
}
