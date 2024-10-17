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

local signs = require('options.utils').lspSigns
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup {
  use_icons = true,
}

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_lsp = function()
  return ''
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_filename = function()
  local buf = vim.api.nvim_get_current_buf()
  local res = (vim.fn.expand '%')
  local buf_modified = vim.api.nvim_buf_get_option(buf, 'modified')
  if buf_modified then
    res = res .. ' [+]'
  end
  return res
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_diagnostics = function(_)
  local count = {}

  local severities = vim.diagnostic.severity

  for level in pairs(vim.diagnostic.severity) do
    count[level] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  if count[severities.ERROR] == 0 and count[severities.WARN] == 0 and count[severities.HINT] == 0 and count[severities.INFO] == 0 then
    return ''
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''

  if count[severities.ERROR] ~= 0 then
    errors = signs.Error .. ' ' .. count[severities.E] .. ' '
  end
  if count[severities.WARN] ~= 0 then
    warnings = signs.Warn .. ' ' .. count[severities.WARN] .. ' '
  end
  if count[severities.HINT] ~= 0 then
    hints = signs.Hint .. ' ' .. count[severities.HINT] .. ' '
  end
  if count[severities.HINT] ~= 0 then
    info = signs.Info .. ' ' .. count[severities.HINT] .. ' '
  end

  return '|' .. errors .. warnings .. hints .. info .. '|'
end

require('mini.diff').setup {
  -- Options for how hunks are visualized
  view = {
    -- Visualization style. Possible values are 'sign' and 'number'.
    -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
    style = 'sign',

    -- Signs used for hunks with 'sign' view
    signs = { add = '┃', change = '┋', delete = '' },

    -- Priority of used visualization extmarks
    priority = 199,
  },

  -- Source for how reference text is computed/updated/etc
  -- Uses content from Git index by default
  source = nil,

  -- Delays (in ms) defining asynchronous processes
  delay = {
    -- How much to wait before update following every text change
    text_change = 200,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Apply hunks inside a visual/operator region
    apply = 'gh',

    -- Reset hunks inside a visual/operator region
    reset = 'gH',

    -- Hunk range textobject to be used inside operator
    -- Works also in Visual mode if mapping differs from apply and reset
    textobject = 'gh',

    -- Go to hunk range in corresponding direction
    goto_prev = '[g',
    goto_next = ']g',
  },

  -- Various options
  options = {
    -- Diff algorithm. See `:h vim.diff()`.
    algorithm = 'histogram',

    -- Whether to use "indent heuristic". See `:h vim.diff()`.
    indent_heuristic = true,

    -- The amount of second-stage diff to align lines (in Neovim>=0.9)
    linematch = 60,

    -- Whether to wrap around edges during hunk navigation
    wrap_goto = false,
  },
}

require('mini.git').setup {}
