MiniDeps.add {
  source = 'ThePrimeagen/harpoon',
  checkout = 'harpoon2',
  depends = {
    'nvim-lua/plenary.nvim',
  },
}

local harpoon = require 'harpoon'

-- REQUIRED
harpoon:setup {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
}
local harpoon_extensions = require 'harpoon.extensions'
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
