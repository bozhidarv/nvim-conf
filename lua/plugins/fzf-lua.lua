return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    -- calling `setup` is optional for customization

    local actions = require 'fzf-lua.actions'

    require('fzf-lua').setup {
      defaults = {
        file_icons = 'mini',
      },
    }
  end,
}
