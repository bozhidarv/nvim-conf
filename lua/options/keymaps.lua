--#region Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
--#endregion

--#region buffers
vim.keymap.set('n', '<leader>C', ':bd<CR>', { silent = true, desc = 'Close buffer' })
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

--#region window splitting
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Verical split' })
--#endregion

--#region fzf-lua
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').live_grep()
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fF', require('telescope.builtin').find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fb', function()
  require('telescope.builtin').buffers()
end, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').man_pages, { desc = 'Find Manpages' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = 'Search current Word' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = 'Find keymaps' })
vim.keymap.set('n', '<leader>fu', vim.cmd.UndotreeToggle, { desc = 'Open undo tree for current buffer' })
--#endregion

--#region Oil.nvim

if not package.loaded['oil'] then
  vim.keymap.set('n', '<leader>e', '<CMD>Explore<CR>', { desc = 'Open file explorer' })
else
  vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open file explorer' })
end
--#endregion

--#region Git
vim.keymap.set('n', '<leader>gg', '<CMD>LazyGitOpen<CR>', { desc = 'Open lazygit' })
vim.keymap.set('n', '<leader>gh', function()
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay' })
vim.keymap.set('n', '<leader>gp', ':Git pull<CR>', { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gP', ':Git push<CR>', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gd', ':Git diff %<CR>', { desc = 'Git diff current file' })
vim.keymap.set('n', '<leader>gD', ':Git diff<CR>', { desc = 'Git diff repo' })
vim.keymap.set('n', '<leader>gw', ':Git diff <C-R><C-W> <CR>', { desc = 'Git diff cword' })

--#endregion

--#region Trouble.nvim
local trouble = require 'trouble'

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>qf', ':Trouble diagnostics toggle filter.buf=0<CR>',
  { desc = 'Toggle diagnostics list for file' })

vim.keymap.set('n', '<leader>qw', function()
  trouble.toggle 'diagnostics'
end, { desc = 'Toggle diagnostics list for workspace' })
--#endregion

--#region Todo-comments.nvim
vim.keymap.set('n', '<leader>qt', ':TodoTrouble<CR>', { desc = 'Open todo comments in trouble', silent = true })

vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })
--#endregion

--#region ufo.nvim
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
--#endregion

--#region Multiplexer Navigation
-- if vim.fn.has 'win32' == 1 then
vim.keymap.set('n', '<C-j>', ':SmartCursorMoveDown<CR>', { silent = true, desc = 'Navigate down' })
vim.keymap.set('n', '<C-k>', ':SmartCursorMoveUp<CR>', { silent = true, desc = 'Navigate up' })
vim.keymap.set('n', '<C-h>', ':SmartCursorMoveLeft<CR>', { silent = true, desc = 'Navigate left' })
vim.keymap.set('n', '<C-l>', ':SmartCursorMoveRight<CR>', { silent = true, desc = 'Navigate right' })

vim.keymap.set('n', '<A-j>', ':SmartResizeDown<CR>', { silent = true, desc = 'Resize down' })
vim.keymap.set('n', '<A-k>', ':SmartResizeUp<CR>', { silent = true, desc = 'Resize up' })
vim.keymap.set('n', '<A-h>', ':SmartResizeLeft<CR>', { silent = true, desc = 'Resize left' })
vim.keymap.set('n', '<A-l>', ':SmartResizeRight<CR>', { silent = true, desc = 'Resize right' })
--#endregion

--#region tabs
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { silent = true, desc = 'Close tab' })
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { silent = true, desc = 'New tab' })
vim.keymap.set('n', '[T', ':tabprevious<CR>', { silent = true, desc = 'Previous tab' })
vim.keymap.set('n', ']T', ':tabNext<CR>', { silent = true, desc = 'Next tab' })
--#endregion

--#region hlSearch
vim.keymap.set('n', '<esc><esc>', ':nohls<cr>', { silent = true, desc = 'Turn off hlSearch' })
--#endregion

--#region Github Copilot
vim.keymap.set('i', '<Plug>(vimrc:copilot-dummy-map)', 'copilot#Accept("")',
  { silent = true, expr = true, desc = 'Copilot dummy accept' })
--#endregion

--#region harpoon
local harpoon = require 'harpoon'
vim.keymap.set('n', '<leader>hh', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Toggle harpoon quick menu' })
vim.keymap.set('n', '<leader>ha', function()
  harpoon:list():add()
end, { desc = 'Add to harpoon list' })
vim.keymap.set('n', '<leader>hp', function()
  harpoon:list():prev { ui_nav_wrap = true }
end, { desc = 'Open previous harpoon item' })
vim.keymap.set('n', '<leader>hn', function()
  harpoon:list():next { ui_nav_wrap = true }
end, { desc = 'Open next harpoon item' })
vim.keymap.set('n', '<leader>hq', function()
  harpoon:list():select(1)
end, { desc = 'Open first harpoon item' })
vim.keymap.set('n', '<leader>hw', function()
  harpoon:list():select(2)
end, { desc = 'Open second harpoon item' })
vim.keymap.set('n', '<leader>he', function()
  harpoon:list():select(3)
end, { desc = 'Open third harpoon item' })
vim.keymap.set('n', '<leader>hr', function()
  harpoon:list():select(4)
end, { desc = 'Open fourth harpoon item' })
vim.keymap.set('n', '<leader>hc', function()
  harpoon:list():clear()
end, { desc = 'Clear harpoon items' })

--#endregion

--#region Terminal
vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], { desc = 'Toggle filetree' })
--#endregion
