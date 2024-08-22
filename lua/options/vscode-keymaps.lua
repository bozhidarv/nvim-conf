local vscode = require 'vscode'

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
vim.keymap.set('n', '<leader>C', function()
  vscode.action 'workbench.action.closeActiveEditor'
end, { silent = true, desc = 'Close editor' })
vim.keymap.set('n', '[b', function()
  vscode.action 'workbench.action.previousEditor'
end, { silent = true, desc = 'Previous editor' })
vim.keymap.set('n', ']b', function()
  vscode.action 'workbench.action.nextEditor'
end, { silent = true, desc = 'Next editor' })
vim.keymap.set('n', '<leader><leader>', function()
  vscode.action 'workbench.action.quickOpen'
end, { silent = true, desc = 'Search files' })
vim.keymap.set('n', '<leader>e', function()
  vscode.call 'workbench.view.explorer'
end, { silent = true, desc = 'Open file explorer' })
vim.keymap.set('n', '<leader>cs', function()
  vscode.action 'workbench.action.gotoSymbol'
end, { silent = true, desc = 'Show document symbols' })
vim.keymap.set('n', '<leader>ca', function()
  vscode.action 'problems.action.showQuickFixes'
end, { silent = true, desc = 'Show code actions' })
vim.keymap.set('n', '<leader>cf', function()
  vscode.action 'editor.action.formatDocument'
end, { silent = true, desc = 'Format file' })
--#endregion

--#region Harpoon
vim.keymap.set('n', '<leader>hh', function()
  vscode.action 'vscode-harpoon.editEditors'
end, { desc = 'Toggle harpoon quick menu' })
vim.keymap.set('n', '<leader>ha', function()
  vscode.action 'vscode-harpoon.addEditor'
end, { desc = 'Add to harpoon list' })
vim.keymap.set('n', '<leader>hp', function()
  vscode.action 'vscode-harpoon.gotoPreviousHarpoonEditor'
end, { desc = 'Open previous harpoon item' })
vim.keymap.set('n', '<leader>hq', function()
  vscode.action 'vscode-harpoon.gotoEditor1'
end, { desc = 'Open first harpoon item' })
vim.keymap.set('n', '<leader>hw', function()
  vscode.action 'vscode-harpoon.gotoEditor2'
end, { desc = 'Open second harpoon item' })
vim.keymap.set('n', '<leader>he', function()
  vscode.action 'vscode-harpoon.gotoEditor3'
end, { desc = 'Open third harpoon item' })
vim.keymap.set('n', '<leader>hr', function()
  vscode.action 'vscode-harpoon.gotoEditor4'
end, { desc = 'Open fourth harpoon item' })

--#endregion
