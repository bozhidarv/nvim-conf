local jdtls = require 'jdtls'

local mason_packages = vim.fn.stdpath 'data' .. '/mason/packages'
local jdtls_package = mason_packages .. '/jdtls'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
extendedClientCapabilities.onCompletionItemSelectedCommand = 'editor.action.triggerParameterHints'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.bo.softtabstop = 4

local config = {
  -- How to run jdtls. This can be overridden to a full java command-line
  -- if the Python wrapper script doesn't suffice.
  cmd = {
    jdtls_package .. '/jdtls',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx4G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-configuration',
    jdtls_package .. '/config_linux',
    '-data',
    vim.fn.expand '$HOME/.cache/jdtls' .. project_name,
    '--jvm-arg=' .. string.format('-javaagent:%s', vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar'),
  },

  settings = {
    java = {
      maven = {
        downloadSources = true,
      },
      extendedClientCapabilities = extendedClientCapabilities,
      inlayHints = { parameterNames = { enabled = 'all' } },
      signatureHelp = {
        enabled = true,
      },
    },
  },
}

-- This bundles definition is the same as in the previous section (java-debug installation)
local bundles = {
  vim.fn.glob(mason_packages .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'),
}

vim.print(bundles)

-- This is the new part
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_packages .. '/java-test/extension/server/*.jar'), '\n'))
config['init_options'] = {
  bundles = bundles,
}

jdtls.start_or_attach(config)
