require 'options'

if vim.g.noplugins ~= true then
  local path_package = vim.fn.stdpath 'data' .. '/site/'
  local mini_path = path_package .. 'pack/deps/start/mini.nvim'
  if not vim.uv.fs_stat(mini_path) then
    vim.cmd 'echo "Installing `mini.nvim`" | redraw'
    local clone_cmd = {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/echasnovski/mini.nvim',
      mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd 'packadd mini.nvim | helptags ALL'
    vim.cmd 'echo "Installed `mini.nvim`" | redraw'
  end

  require('mini.deps').setup { path = { package = path_package } }

  require('mini.icons').setup {
    lsp = {
      ['error'] = { glyph = '󰀨 ', hl = 'LspDiagnosticsDefaultError' },
      ['warn'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultWarning' },
      ['info'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultInformation' },
      ['hint'] = { glyph = '󰌵 ', hl = 'LspDiagnosticsDefaultHint' },
    },
  }

  for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath 'config' .. '/lua/plugins', [[v:val =~ '\.lua$']])) do
    require('plugins.' .. file:gsub('%.lua$', ''))
  end

  require 'custom.lsp'
  require 'custom.formatting'
end

require 'custom.colors'
require 'custom.compile'
require('custom.notes-plugin').setup()

vim.api.nvim_create_autocmd('FileType', {
  pattern = {},
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

vim.opt.statuscolumn = [[%!v:lua.require'custom.statuscol'.statuscolumn()]]

require 'keymaps'
