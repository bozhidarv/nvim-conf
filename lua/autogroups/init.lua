--- Event arguments table
---@class event_args
---@field id number Autocommand ID.
---@field event string Name of the triggered event. See |autocmd-events|.
---@field group number|nil Autocommand group ID, if any.
---@field match string Expanded value of `<amatch>`.
---@field buf number Expanded value of `<abuf>`.
---@field data any Arbitrary data passed from |nvim_exec_autocmds()|.
---@field file string Expanded value of `<afile>`.

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

local format_is_enabled = true
vim.api.nvim_create_user_command('KickstartFormatToggle', function()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

---@type table<integer, integer>
local _augroups = {}

---@param client vim.lsp.Client
local get_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = 'kickstart-lsp-format-' .. client.name
    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end

  return _augroups[client.id]
end

vim.api.nvim_create_user_command('LazyGitOpen', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }
  lazygit:toggle()
end, {})

-- Whenever an LSP attaches to a buffer, we will run this function.
--
-- See `:help LspAttach` for more information about this autocmd event.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
  -- This is where we attach the autoformatting for reasonable clients
  ---@param args event_args
  callback = function(args)
    ---@type integer
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
      require('conform').format { bufnr = args.buf }
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
        require('conform').format { bufnr = args.buf }
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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  ---@param event event_args
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
    vim.keymap.set('n', '<leader>ca', require('fzf-lua').lsp_code_actions, { buffer = bufnr, desc = '[C]ode [A]ction' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local picker = require('options.utils').picker

    if client and client.name == 'sqls' then
      require('sqls').on_attach(client, bufnr)
    end

    if client and client.name == 'omnisharp' then
      vim.keymap.set('n', 'gd', require('omnisharp_extended').telescope_lsp_definition,
        { buffer = bufnr, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gr', require('omnisharp_extended').telescope_lsp_references,
        { buffer = bufnr, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gI', require('omnisharp_extended').telescope_lsp_implementation,
        { buffer = bufnr, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', '<leader>D', require('omnisharp_extended').telescope_lsp_type_definition,
        { buffer = bufnr, desc = 'Type [D]efinition' })
    else
      if picker == 'fzf_lua' then
        vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { buffer = bufnr, desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
        vim.keymap.set('n', 'gI', require('fzf-lua').lsp_implementations,
          { buffer = bufnr, desc = '[G]oto [I]mplementation' })
        vim.keymap.set('n', '<leader>D', require('fzf-lua').lsp_typedefs, { buffer = bufnr, desc = 'Type [D]efinition' })
      elseif picker == 'telescope' then
        vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
          { buffer = bufnr, desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
          { buffer = bufnr, desc = '[G]oto [R]eferences' })
        vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations,
          { buffer = bufnr, desc = '[G]oto [I]mplementation' })
        vim.keymap.set('n', '<leader>D', require('telescope.builtin').lsp_type_definitions,
          { buffer = bufnr, desc = 'Type [D]efinition' })
      end
    end

    if picker == 'fzf_lua' then
      vim.keymap.set('n', '<leader>cs', require('fzf-lua').lsp_document_symbols,
        { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
      vim.keymap.set('n', '<leader>cS', require('fzf-lua').lsp_live_workspace_symbols,
        { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })
    elseif picker == 'telescope' then
      vim.keymap.set('n', '<leader>cs', require('telescope.builtin').lsp_document_symbols,
        { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
      vim.keymap.set('n', '<leader>cS', require('telescope.builtin').lsp_dynamic_workspace_symbols,
        { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })
    end
    vim.keymap.set('n', '<leader>cf', function()
      require('conform').format { async = true }
    end, { buffer = bufnr, desc = 'Format buffer' })
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

    if client and (client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) or client.name == 'omnisharp') then
      vim.keymap.set('n', '<leader>cth', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
      end, { buffer = bufnr, desc = '[T]oggle Inlay [H]ints' })
    end
  end,
})
