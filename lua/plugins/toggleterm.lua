return {
  -- amongst your other plugins
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        open_mapping = '<C-\\>',
        start_in_insert = true,
        direction = 'float',
      }
    end,
  },
}
