local add = MiniDeps.add

add {
  source = 'ThePrimeagen/harpoon',
  checkout = 'harpoon2',
  depends = {
    'nvim-lua/plenary.nvim',  -- required
  }
}

require('harpoon').setup {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
}
