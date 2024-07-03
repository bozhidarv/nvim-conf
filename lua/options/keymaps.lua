--#region Keymaps for better default experience
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

--#region window splitting
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Verical split' })
--#endregion

--#region Telescope
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[ ] Search files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>fF', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>fu', ':Telescope undo<cr>', { desc = 'Open undo tree for this buffer' })
--#endregion

--#region Oil.nvim

if not package.loaded['oil'] then
  vim.keymap.set('n', '<leader>e', '<CMD>Explore<CR>', { desc = 'Open file explorer' })
else
  vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open file explorer' })
end
--#endregion

--#region Git
vim.keymap.set('n', '<leader>gf', require('neogit').open, { desc = 'Open neogit' })
vim.keymap.set('n', '<leader>gp', ':Neogit pull<CR>', { desc = 'Neogit pull' })
vim.keymap.set('n', '<leader>gP', ':Neogit push<CR>', { desc = 'Neogit push' })
--#endregion

--#region Trouble.nvim
local trouble = require 'trouble'

vim.keymap.set('n', '[d', function()
  ---@diagnostic disable-next-line: missing-fields
  trouble.prev { skip_groups = true, jump = true }
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  ---@diagnostic disable-next-line: missing-fields
  trouble.next { skip_groups = true, jump = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>qf', ':Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Toggle diagnostics list for file' })

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

--#region Tmux Navigator
vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>', { silent = true, desc = 'Navigate down' })
vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>', { silent = true, desc = 'Navigate up' })
vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { silent = true, desc = 'Navigate left' })
vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>', { silent = true, desc = 'Navigate right' })
--#endregion

--#region buffers
vim.keymap.set('n', '<leader>C', ':bd<CR>', { silent = true, desc = 'Close buffer' })
--#endregion

--#region tabs
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { silent = true, desc = 'Close tab' })
vim.keymap.set('n', '[T', ':tabprevious<CR>', { silent = true, desc = 'Previous tab' })
vim.keymap.set('n', ']T', ':tabNext<CR>', { silent = true, desc = 'Next tab' })
--#endregion

--#region hlSearch
vim.keymap.set('n', '<esc><esc>', ':nohls<cr>', { silent = true, desc = 'Turn off hlSearch' })
--#endregion

--#region Github Copilot
vim.keymap.set('i', '<Plug>(vimrc:copilot-dummy-map)', 'copilot#Accept("")', { silent = true, expr = true, desc = 'Copilot dummy accept' })
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
