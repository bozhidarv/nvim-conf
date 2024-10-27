local add = MiniDeps.add

add {
  source = 'Hoffs/omnisharp-extended-lsp.nvim',
  depends = { 'nvim-telescope/telescope.nvim' },
}

add {
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
}

--#region Diagnostic Signs Configuration
local severities = vim.diagnostic.severity
for level = 1, 4 do
  local severity = string.lower(severities[level])
  local hl = 'DiagnosticSign' .. require('options.utils').firstToUpper(severity)
  vim.fn.sign_define(hl, { text = MiniIcons.get('lsp', severity), texthl = hl, numhl = hl })
end
--#endregion

-- LSP settings (for overriding per client)
local custom_border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = custom_border, max_width = 100, max_height = 10, scrollbar = true }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = custom_border, max_width = 100, max_height = 10 }),
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
    -- cmd = {
    --   'jdtls',
    --   '-data',
    --   vim.fn.stdpath 'data' .. '/lspconfig/jdtls-workspace',
    -- },
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
  omnisharp = {
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    settings = {
      RoslynExtensionsOptions = {
        -- Enables support for roslyn analyzers, code fixes and rulesets.
        EnableAnalyzersSupport = false,
        -- Enables support for showing unimported types and unimported extension
        -- methods in completion lists. When committed, the appropriate using
        -- directive will be added at the top of the current file. This option can
        -- have a negative impact on initial completion responsiveness,
        -- particularly for the first few completion sessions after opening a
        -- solution.
        EnableImportCompletion = true,
        -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
        -- true
        AnalyzeOpenDocumentsOnly = true,
        inlayHintsOptions = {
          enableForParameters = true,
          forLiteralParameters = true,
          forIndexerParameters = true,
          forObjectCreationParameters = true,
          forOtherParameters = true,
          suppressForParametersThatDifferOnlyBySuffix = false,
          suppressForParametersThatMatchMethodIntent = false,
          suppressForParametersThatMatchArgumentName = false,
          enableForTypes = true,
          forImplicitVariableTypes = true,
          forLambdaParameterTypes = true,
          forImplicitObjectCreation = true,
        },
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
        workspace = {
          library = { vim.env.VIMRUNTIME },
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
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

require('mason').setup()

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
