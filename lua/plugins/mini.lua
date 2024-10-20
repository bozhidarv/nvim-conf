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

local custom_filename = function()
  -- local buf = vim.api.nvim_get_current_buf()
  --
  -- local buf_name = vim.api.nvim_buf_get_name(buf)
  -- if vim.fn.empty(buf_name) == 1 then
  --   return vim.fn.expand '%'
  -- end
  --
  -- local split = vim.fn.split(buf_name, '/')
  -- if vim.fn.has 'win32' == 1 then
  --   split = vim.fn.split(buf_name, '\\')
  -- end
  -- local res = split[vim.fn.len(split)]

  -- local buf_modified = vim.api.nvim_get_option_value('modified', { buf = buf })
  -- if buf_modified then
  --   res = res .. ' [+]'
  -- end

  -- return res .. ' %m'
  return '%t %m'
end

local custom_location = function()
  return [[%2l:%-2v|%p%%]]
end

local custom_diagnostics = function(_)
  local severities = vim.diagnostic.severity

  local diagnostics = ''

  local currCount
  for level = 1, 4 do
    currCount = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    if currCount > 0 then
      diagnostics = diagnostics .. MiniIcons.get('lsp', string.lower(severities[level])) .. currCount .. ' '
    end
  end

  if diagnostics == '' then
    return ''
  end
  return '| ' .. diagnostics .. '|'
end

local custom_arrow = function()
  local arrowStatusline = require 'arrow.statusline'
  if arrowStatusline.is_on_arrow_file() then
    return '%#ArrowStatusLine#' .. arrowStatusline.text_for_statusline_with_icons()
  end
  return ''
end

local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup {}

---@diagnostic disable-next-line: duplicate-set-field
MiniStatusline.active = function()
  local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
  local git = MiniStatusline.section_git { trunc_width = 40 }
  local diff = MiniStatusline.section_diff { trunc_width = 75 }
  -- local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
  local diagnostics = custom_diagnostics()
  -- local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
  local arrow = custom_arrow()
  -- local filename = MiniStatusline.section_filename { trunc_width = 140 }
  local filename = custom_filename()
  local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
  -- local location = MiniStatusline.section_location { trunc_width = 75 }
  -- local search = MiniStatusline.section_searchcount { trunc_width = 75 }
  local location = custom_location()

  return MiniStatusline.combine_groups {
    { hl = mode_hl,                 strings = { mode } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, arrow } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = mode_hl,                  strings = { location } },
  }
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

require('mini.comment').setup {}
