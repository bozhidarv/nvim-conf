--#region Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
--#endregion

--#region Remap for dealing with word wrap
vim.keymap.set('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
vim.keymap.set('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })
--#endregion

--#region Remap for moving highlighted line in visual mode
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { silent = true })
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { silent = true })
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
vim.keymap.set('n', '<leader>fb', require('telescope').extensions.vim_bookmarks.all, { desc = '[S]earch [B]ookmarks' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>fu', ':Telescope undo<cr>', { desc = 'Open undo tree for this buffer' })
--#endregion

--#region Oil.nvim
vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open file explorer' })
--#endregion

--#region Git
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open lazygit' })

vim.keymap.set('n', '<leader>gf', ':Git<CR>', { desc = 'Open fugitive' })
vim.keymap.set('n', '<leader>gp', ':Git pull<CR>', { desc = 'fugitive pull' })
vim.keymap.set('n', '<leader>gP', ':Git push<CR>', { desc = 'fugitive push' })
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = 'fugitive push' })
--#endregion

--#region Trouble.nvim
vim.keymap.set('n', '[d', function() require('trouble').previous({ skip_groups = true, jump = true }) end,
  { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() require('trouble').next({ skip_groups = true, jump = true }) end,
  { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>qf', function()
  require('trouble').toggle('document_diagnostics')
end, { desc = 'Toggle diagnostics list for file' })

vim.keymap.set('n', '<leader>qw', function()
  require('trouble').toggle('workspace_diagnostics')
end, { desc = 'Toggle diagnostics list for workspace' })
--#endregion

--#region Todo-comments.nvim
vim.keymap.set('n', '<leader>qt', ':TodoTrouble<CR>', { desc = 'Open todo comments in trouble', silent = true})

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
vim.keymap.set('n', 'L', ':BufferLineCycleNext<CR>', { silent = true, desc = 'Next buffer' })
vim.keymap.set('n', 'H', ':BufferLineCyclePrev<CR>', { silent = true, desc = 'Previous buffer' })
--#endregion

--#region tabs
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { silent = true, desc = 'Close tab' })
vim.keymap.set('n', '<leader>th', ':tabprevious<CR>', { silent = true, desc = 'Previous tab' })
vim.keymap.set('n', '<leader>tl', ':tabNext<CR>', { silent = true, desc = 'Next tab' })
--#endregion

--#region hlSearch
vim.keymap.set('n', '<esc><esc>', ':nohls<cr>', { silent = true, desc = 'Turn off hlSearch' })
--#endregion

--#region Github Copilot
vim.keymap.set('i',
  '<Plug>(vimrc:copilot-dummy-map)',
  'copilot#Accept("")',
  { silent = true, expr = true, desc = 'Copilot dummy accept' })
--#endregion
