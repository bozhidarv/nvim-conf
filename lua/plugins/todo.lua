local add = MiniDeps.add

add {
  source = 'folke/todo-comments.nvim',
}

require('todo-comments').setup()
