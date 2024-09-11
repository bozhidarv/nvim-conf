return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Additional lua configuration, makes nvim stuff amazing!
    { 'nvim-java/nvim-java' },
    {
      'Hoffs/omnisharp-extended-lsp.nvim',
      lazy = true,
      dependencies = {
        'nvim-telescope/telescope.nvim',
      },
    },
    { 'nanotee/sqls.nvim' },
  },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    require('java').setup()

    --#region Diagnostic Signs Configuration
    local signs = require('options.utils').lspSigns
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    --#endregion

    --#region Default LSP Servers
    local servers = {
      clangd = {
        cmd = {
          'clangd',
          '--offset-encoding=utf-16',
        },
      },
      sqls = {
        settings = {
          sqls = {
            connections = {
              {
                driver = 'postgresql',
                dataSourceName =
                'host=127.0.0.1 port=5432 user=postgres password=poll-api dbname=postgres sslmode=disable',
              },
            },
          },
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
        documentFormatting = false,
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
      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = {
                'vim',
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
    --#endregion

    --#region LSP Configuration
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
      ensure_installed = vim.tbl_keys(servers),
    }
    --#endregion
  end,
}
