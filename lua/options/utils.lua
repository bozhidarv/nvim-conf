local M = {}

M.on_attach = function(client, bufnr)
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })

  vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
    { buffer = bufnr, desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type [D]efinition' })
  vim.keymap.set('n', '<leader>fS', require('telescope.builtin').lsp_document_symbols,
    { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
  vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_dynamic_workspace_symbols,
    { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })
  vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { buffer = bufnr, desc = 'Format buffer' })

  -- See `:help K` for why this keymap
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
  vim.keymap.set('n', '<leader>ck', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })

  -- Lesser used LSP functionality
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]oto [D]eclaration' })
  vim.keymap.set('n', '<leader>cwa', vim.lsp.buf.add_workspace_folder,
    { buffer = bufnr, desc = '[W]orkspace [A]dd Folder' })
  vim.keymap.set('n', '<leader>cwr', vim.lsp.buf.remove_workspace_folder,
    { buffer = bufnr, desc = '[W]orkspace [R]emove Folder' })
  vim.keymap.set('n', '<leader>cwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { buffer = bufnr, desc = '[W]orkspace [L]ist Folders', })
  vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

M.checkTransperancy = function()
  local isTrans = os.getenv 'NVIM_TRANSPARENT_BACKGROUND'
  if isTrans == nil then
    return false
  end
  if isTrans == 'true' then
    return true
  end
  return false
end

M.colorscheme = 'tokyonight'

return M
