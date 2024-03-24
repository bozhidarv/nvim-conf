return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  event = 'BufAdd',
  lazy = true,
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim',       opts = {} },
    { 'github/copilot.vim' },
    -- Additional lua configuration, makes nvim stuff amazing!
    {
      'folke/neodev.nvim',
      opts = {
        library = {
          vim = {
            -- The path to the runtime files for Neovim
            runtime = vim.api.nvim_get_runtime_file('', true),
            -- The path to the runtime files for Lua
            lua = vim.api.nvim_get_runtime_file('lua', true),
          },
        },
        { plugins = { 'nvim-dap-ui' }, types = true },
      },
    },
    {
      'nvim-java/nvim-java',
      opts = {},
      dependencies = {
        'nvim-java/lua-async-await',
        'nvim-java/nvim-java-core',
        'nvim-java/nvim-java-test',
        'nvim-java/nvim-java-dap',
        'MunifTanjim/nui.nvim',
        'neovim/nvim-lspconfig',
        'mfussenegger/nvim-dap',
        {
          'williamboman/mason.nvim',
          opts = {
            registries = {
              'github:nvim-java/mason-registry',
              'github:mason-org/mason-registry',
            },
          },
        },
      },
    },
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
      clangd = {},
      tsserver = {
        documentFormatting = false,
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
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = require('options.utils').on_attach,
            settings = servers[server_name],
          }
        end,
        ['clangd'] = function()
          require('lspconfig')['clangd'].setup {
            capabilities = capabilities,
            on_attach = require('options.utils').on_attach,
            cmd = {
              'clangd',
              '--offset-encoding=utf-16',
            },
          }
        end,
        ['jdtls'] = function()
          require('lspconfig')['jdtls'].setup {
            capabilities = capabilities,
            on_attach = require('options.utils').on_attach,
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
          }
        end,
        ['tsserver'] = function()
          require('lspconfig')['tsserver'].setup {
            capabilities = capabilities,
            on_attach = require('options.utils').on_attach,
          }
        end,
      },
    }
    --#endregion
  end,
}
