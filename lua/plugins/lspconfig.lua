local add = MiniDeps.add

---@diagnostic disable: missing-fields
add {
  source = 'neovim/nvim-lspconfig',
  depends = {
    'mfussenegger/nvim-jdtls',
  },
}

---@type string[]
local LSP_SERVERS = {
  'gopls',
  'clangd',
  'ts_ls',
  'html',
  'lua_ls',
  'jsonls',
  'zls',
  'cssls',
  'bashls',
  'rust_analyzer',
  'dockerls',
  'css_variables',
  'cssmodules_ls',
  'lemminx',
  'cmake',
  'ols',
  'pylsp'
}

add {
  source = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
}

for _, lsp_server in pairs(LSP_SERVERS) do
  vim.lsp.enable(lsp_server)
end

require('sonarlint').setup {
  server = {
    cmd = {
      'sonarlint-language-server',
      -- Ensure that sonarlint-language-server uses stdio channel
      '-stdio',
      '-analyzers',
      -- paths to the analyzers you need, using those for python and java in this example
      vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarpython.jar',
      vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarcfamily.jar',
      vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjava.jar',
    },
  },
  filetypes = {
    -- Tested and working
    'cs',
    'dockerfile',
    'python',
    'cpp',
    'java',
  },
}
