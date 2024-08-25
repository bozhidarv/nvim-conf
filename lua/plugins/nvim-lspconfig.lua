return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Additional lua configuration, makes nvim stuff amazing!
    { 'nvim-java/nvim-java' },
  },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
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
      jdtls = {
        cmd = {
          'jdtls',
          '-data',
          vim.fn.stdpath 'data' .. '/lspconfig/jdtls-workspace',
        },
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
      tsserver = {
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
              library = vim.api.nvim_get_runtime_file('', true),
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
