return {
  'folke/trouble.nvim',
  dependencies = {
    { 'folke/todo-comments.nvim', opts = {} },
  },
  opts = {},
  config = function()
    dofile(vim.g.base46_cache .. 'trouble')
    require('trouble').setup()
  end,
}
