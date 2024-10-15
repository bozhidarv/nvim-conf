local add = MiniDeps.add

add {
  source = 'stevearc/conform.nvim',
}

require('conform').setup {
  -- Define your formatters
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    javascript = { 'eslint_d', lsp_format = 'fallback', stop_after_first = true },
    typescript = { 'eslint_d', lsp_format = 'fallback', stop_after_first = true },
    go = { 'gofumpt', 'gofmt', 'goimports', 'golines' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    c = { 'clang-format' },
    cpp = { 'clang-format' },
    yaml = { 'prettierd' },
    markdown = { 'prettierd' },
    astro = { 'prettierd' },
    css = { 'prettierd' },
    cs = { 'csharpier' },
    rust = { 'rustfmt' },
  },
  -- Set default options
  default_format_opts = {
    lsp_format = 'fallback',
  },
  -- Set up format-on-save
  -- format_on_save = { timeout_ms = 500 },
  -- Customize formatters
  formatters = {
    shfmt = {
      prepend_args = { '-i', '2' },
    },
  },
}
