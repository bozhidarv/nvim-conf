MiniDeps.add {
  source = 'williamboman/mason.nvim',
}

local PACKAGES = {
  -- LSP
  'bash-language-server',
  'css-lsp',
  'cssmodules-language-server',
  'css-variables-language-server',
  'dockerfile-language-server',
  'html-lsp',
  'json-lsp',
  'lua-language-server',
  'rust-analyzer',
  'typescript-language-server',
  'gopls',
  -- 'zls',
  'clangd',
  'ltex-ls-plus',
  'jdtls',
  -- DAP
  'codelldb',
  'delve',
  'java-debug-adapter',
  'java-test',
  -- Format
  'black',
  'stylua',
  'gofmt',
  'gofumpt',
  'clang-format',
  'goimports',
  'golines',
  -- Lint
  'eslint_d',
  'editorconfig-checker',
  'golangci-lint',
  'pylint',
  'checkstyle',
  'sonarlint-language-server'
}

---comment
---@param pack Package
---@param version string
local function install(pack, version)
  local notifyOpts = { title = 'Mason', icon = '', id = 'mason.install' }

  local msg = version and ('[%s] updating to %s…'):format(pack.name, version) or ('[%s] installing…'):format(pack.name)
  vim.defer_fn(function()
    vim.notify(msg, nil, notifyOpts)
  end, 0)

  pack:once('install:success', function()
    local msg2 = ('[%s] %s'):format(pack.name, version and 'updated.' or 'installed.')
    notifyOpts.icon = ' '
    vim.defer_fn(function()
      vim.notify(msg2, nil, notifyOpts)
    end, 0)
  end)

  pack:once('install:failed', function()
    local error = 'Failed to install [' .. pack.name .. ']'
    vim.defer_fn(function()
      vim.notify(error, vim.log.levels.ERROR, notifyOpts)
    end, 0)
  end)

  pack:install { version = version }
end

---comment
---@param ensurePacks string[]
local function syncPackages(ensurePacks)
  local masonReg = require 'mason-registry'

  local function refreshCallback()
    -- Auto-install missing packages & auto-update installed ones
    ---@param packName string
    vim.iter(ensurePacks):each(function(packName)
      -- Extract package name and pinned version if specified
      local name, pinnedVersion = packName:match '([^@]+)@?(.*)'
      if not masonReg.has_package(name) then
        return
      end
      local pack = masonReg.get_package(name)
      if not pack:is_installed() then
        install(pack, pinnedVersion ~= '' and pinnedVersion or nil)
      end
    end)
  end

  masonReg.refresh(refreshCallback)
end

---@diagnostic disable-next-line: missing-fields
require('mason').setup {
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
}

syncPackages(PACKAGES)
