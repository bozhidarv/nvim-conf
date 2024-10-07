return {
  'folke/trouble.nvim',
  dependencies = {
    { 'folke/todo-comments.nvim', opts = {} },
  },
  opts = {},
  config = function()
    require('trouble').setup()
  end,
}
