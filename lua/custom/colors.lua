local colorscheme = 'tomorrow-night'

if vim.g.noplugins ~= true then
  colorscheme = require('utils').colorscheme
end
vim.cmd.colorscheme(colorscheme)

local isTransparent = require('utils').checkTransperancy

if isTransparent() then
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

vim.api.nvim_create_user_command('ToggleBackground', function()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end, {})

