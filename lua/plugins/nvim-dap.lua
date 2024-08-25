return {
  'mfussenegger/nvim-dap',
  event = 'LspAttach',
  lazy = true,
  dependencies = {
    -- Creates a beautiful debugger UI
    { 'rcarriga/nvim-dap-ui', opts = {} },

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

    require('nvim-dap-virtual-text').setup()

    --#region Dap icons definition
    vim.fn.sign_define('DapBreakpoint', { text = '󰻃 ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '󰘥 ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = ' ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = ' ', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
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
      require('dapui').eval(nil, { enter = true })
    end, { desc = 'Debug: Eval under cursor' })
    --#endregion

    --#region Dap/DapUI setup
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    --#endregion

    --#region DapUI adapters
    dap.adapters.coreclr = {
      type = 'executable',
      command = os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/netcoredbg/libexec/netcoredbg/netcoredbg',
      args = { '--interpreter=vscode' },
    }
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
    --#endregion
  end,
}
