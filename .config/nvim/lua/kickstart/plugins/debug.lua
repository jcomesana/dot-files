-- debug.lua

return {
  "mfussenegger/nvim-dap",
  cond = not vim.g.vscode,
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Installs the debug adapters for you
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    -- Debuggers
    "mfussenegger/nvim-dap-python",
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F1>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F3>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>zb",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>zB",
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      desc = "Debug: Set Breakpoint",
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: See last session result.",
    },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    require("mason-nvim-dap").setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        "codelldb", -- C/C++ and Rust
        "local-lua-debugger-vscode",
        "python",
      },
    }

    dap.adapters.codelldb = {
      type = "executable",
      command = "codelldb",

      -- On windows you may have to uncomment this:
      -- detached = false,
    }

    dap.configurations.lua = {
      {
        name = "Current file (local-lua-dbg, lua)",
        type = "local-lua",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = {
          lua = "lua",
          file = vim.api.nvim_buf_get_name(0),
        },
        args = {},
      },
    }

    dap.adapters["local-lua"] = {
      type = "executable",
      command = "node",
      args = {
        vim.fs.joinpath(vim.fn.stdpath("data"), "mason/share/local-lua-debugger-vscode/extension/debugAdapter.js"),
      },
      enrich_config = function(config, on_config)
        if not config["extensionPath"] then
          local c = vim.deepcopy(config)
          -- 💀 If this is missing or wrong you'll see
          -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
          c.extensionPath = vim.fs.joinpath(vim.fn.stdpath("data"), "mason/share/local-lua-debugger-vscode/"),
          on_config(c)
        else
          on_config(config)
        end
      end,
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "",
        },
      },
    }

    -- Change breakpoint icons
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = "", BreakpointCondition = "", BreakpointRejected = "", LogPoint = "", Stopped = "" }
      or { Breakpoint = "●", BreakpointCondition = "⊜", BreakpointRejected = "⊘", LogPoint = "◆", Stopped = "⭔" }
    for type, icon in pairs(breakpoint_icons) do
      local tp = "Dap" .. type
      vim.fn.sign_define(tp, { text = icon })
    end

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    require("dap-python").setup("uv")
  end,
}
