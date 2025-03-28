MiniDeps.add {
  source = 'akinsho/toggleterm.nvim',
}

require('toggleterm').setup {
  open_mapping = { '<C-\\>' },
  start_in_insert = true,
  direction = 'float',
}
