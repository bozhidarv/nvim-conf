---@diagnostic disable: missing-fields
local add = MiniDeps.add

add {
  source = 'seblj/roslyn.nvim',
}

require('roslyn').setup {
  {
    config = {
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    },
    exe = {
      'dotnet',
      vim.fs.joinpath(vim.fn.stdpath 'data', 'roslyn', 'Microsoft.CodeAnalysis.LanguageServer.dll'),
    },
    filewatching = true,
    choose_sln = nil,
  },
}

add {
  source = 'neovim/nvim-lspconfig',
  depends = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- 'hrsh7th/cmp-nvim-lsp',
  },
}

--#region Diagnostic Signs Configuration

local severities = vim.diagnostic.severity

--- @type vim.diagnostic.Opts.Signs
local signs_config = { text = {}, numhl = {} }

for level = 1, 4 do
  local severity = string.lower(severities[level])
  local num_hl_name = 'DiagnosticSign' .. require('options.utils').firstToUpper(severity)

  table.insert(signs_config.numhl, num_hl_name)
  signs_config.text = vim.tbl_extend('force', signs_config.text, { [severities[level]] = MiniIcons.get('lsp', severity) })
end

vim.diagnostic.config {
  signs = signs_config,
  virtual_text = true,
}
--#endregion

-- LSP settings (for overriding per client)
local custom_border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover,
    { border = custom_border, max_width = 100, max_height = 10, scrollbar = true }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
    { border = custom_border, max_width = 100, max_height = 10 }),
}

--#region Default LSP Servers
local servers = {
  clangd = {
    cmd = {
      'clangd',
      '--offset-encoding=utf-16',
    },
  },
  jdtls = {
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = 'JavaSE-21',
              path = '/usr/lib/jvm/java-21-openjdk',
              default = true,
            },
            {
              name = 'JavaSE=17',
              path = '/usr/lib/jvm/jdk-17-oracle-x64',
              default = false,
            },
          },
        },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        ['ui.inlayhint.hints'] = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        hoverKind = 'FullDocumentation',
      },
    },
  },
  ts_ls = {
    documentFormatting = true,
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
  angularls = {
    filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
  },
  html = {
    filetypes = { 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = {
            'require',
          },
        },
        telemetry = {
          checkThirdParty = false,
          enable = false,
        },
        hint = { enable = true },
      },
    },
  },
}
if vim.fn.has 'win32' ~= 1 then
  servers['sqls'] = {
    settings = {
      sqls = {
        connections = {
          {
            driver = 'postgresql',
            dataSourceName = 'host=127.0.0.1 port=5432 user=postgres password=poll-api dbname=postgres sslmode=disable',
          },
        },
      },
    },
  }
end

--#endregion

--#region LSP Configuration
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

require('mason').setup {
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
}

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      server.handlers = handlers
      require('lspconfig')[server_name].setup(server)
    end,
  },
  ensure_installed = vim.tbl_keys(servers),
}

local format_is_enabled = true
vim.api.nvim_create_user_command('ToggleFormatOnSave', function()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

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

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('refresh-codelens', { clear = true }),
  callback = function(event)
    vim.lsp.codelens.refresh { bufnr = event.buf }
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = 'make',
  callback = function()
    local qflist = vim.fn.getqflist()
    local diagnostics = vim.diagnostic.fromqflist(qflist)
    vim.diagnostic.set(vim.api.nvim_create_namespace 'make_diagnostics', 0, diagnostics)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { buffer = bufnr, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gI', require('fzf-lua').lsp_implementations,
      { buffer = bufnr, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', '<leader>D', require('fzf-lua').lsp_typedefs, { buffer = bufnr, desc = 'Type [D]efinition' })
    vim.keymap.set('n', '<leader>cs', require('fzf-lua').lsp_document_symbols,
      { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
    vim.keymap.set('n', '<leader>cS', require('fzf-lua').lsp_live_workspace_symbols,
      { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })

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

    -- NOTE: For when I find out how to use lazydev.nvim with this
    -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, event.buf) then
    --   client.server_capabilities.completionProvider.triggerCharacters = vim.split('qwertyuiopasdfghjklzxcvbnm. ', '')
    --   vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    --   vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = bufnr, desc = 'Activate completion' })
    --
    --   local ls = require 'lazydev'
    --
    --   vim.keymap.set('i', '<C-h>', function()
    --     vim.snippet.jump(-1)
    --   end, { buffer = bufnr, desc = 'Jump to previous part of the snippet' })
    --   vim.keymap.set('i', '<C-l>', function()
    --     vim.snippet.jump(1)
    --   end, { buffer = bufnr, desc = 'Jump to next part of the snippet' })
    -- end

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

    -- Prefer LSP folding if client supports it
    if client and client:supports_method 'textDocument/foldingRange' then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set('n', '<leader>cth', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
      end, { buffer = bufnr, desc = '[T]oggle Inlay [H]ints' })
    end
  end,
})
