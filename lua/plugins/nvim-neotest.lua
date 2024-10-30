local add = MiniDeps.add

add {
  source = 'nvim-neotest/neotest',
  depends = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'Issafalcon/neotest-dotnet',
    'vim-test/vim-test',
    'nvim-neotest/neotest-vim-test',
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
    require 'neotest-dotnet' {
      dap = { adapter_name = 'coreclr' },
    },
    require 'neotest-vim-test' { ignore_filetypes = { 'rust', 'cs' } },
  },
}
