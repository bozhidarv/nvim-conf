local add = MiniDeps.add

---@diagnostic disable: missing-fields
add {
  source = 'neovim/nvim-lspconfig',
  depends = {
    'mfussenegger/nvim-jdtls',
  },
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
  cssls = {},
  bashls = {},
  rust_analyzer = {},
  dockerls = {},
  css_variables = {},
  cssmodules_ls = {},
  lemminx = {},
}

local capabilities = require('blink.cmp').get_lsp_capabilities()
for k, v in pairs(servers) do
  v.capabilities = vim.tbl_deep_extend('force', capabilities, v.capabilities or {})
  require('lspconfig')[k].setup(v)
end
