---@diagnostic disable: missing-fields
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
    'lawrence-laz/neotest-zig',
  },
}

add {
  source = 'rcasia/neotest-java',
  depends = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap", -- for the debugger
      "rcarriga/nvim-dap-ui", -- recommended
      "theHamsta/nvim-dap-virtual-text", -- recommended
    }
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
    require 'neotest-vim-test' { ignore_filetypes = { 'rust', 'cs', 'zig' } },
    require 'neotest-zig' {
      dap = {
        adapter = 'codelldb',
      },
    },
    require 'neotest-java' {
      junit_jar = nil,
      incremental_build = true,
    },
  },
}
