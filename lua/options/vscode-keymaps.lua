local vscode = require('vscode')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
--#endregion

--#region Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
--#endregion

--#region Remap for moving highlighted line in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })
--#endregion

--#region QOL keymaps
vim.keymap.set('n', 'd_', '"_d', { silent = true, desc = 'Delete without yanking' })
--#endregion

--#region
vim.keymap.set('n', '<leader>C', function () vscode.action('workbench.action.closeActiveEditor') end, { silent = true, desc = 'Close editor' })
vim.keymap.set('n', '[b', function () vscode.action('workbench.action.previousEditor') end, { silent = true, desc = 'Previous editor' })
vim.keymap.set('n', ']b', function () vscode.action('workbench.action.nextEditor') end, { silent = true, desc = 'Next editor' })
vim.keymap.set('n', '<leader><leader>', function () vscode.action('workbench.action.quickOpen') end, { silent = true, desc = 'Next editor' })

--#endregion