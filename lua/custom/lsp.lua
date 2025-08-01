local severities = vim.diagnostic.severity

--- @type vim.diagnostic.Opts.Signs
local signs_config = { text = {}, numhl = {} }

for level = 1, 4 do
  local severity = string.lower(severities[level])
  local num_hl_name = 'DiagnosticSign' .. require('utils').firstToUpper(severity)

  table.insert(signs_config.numhl, num_hl_name)
  signs_config.text = vim.tbl_extend('force', signs_config.text, { [severities[level]] = MiniIcons.get('lsp', severity) })
end

vim.diagnostic.config {
  signs = signs_config,
  virtual_text = true,
}

--#region LspAttach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })

    ---@type vim.lsp.Client|nil
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { buffer = bufnr, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gI', require('fzf-lua').lsp_implementations, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', '<leader>D', require('fzf-lua').lsp_typedefs, { buffer = bufnr, desc = 'Type [D]efinition' })
    vim.keymap.set('n', '<leader>cs', require('fzf-lua').lsp_document_symbols, { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
    vim.keymap.set('n', '<leader>cS', require('fzf-lua').lsp_live_workspace_symbols, { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })

    vim.keymap.set('n', '<leader>cf', function()
      require('conform').format { async = true }
    end, { buffer = bufnr, desc = 'Format buffer' })

    -- See `:help K` for why this keymap
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
    vim.keymap.set('n', '<leader>ck', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })

    -- Lesser used LSP functionality
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]oto [D]eclaration' })
    vim.keymap.set('n', '<leader>cwa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = '[W]orkspace [A]dd Folder' })
    vim.keymap.set('n', '<leader>cwr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = '[W]orkspace [R]emove Folder' })
    vim.keymap.set('n', '<leader>cwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = bufnr, desc = '[W]orkspace [L]ist Folders' })
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    if client and (client.name == 'jdtls') then
      vim.keymap.set('n', '<leader>tc', function()
        require('jdtls').test_nearest_method()
      end, { silent = true, desc = 'Run closest test' })
      vim.keymap.set('n', '<leader>tf', function()
        require('jdtls').test_class()
      end)
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- NOTE: How to add custom per lsp kind colors
    -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, event.buf) then
    --   client.server_capabilities.completionProvider.triggerCharacters = vim.split('qwertyuiopasdfghjklzxcvbnm. ', '')
    --   vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    --   vim.opt.omnifunc = 'v:lua.require("custom.omnifunc-enhanced").omnifunc'
    --   vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = bufnr, desc = 'Activate completion' })
    -- end

    -- Prefer LSP folding if client supports it
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set('n', '<leader>cth', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
      end, { buffer = bufnr, desc = '[T]oggle Inlay [H]ints' })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('refresh-codelens', { clear = true }),
        callback = function(e)
          vim.lsp.codelens.refresh { bufnr = e.buf }
        end,
      })
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { buffer = bufnr, desc = 'Run current line codelenses' })
      vim.api.nvim_create_autocmd({ 'BufLeave' }, {
        group = vim.api.nvim_create_augroup('clear-codelens', { clear = true }),
        callback = function(e)
          vim.lsp.codelens.clear(nil, e.buf)
        end,
      })
    end
  end,
})
--#endregion
