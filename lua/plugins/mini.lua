local add = MiniDeps.add

require('mini.icons').setup {
  lsp = {
    ['error'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultError' },
    ['warning'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultWarning' },
    ['info'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultInformation' },
    ['hint'] = { glyph = '', hl = 'LspDiagnosticsDefaultHint' },
  },
}

MiniIcons.mock_nvim_web_devicons()

require('mini.cursorword').setup {
  -- Delay (in ms) between when cursor moved and when highlighting appeared
  delay = 100,
}

require('mini.indentscope').setup {
  draw = {
    delay = 0,
    animation = function()
      return 0
    end,
  },
  options = { border = 'top', try_as_border = true },
  symbol = '▏',
}

-- Disable for certain filetypes
vim.api.nvim_create_autocmd({ 'FileType' }, {
  desc = 'Disable indentscope for certain filetypes',
  callback = function()
    local ignored_filetypes = {
      'aerial',
      'dashboard',
      'help',
      'lazy',
      'leetcode.nvim',
      'mason',
      'neo-tree',
      'NvimTree',
      'neogitstatus',
      'notify',
      'startify',
      'toggleterm',
      'Trouble',
      'calltree',
      'coverage',
    }
    if vim.tbl_contains(ignored_filetypes, vim.bo.filetype) then
      vim.b.miniindentscope_disable = true
    end
  end,
})

require('mini.statusline').setup {
  -- Content of statusline as functions which return statusline string. See
  -- `:h statusline` and code of default contents (used instead of `nil`).
  content = {
    -- Content for active window
    active = nil,
    -- Content for inactive window(s)
    inactive = nil,
  },

  -- Whether to use icons by default
  use_icons = true,

  -- Whether to set Vim's settings for statusline (make it always shown)
  set_vim_settings = true,
}
