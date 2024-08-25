return {
  'folke/which-key.nvim',
  config = function()
    local wk = require 'which-key'
    wk.add {
      { '<leader>f',  group = 'Find' },
      { '<leader>c',  group = 'Code' },
      { '<leader>cw', group = 'Workspace' },
      { '<leader>ct', group = 'Toggle' },
      { '<leader>q',  group = 'Diagnostics' },
      { '<leader>d',  group = 'Debug' },
      { '<leader>ds', group = 'Step' },
      { '<leader>g',  group = 'Git' },
      { '<leader>gh', group = 'Hunk' },
      { '<leader>h',  group = 'Harpoon' },
      { '<leader>s',  group = 'Split' },
      { '<leader>t',  group = 'Tab' },
    }
  end,
}
