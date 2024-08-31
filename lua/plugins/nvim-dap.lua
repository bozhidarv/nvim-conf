return {
  'mfussenegger/nvim-dap',
  event = 'LspAttach',
  lazy = true,
  dependencies = {
    -- Creates a beautiful debugger UI
    { 'rcarriga/nvim-dap-ui',         opts = {} },

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    { 'jay-babu/mason-nvim-dap.nvim', opts = {} },
    'nvim-neotest/nvim-nio',
    -- Add your own debuggers here
    { 'leoluz/nvim-dap-go', opts = {} },

    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('nvim-dap-virtual-text').setup {}

    --#region Dap icons definition
    vim.fn.sign_define('DapBreakpoint',
      { text = '󰻃 ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition',
      { text = '󰘥 ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected',
      { text = ' ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint',
      { text = ' ', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
    --#endregion

    --#region Dap keybinds
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>dsi', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>dso', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>dsO', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    vim.keymap.set('n', '<leader>de', function()
      ---@diagnostic disable-next-line: missing-fields
      require('dapui').eval(nil, { enter = true })
    end, { desc = 'Debug: Eval under cursor' })
    --#endregion

    --#region Dap/DapUI setup
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    --#endregion

    --make a local var is os is windows
    local is_windows = vim.fn.has 'win32' == 1

    --#region Dap adapters
    dap.adapters.coreclr = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/netcoredbg/libexec/netcoredbg/netcoredbg',
      args = { '--interpreter=vscode' },
    }

    if not is_windows then
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
      }
    else
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '\\mason\\packages\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
        options = {
          detached = false,
        },
      }
    end
    --#endregion

    --#region Dap configs
    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
      },
    }
    dap.configurations.cpp = {
      {
        name = 'Launch file',
        type = 'cppdbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'enable pretty printing',
            ignoreFailures = false,
          },
        },
      },
      {
        name = 'Attach to gdbserver :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'enable pretty printing',
            ignoreFailures = false,
          },
        },
      },
    }
    dap.configurations.c = dap.configurations.cpp
  end,
}
