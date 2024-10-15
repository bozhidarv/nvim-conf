local add = MiniDeps.add

add {
  source = 'sindrets/diffview.nvim',
}

add {
  source = 'NeogitOrg/neogit',
  depends = {
    'nvim-lua/plenary.nvim',  -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
}

require('neogit').setup {}

add {
  source = 'lewis6991/gitsigns.nvim',
}

require('gitsigns').setup {
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
    vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
    vim.keymap.set('n', ']g', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Go to next git hunk' })
    vim.keymap.set('n', '[g', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Go to previous git hunk' })
  end,
}
