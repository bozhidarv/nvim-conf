vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = 'make',
  callback = function()
    local qflist = vim.fn.getqflist()
    local diagnostics = vim.diagnostic.fromqflist(qflist)
    vim.diagnostic.set(vim.api.nvim_create_namespace 'make_diagnostics', 0, diagnostics)
  end,
})
