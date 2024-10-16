local add = MiniDeps.add

add {
  source = 'sindrets/diffview.nvim',
}

add {
  source = 'NeogitOrg/neogit',
  depends = {
    'nvim-lua/plenary.nvim',  -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
}

require('neogit').setup {}

add {
  source = 'tpope/vim-fugitive'
}
