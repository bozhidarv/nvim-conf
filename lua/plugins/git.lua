MiniDeps.add {
  source = 'NeogitOrg/neogit',
  depends = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    'ibhagwan/fzf-lua', -- optional
  },
}

require('neogit').setup {}

require('mini.git').setup()

require('mini.diff').setup {
  -- Options for how hunks are visualized
  view = {
    style = 'sign',
    signs = { add = '┃', change = '┋', delete = '' },
    priority = 199,
  },
  source = nil,
  delay = {
    text_change = 200,
  },
  mappings = {
    apply = 'gh',
    reset = 'gH',
    textobject = 'gh',
    goto_prev = '[g',
    goto_next = ']g',
  },
  options = {
    algorithm = 'histogram',
    indent_heuristic = true,
    linematch = 60,
    wrap_goto = false,
  },
}
