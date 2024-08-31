return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    -- calling `setup` is optional for customization

    require('fzf-lua').setup {
      defaults = {
        file_icons = 'mini',
      },
    }
    require('fzf-lua').register_ui_select {
      winopts = {
        relative = 'editor',
        row = 0.48,
        col = 0.48,
        height = 0.2,
        width = 0.2,
        win_border = true,
      },
    }
  end,
}
