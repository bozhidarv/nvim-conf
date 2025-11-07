---@type string|nil
local branch_name = ''

local M = {}

M.register_autocmd = function()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'FocusGained' }, {
    desc = 'git branch',
    callback = function()
      local branch = vim.fn.system 'git branch --show-current'

      local val = branch:find 'fatal'
      if val ~= nil then
        branch_name = nil
      else
        branch_name = branch:gsub('\n', '')
      end
    end,
    group = vim.api.nvim_create_augroup('git_branch_name', { clear = false }),
  })
end

---@return string|nil
M.get_branch_name = function()
  return branch_name
end

return M
