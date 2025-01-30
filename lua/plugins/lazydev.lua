MiniDeps.add {
  source = 'folke/lazydev.nvim',
  depends = {
    'Bilal2453/luvit-meta',
    'justinsgithub/wezterm-types',
  },
}

require('lazydev').setup {
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found

    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    { path = 'wezterm-types',      mods = { 'wezterm' } },
  },
}
