-- #TODO Migrate from null-ls

return {
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      {
        'jay-babu/mason-null-ls.nvim',
        cmd = { 'NullLsInstall', 'NullLsUninstall' },
        opts = { handlers = {} },
      },
    },
    opts = function()
      local nls = require 'null-ls'
      return {
        sources = {
          nls.builtins.formatting.beautysh.with {
            command = 'beautysh',
            args = {
              '--indent-size=2',
              '$FILENAME',
            },
          },
          nls.builtins.code_actions.gomodifytags,
          nls.builtins.code_actions.eslint_d,
          nls.builtins.diagnostics.editorconfig_checker,
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.diagnostics.golangci_lint,
          nls.builtins.formatting.goimports,
          nls.builtins.formatting.golines,
          nls.builtins.formatting.gofumpt,
          nls.builtins.formatting.prettierd.with({
            extra_filetypes = { "astro", "json" },
          }),
        },
      }
    end,
  },
}
