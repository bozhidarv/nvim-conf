local M = {}

M.lspSigns = {
  Error = ' ',
  Warn = ' ',
  Hint = ' ',
  Info = ' ',
}

M.checkTransperancy = function()
  local isTrans = os.getenv 'NVIM_TRANSPARENT_BACKGROUND'
  -- vim.print(isTrans)
  if isTrans == nil then
    return false
  end
  if isTrans == 'true' then
    return true
  end
  return false
end

M.colorscheme = 'tokyonight'

M.fzf_lua_save_buffer_action = function(selected, opts)
  local path = require 'fzf-lua.path'
  local utils = require 'fzf-lua.utils'
  for _, sel in ipairs(selected) do
    local entry = path.entry_to_file(sel, opts)
    if entry.bufnr and utils.buffer_is_dirty(entry.bufnr, true, false) then
      vim.api.nvim_buf_call(entry.bufnr, function()
        vim.cmd 'silent! w'
      end)
    end
  end
end

local sep_icons = {
  default = { left = '', right = '' },
  round = { left = '', right = '' },
  block = { left = '█', right = '█' },
  arrow = { left = '', right = '' },
}
local separators = sep_icons['default']

local sep_r = separators['right']

local file_txt = function()
  local icon = '󰈚'
  local sbufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
  local path = vim.api.nvim_buf_get_name(sbufnr)
  local name = (path == '' and 'Empty') or path:match '([^/\\]+)[/\\]*$'
  if name ~= 'Empty' then
    if vim.api.nvim_get_option_value('modified', { buf = sbufnr }) then
      name = name .. ' '
    end
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and ft_icon) or icon
    end
  end

  return { icon, name }
end

M.file = function()
  local x = file_txt()
  local name = ' ' .. x[2] .. ' '
  return '%#St_file# ' .. x[1] .. name .. '%#St_file_sep#' .. sep_r
end

return M
