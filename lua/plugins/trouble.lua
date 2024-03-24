return {
  'folke/trouble.nvim',
  event = 'BufAdd',
  lazy = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    { 'folke/todo-comments.nvim', opts = {} },
  },
  opts = {},
  config = function() end,
}
