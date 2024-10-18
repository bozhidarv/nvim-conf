local M = {}

M.firstToUpper = function(str)
  return (str:gsub('^%l', string.upper))
end

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

M.picker = 'telescope'

return M
