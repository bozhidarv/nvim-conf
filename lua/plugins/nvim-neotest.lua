local add = MiniDeps.add

add {
  source = 'nvim-neotest/neotest',
  depends = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}

add {
  source = 'rouge8/neotest-rust',
}

require('neotest').setup {
  adapters = {
    require 'neotest-rust' {
      args = { '--no-capture' },
      dap_adapter = 'codelldb',
    },
  },
}
