-- [[ Setting options ]]
-- See `:help vim.o`

vim.o.background = 'dark'

local colorscheme = require('options.utils').colorscheme
local isTransparent = require('options.utils').checkTransperancy

vim.cmd.colorscheme(colorscheme)

if isTransparent() then
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

if vim.fn.executable 'rg' then
  vim.o.grepprg = 'rg --vimgrep --smart-case --hidden --engine auto'
  vim.o.grepformat = '%f:%l:%c:%m'
end

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Enable cursor line
vim.opt.cursorline = true

vim.o.termguicolors = true
vim.o.relativenumber = true

vim.opt.colorcolumn = '100'
vim.o.laststatus = 3

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

-- ufo.nvim settings
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.statuscolumn = [[%!v:lua.require'custom.statuscol'.statuscolumn()]]
vim.o.winbar = [[%#MiniStatuslineFilename# %f %m]]

vim.g.copilot_no_tab_map = true

if vim.g.vscode then
  require 'options.vscode-keymaps'
else
  require 'options.keymaps'
end
