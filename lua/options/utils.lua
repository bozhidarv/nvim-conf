local M = {}

M.firstToUpper = function(str)
  return (str:gsub('^%l', string.upper))
end

M.checkTransperancy = function()
  local isTrans = os.getenv 'TRANSPARENT_BACKGROUND'
  -- vim.print(isTrans)
  if isTrans == nil then
    return false
  end
  if isTrans == 'true' then
    return true
  end
  return false
end

M.colorscheme = 'nordic'

M.jumpWithVirtLineDiagnostics = function(jumpCount)
  pcall(vim.api.nvim_del_augroup_by_name, 'jumpWithVirtLineDiags') -- prevent autocmd for repeated jumps

  vim.diagnostic.jump { count = jumpCount }

  vim.diagnostic.config {
    virtual_text = false,
    virtual_lines = { current_line = true },
  }

  vim.defer_fn(function() -- deferred to not trigger by jump itself
    vim.api.nvim_create_autocmd('CursorMoved', {
      desc = 'User(once): Reset diagnostics virtual lines',
      once = true,
      group = vim.api.nvim_create_augroup('jumpWithVirtLineDiags', {}),
      callback = function()
        vim.diagnostic.config { virtual_lines = false, virtual_text = true }
      end,
    })
  end, 1)
end

return M
