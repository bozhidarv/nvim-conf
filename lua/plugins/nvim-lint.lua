local add = MiniDeps.add

add {
  source = 'mfussenegger/nvim-lint',
}

local M = {}

local lint = require 'lint'
lint.linters_by_ft = {
  fish = { 'fish' },
  go = { 'golangcilint' },
  javascript = { 'eslint_d', 'editorconfig-checker' },
  typescript = { 'eslint_d', 'editorconfig-checker' },
  javascriptreact = { 'eslint_d', 'editorconfig-checker' },
  typescriptreact = { 'eslint_d', 'editorconfig-checker' },
  svelte = { 'eslint_d', 'editorconfig-checker' },
  -- Use the "*" filetype to run linters on all filetypes.
  -- ['*'] = { 'global linter' },
  -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
  -- ['_'] = { 'fallback linter' },
  -- ["*"] = { "typos" },
}

function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

function M.lint()
  -- Use nvim-lint's logic first:
  -- * checks if linters exist for the full filetype first
  -- * otherwise will split filetype by "." and add all those linters
  -- * this differs from conform.nvim which only uses the first filetype that has a formatter
  local names = lint._resolve_linter_by_ft(vim.bo.filetype)

  -- Create a copy of the names table to avoid modifying the original.
  names = vim.list_extend({}, names)

  -- Add fallback linters.
  if #names == 0 then
    vim.list_extend(names, lint.linters_by_ft['_'] or {})
  end

  -- Add global linters.
  vim.list_extend(names, lint.linters_by_ft['*'] or {})

  -- Filter out linters that don't exist or don't match the condition.
  local ctx = { filename = vim.api.nvim_buf_get_name(0) }
  ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')
  names = vim.tbl_filter(function(name)
    local linter = lint.linters[name]
    if not linter then
      vim.print('Linter not found: ' .. name, { title = 'nvim-lint' })
    end
    return linter and not (type(linter) == 'table' and linter.condition and not linter.condition(ctx))
  end, names)

  -- Run linters.
  if #names > 0 then
    lint.try_lint(names)
  end
end

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
  callback = M.debounce(100, M.lint),
})