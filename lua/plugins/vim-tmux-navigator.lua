return {
  {
    'christoomey/vim-tmux-navigator',
    cond = vim.fn.has 'win32' == 0,
  },
  {
    'mrjones2014/smart-splits.nvim',
    cond = vim.fn.has 'win32' == 1,
  },
}
