--#region Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
--#endregion

--#region ui
vim.keymap.set('n', '<leader>ut', ':ToggleBackground<CR>', { silent = true, desc = 'Toggle dark/light background' })
vim.keymap.set('n', '<leader>uw', function()
  vim.print(vim.o.wrap)
  if vim.o.wrap then
    vim.opt.wrap = false
  else
    vim.opt.wrap = true
  end
end, { silent = true, desc = 'Toggle word wrapping' })
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
vim.keymap.set('n', '<leader>-', ':split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>|', ':vsplit<CR>', { desc = 'Verical split' })
--#endregion

--#region telescope
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = 'Search files' })
-- vim.keymap.set('n', '<leader>/', function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   require('telescope.builtin').live_grep()
-- end, { desc = '[/] Fuzzily search in current buffer' })
-- vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Find Git Files' })
-- vim.keymap.set('n', '<leader>fF', require('telescope.builtin').find_files, { desc = 'Find Files' })
-- vim.keymap.set('n', '<leader>fb', function()
--   require('telescope.builtin').buffers()
-- end, { desc = 'Find Buffers' })
-- vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Find Help' })
-- vim.keymap.set('n', '<leader>fm', require('telescope.builtin').man_pages, { desc = 'Find Manpages' })
-- vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = 'Search current Word' })
-- vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Find by Grep' })
-- vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = 'Find keymaps' })
--#endregion

--#region fzf-lua
vim.keymap.set('n', '<leader>?', require('fzf-lua').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', function()
  require('fzf-lua').files { hidden = false }
end, { desc = 'Search files' })
vim.keymap.set('n', '<leader>fF', function()
  require('fzf-lua').files { hidden = true, no_ignore = true }
end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>ff', require('fzf-lua').git_files, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fb', require('fzf-lua').buffers, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>/', require('fzf-lua').grep_curbuf, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>fg', require('fzf-lua').grep_project, { desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>fw', require('fzf-lua').grep_cWORD, { desc = 'Search current Word' })
vim.keymap.set('v', '<leader>fw', require('fzf-lua').grep_visual, { desc = 'Search current selection' })
vim.keymap.set('n', '<leader>fh', require('fzf-lua').helptags, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fc', require('fzf-lua').colorschemes, { desc = 'Find colorschemes' })
vim.keymap.set('n', '<leader>fm', require('fzf-lua').manpages, { desc = 'Find Manpages' })
vim.keymap.set('n', '<leader>fk', require('fzf-lua').keymaps, { desc = 'Find keymaps' })
vim.keymap.set('n', '<leader>gs', require('fzf-lua').git_status, { desc = 'Show git status' })
--#endregion

--#region undotree
vim.keymap.set('n', '<leader>fu', vim.cmd.UndotreeToggle, { desc = 'Open undo tree for current buffer' })
--#endregion

--#region Oil.nvim
-- if not package.loaded['oil'] then
--   vim.keymap.set('n', '<leader>e', '<CMD>Explore<CR>', { desc = 'Open file explorer' })
-- else
--   vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open file explorer' })
-- end
--#endregion

--#region mini.files
vim.keymap.set('n', '<leader>e', function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
  MiniFiles.open(path)
  MiniFiles.reveal_cwd()
end, { desc = 'Open mini.files' })
--#endregion

--#region Git
vim.keymap.set('n', '<leader>gg', '<CMD>LazyGitOpen<CR>', { desc = 'Open lazygit' })
vim.keymap.set('n', '<leader>gf', '<CMD>Git<CR>', { desc = 'Open fugitive' })
vim.keymap.set('n', '<leader>gh', function()
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay' })
vim.keymap.set('n', '<leader>gp', ':Git pull<CR>', { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gP', ':Git push<CR>', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gd', ':Git diff %<CR>', { desc = 'Git diff current file' })
vim.keymap.set('n', '<leader>gD', ':Git diff<CR>', { desc = 'Git diff repo' })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Open git blame' })
vim.keymap.set('n', '<leader>gml', ':diffget //2<CR>', { desc = 'Git merge conflict select left' })
vim.keymap.set('n', '<leader>gmr', ':diffget //3<CR>', { desc = 'Git merge conflict select right' })
--#endregion

--#region diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>qf', vim.diagnostic.setloclist, { desc = 'Toggle diagnostics list for file' })
vim.keymap.set('n', '<leader>qw', vim.diagnostic.setqflist, { desc = 'Toggle diagnostics list for workspace' })
--#endregion

--#region Todo-comments.nvim
vim.keymap.set('n', '<leader>qt', ':TodoQuickFix<CR>', { desc = 'Open todo comments in qf', silent = true })

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
vim.keymap.set('n', '<leader>Tc', ':tabclose<CR>', { silent = true, desc = 'Close tab' })
vim.keymap.set('n', '<leader>Tn', ':tabnew<CR>', { silent = true, desc = 'New tab' })
vim.keymap.set('n', '[T', ':tabprevious<CR>', { silent = true, desc = 'Previous tab' })
vim.keymap.set('n', ']T', ':tabNext<CR>', { silent = true, desc = 'Next tab' })
--#endregion

--#region quickfix
vim.keymap.set('n', '[q', ':cprev<CR>', { silent = true, desc = 'Previous quickfix item' })
vim.keymap.set('n', ']q', ':cnext<CR>', { silent = true, desc = 'Next quickfix item' })
vim.keymap.set('n', '<leader>qq', ':copen<CR>', { silent = true, desc = 'open quickfix list' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { silent = true, desc = 'close quickfix list' })
--#endregion

--#region loclist
vim.keymap.set('n', '[l', ':lprev<CR>', { silent = true, desc = 'Previous loclist item' })
vim.keymap.set('n', ']l', ':lnext<CR>', { silent = true, desc = 'Next loclist item' })
vim.keymap.set('n', '<leader>ll', ':lopen<CR>', { silent = true, desc = 'open loclist list' })
vim.keymap.set('n', '<leader>lc', ':lclose<CR>', { silent = true, desc = 'close loclist list' })
--#endregion

--#region hlSearch
vim.keymap.set('n', '<esc><esc>', ':nohls<cr>', { silent = true, desc = 'Turn off hlSearch' })
--#endregion

--#region Github Copilot
vim.keymap.set('i', '<Plug>(vimrc:copilot-dummy-map)', 'copilot#Accept("")', { silent = true, expr = true, desc = 'Copilot dummy accept' })
vim.keymap.set('i', '<C-S-j>', '<Plug>(copilot-accept-word)', { silent = true, desc = 'Accept Copilot word' })
--#endregion

--#region neotest
vim.keymap.set('n', '<leader>tc', function()
  require('neotest').run.run()
end, { silent = true, desc = 'Run closest test' })
vim.keymap.set('n', '<leader>tf', function()
  require('neotest').run.run(vim.fn.expand '%')
end, { silent = true, desc = 'Run all tests in current file' })
vim.keymap.set('n', '<leader>td', function()
  ---@diagnostic disable-next-line: missing-fields
  require('neotest').run.run { strategy = 'dap' }
end, { silent = true, desc = 'Debug current test' })
vim.keymap.set('n', '<leader>tt', function()
  require('neotest').run.stop()
end, { silent = true, desc = 'Terminate test' })
vim.keymap.set('n', '<leader>ts', function()
  require('neotest').summary.toggle()
end, { silent = true, desc = 'Open summary' })
vim.keymap.set('n', '<leader>to', function()
  require('neotest').output.open()
end, { silent = true, desc = 'Open output panel' })
--#endregion
