MiniDeps.add {
  source = 'folke/lazydev.nvim',
  depends = {
    'justinsgithub/wezterm-types',
  },
}

require('lazydev').setup {
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'wezterm-types', mods = { 'wezterm' } },
  },
}
