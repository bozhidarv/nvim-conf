local add = MiniDeps.add

add {
  source = 'ThePrimeagen/harpoon',
  checkout = 'harpoon2',
}

require('harpoon').setup {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
}
