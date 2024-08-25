return {
  { 'sindrets/diffview.nvim' },
  {
    'NeogitOrg/neogit',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      'ibhagwan/fzf-lua',
    },
    config = true,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signcolumn = true,
      signs = {
        add = { text = '┃' },
        change = { text = '┋' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '┃' },
      },
      attach_to_untracked = true,
      current_line_blame = true,
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>ghp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>ghn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ghh', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
}
