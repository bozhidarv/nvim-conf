return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  otps = {},
  config = function()
    ---@type HarpoonPartialConfig
    require('harpoon').setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    }
  end,
}
