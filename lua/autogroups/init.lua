-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
    vim.keymap.set('n', '<leader>ca', function()
      require('fzf-lua').lsp_code_actions {
        previewer = false,
      }
    end, { buffer = bufnr, desc = '[C]ode [A]ction' })

    vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { buffer = bufnr, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type [D]efinition' })
    vim.keymap.set('n', '<leader>cs', require('fzf-lua').lsp_document_symbols, { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
    vim.keymap.set('n', '<leader>cS', require('fzf-lua').lsp_live_workspace_symbols, { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })
    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { buffer = bufnr, desc = 'Format buffer' })

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

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set('n', '<leader>cth', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
      end, { buffer = bufnr, desc = '[T]oggle Inlay [H]ints' })
    end
  end,
})

vim.api.nvim_create_autocmd('ExitPre', {
  callback = function(_)
    local unsaved_buffers = vim.fn.getbufinfo { buflisted = 1, bufmodified = 1 }
    if #unsaved_buffers > 0 then
      require('fzf-lua').buffers {
        actions = {
          ['ctrl-x'] = { fn = require('fzf-lua.actions').buf_del, reload = true },
          ['ctrl-w'] = { fn = require('options.utils').fzf_lua_save_buffer_action, reload = true },
        },
      }
    else
      vim.cmd 'qall!'
    end
  end,
})

local format_is_enabled = true
vim.api.nvim_create_user_command('KickstartFormatToggle', function()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

local _augroups = {}
local get_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = 'kickstart-lsp-format-' .. client.name
    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end

  return _augroups[client.id]
end

-- Whenever an LSP attaches to a buffer, we will run this function.
--
-- See `:help LspAttach` for more information about this autocmd event.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
  -- This is where we attach the autoformatting for reasonable clients
  callback = function(args)
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local bufnr = args.buf

    if client == nil then
      return
    end

    -- Only attach to clients that support document formatting
    if not client.server_capabilities.documentFormattingProvider then
      return
    end

    -- Tsserver usually works poorly. Sorry you work with bad languages
    -- You can remove this line if you know what you're doing :)
    if client.name == 'tsserver' then
      return
    end

    -- Create an autocmd that will run *before* we save the buffer.
    --  Run the formatting command for the LSP that has just attached.
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = get_augroup(client),
      buffer = bufnr,
      callback = function()
        if not format_is_enabled then
          return
        end

        vim.lsp.buf.format {
          async = false,
          filter = function(c)
            return c.id == client.id
          end,
        }
      end,
    })
  end,
})
