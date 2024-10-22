local add = MiniDeps.add

add {
  source = 'folke/trouble.nvim',
  depends = {
    'folke/todo-comments.nvim',
  },
}

require('trouble').setup()
require('todo-comments').setup()
