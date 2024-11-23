MiniDeps.add {
  source = 'tpope/vim-fugitive',
}

MiniDeps.add {
  source = 'braxtons12/blame_line.nvim',
}

require('blame_line').setup {
  show_in_visual = false,
  show_in_insert = false,
  prefix = '',
}

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
