local add = MiniDeps.add

add {
  source = 'seblj/roslyn.nvim',
}

require('roslyn').setup {
  {
    config = {
      -- Here you can pass in any options that that you would like to pass to `vim.lsp.start`.
      -- Use `:h vim.lsp.ClientConfig` to see all possible options.
      -- The only options that are overwritten and won't have any effect by setting here:
      --     - `name`
      --     - `cmd`
      --     - `root_dir`
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

    --[[
    -- if you installed `roslyn-ls` by nix, use the following:
      exe = 'Microsoft.CodeAnalysis.LanguageServer',
    ]]
    exe = {
      'dotnet',
      vim.fs.joinpath(vim.fn.stdpath 'data', 'roslyn', 'Microsoft.CodeAnalysis.LanguageServer.dll'),
    },

    -- NOTE: Set `filewatching` to false if you experience performance problems.
    -- Defaults to true, since turning it off is a hack.
    -- If you notice that the server is _super_ slow, it is probably because of file watching
    -- Neovim becomes super unresponsive on some large codebases, because it schedules the file watching on the event loop.
    -- This issue goes away by disabling this capability, but roslyn will fallback to its own file watching,
    -- which can make the server super slow to initialize.
    -- Setting this option to false will indicate to the server that neovim will do the file watching.
    -- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
    -- a lot faster to initialize.
    filewatching = true,

    -- Optional function that takes an array of solutions as the only argument. Return the solution you
    -- want to use. If it returns `nil`, then it falls back to guessing the solution like normal
    -- Example:
    --
    -- choose_sln = function(sln)
    --     return vim.iter(sln):find(function(item)
    --         if string.match(item, "Foo.sln") then
    --             return item
    --         end
    --     end)
    -- end
    choose_sln = nil,
  },
}

add {
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
}

--#region Diagnostic Signs Configuration

--- @type vim.diagnostic.Severity
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
}
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
