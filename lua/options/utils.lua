local M = {}

M.lspSigns = {
  Error = ' ',
  Warn = ' ',
  Hint = ' ',
  Info = ' ',
}

M.on_attach = function(_, bufnr)
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })

  vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
    { buffer = bufnr, desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type [D]efinition' })
  vim.keymap.set('n', '<leader>cs', require('telescope.builtin').lsp_document_symbols,
    { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
  vim.keymap.set('n', '<leader>cS', require('telescope.builtin').lsp_dynamic_workspace_symbols,
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
  end, { buffer = bufnr, desc = '[W]orkspace [L]ist Folders' })
  vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

M.unsaved_files_telescope_picker = function(bufnrs, opts)
  local conf = require('telescope.config').values
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local make_entry = require 'telescope.make_entry'

  local buffers = {}
  local default_selection_idx = 1
  for _, bufnr in ipairs(bufnrs) do
    local flag = bufnr == vim.fn.bufnr '' and '%' or (bufnr == vim.fn.bufnr '#' and '#' or ' ')

    local element = {
      bufnr = bufnr,
      flag = flag,
      info = vim.fn.getbufinfo(bufnr)[1],
    }

    table.insert(buffers, element)
  end

  if not opts.bufnr_width then
    local max_bufnr = math.max(unpack(bufnrs))
    opts.bufnr_width = #tostring(max_bufnr)
  end

  pickers
      .new(opts, {
        prompt_title = 'Unsaved Buffers',
        finder = finders.new_table {
          results = buffers,
          entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts),
        },
        previewer = conf.grep_previewer(opts),
        sorter = conf.generic_sorter(opts),
        default_selection_index = default_selection_idx,
        attach_mappings = function(_, map)
          map({ 'i', 'n' }, '<M-w>', M.write_buffer_telescope_action)
          return true
        end,
      })
      :find()
end

M.write_buffer_telescope_action = function(prompt_bufnr)
  local action_state = require 'telescope.actions.state'

  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:delete_selection(function(selection)
    vim.api.nvim_buf_call(selection.bufnr, function()
      vim.cmd 'silent! write'
    end)
    return true
  end)
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
