---@diagnostic disable: missing-fields
MiniDeps.add {
  source = 'neovim/nvim-lspconfig',
}

--#region Default LSP Servers
---@type table<string, vim.lsp.Config>
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
  jsonls = {},
  zls = {},
}


local capabilities = require('blink.cmp').get_lsp_capabilities()
for k, v in pairs(servers) do
  v.capabilities = vim.tbl_deep_extend('force', capabilities, v.capabilities or {})
  require('lspconfig')[k].setup(v)
end
