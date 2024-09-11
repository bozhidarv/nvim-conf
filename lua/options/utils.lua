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

M.colorscheme = 'onedark'

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

return M
