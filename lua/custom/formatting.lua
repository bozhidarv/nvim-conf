---@type table<integer, integer>
local _augroups = {}

---@param client vim.lsp.Client
local get_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = 'lsp-format-' .. client.name
    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end

  return _augroups[client.id]
end

local format_is_enabled = false
vim.api.nvim_create_user_command('ToggleFormatOnSave', function()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach-format-on-save', { clear = true }),
  -- This is where we attach the autoformatting for reasonable clients
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
      end,
    })
  end,
})

