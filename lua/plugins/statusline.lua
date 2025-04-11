local custom_filename = function()
  return '%f%m%r'
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
  local harpoon = require 'harpoon'
  local element = harpoon.config.default:create_list_item()

  local length = harpoon:list():length()
  local items = harpoon:list().items


  if #items == 0 then
    return ''
  end

  local index = -1
  for i = 1, length do
    local item = items[i]
    if element.value == item.value then
      index = i
      break
    end
  end

  if index == -1 then
    return ''
  end

  return '%#HarpoonStatusLine# 󰣉 ' .. index
end

local custom_git = function()
  local first_split = vim.fn.split(vim.api.nvim_eval_statusline('%{FugitiveStatusline()}', {}).str, '[Git(')[1]
  local second_split = vim.fn.split(first_split, ')]')[1]

  if second_split == 'v:null' then
    return ''
  end
  return ' ' .. second_split
end
require('mini.statusline').setup()

---@diagnostic disable-next-line: duplicate-set-field
MiniStatusline.active = function()
  local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
  local git = custom_git()
  -- local git = MiniStatusline.section_git { trunc_width = 75 }
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
    { hl = mode_hl, strings = { mode } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, arrow } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = mode_hl, strings = { location } },
  }
end
