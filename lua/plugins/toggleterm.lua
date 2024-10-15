MiniDeps.add {
  source = 'akinsho/toggleterm.nvim',
}

require('toggleterm').setup {
  open_mapping = { '<C-\\>', '<C-t>' },
  start_in_insert = true,
  direction = 'float',
}
