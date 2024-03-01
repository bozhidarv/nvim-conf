local bundles = {
  vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar',
    true)
}

vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-test/extension/server/*.jar', true),
    '\n'
  )
)

local opts = {
  cmd = {},
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {},
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          -- {
          --   name = 'JavaSE-1.8',
          --   path = '/usr/lib/jvm/jdk1.8.0_351',
          --   default = true,
          -- },
        },
      },
    },
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = require('jdtls').extendedClientCapabilities
  },
}

vim.o.tabstop = 4
vim.o.shiftwidth = 4

local function setup()
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  local pkg_status, jdtls = pcall(require, 'jdtls')
  local jdtls_dap = require("jdtls.dap")
  if not pkg_status then
    vim.notify('unable to load nvim-jdtls', 1)
    return {}
  end

  local jdtls_path = vim.fn.stdpath("data") ..
      "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar"
  local lombok_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
  local confPath = vim.fn.stdpath 'data' ..
      '/mason/packages/jdtls/config_linux'
  if vim.fn.has('win32') == 1 then
    jdtls_path = vim.fn.stdpath 'data' ..
        '\\mason\\packages\\jdtls\\plugins\\org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar'
    confPath = vim.fn.stdpath 'data' ..
        '\\mason\\packages\\jdtls\\config_win'
    lombok_path = vim.fn.stdpath 'data' .. '\\mason\\packages\\jdtls\\lombok.jar'
  end


  local root_markers = { '.gradle', 'gradlew', '.git' }
  local root_dir = jdtls.setup.find_root(root_markers)
  local home = os.getenv 'HOME'
  local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
  local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

  opts.cmd = {
    'java', -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '-javaagent:' .. lombok_path,
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    jdtls_path,
    '-configuration',
    confPath,
    '-data',
    workspace_dir,
  }
  local on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>djc', jdtls.test_class, { desc = 'Jdtls test class' })
    vim.keymap.set('n', '<leader>djm', jdtls.test_nearest_method, { desc = 'Jdtls test nearest method' })

    require('options.utils').on_attach(client, bufnr)

    -- if you setup DAP according to https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration you can uncomment below
    --
    ---@diagnostic disable-next-line: missing-fields
    jdtls.setup_dap { hotcodereplace = 'auto' }
    jdtls_dap.setup_dap_main_class_configs()
    -- require('jdtls.dap').setup_dap_main_class_configs()
    -- you may want to also run your generic on_attach() function used by your LSP config
  end

  opts.on_attach = on_attach
  opts.capabilities = vim.lsp.protocol.make_client_capabilities()
  return opts
end

local pkg_status, jdtls = pcall(require, 'jdtls')
if not pkg_status then
  vim.notify('unable to load nvim-jdtls', 1)
  return
end

jdtls.start_or_attach(setup()) -- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
