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

--#region fzf-lua
vim.keymap.set('n', '<leader>?', require('fzf-lua').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('fzf-lua').files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('fzf-lua').lgrep_curbuf()
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>ff', require('fzf-lua').git_files, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fF', require('fzf-lua').files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fb', function()
  require('fzf-lua').buffers {
    actions = {
      ['ctrl-x'] = { fn = require('fzf-lua.actions').buf_del, reload = true },
      ['ctrl-w'] = { fn = require('options.utils').fzf_lua_save_buffer_action, reload = true },
    },
  }
end, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', require('fzf-lua').helptags, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fm', require('fzf-lua').manpages, { desc = 'Find Manpages' })
vim.keymap.set('n', '<leader>fw', require('fzf-lua').grep_visual, { desc = 'Search current Word' })
vim.keymap.set('n', '<leader>fg', require('fzf-lua').live_grep_native, { desc = 'Find by Grep' })
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
-- vim.keymap.set('n', '<leader>gf', require('neogit').open, { desc = 'Open neogit' })
vim.keymap.set('n', '<leader>gg', function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }
  lazygit:toggle()
end, { desc = 'Open neogit' })
-- vim.keymap.set('n', '<leader>gp', ':Neogit pull<CR>', { desc = 'Neogit pull' })
-- vim.keymap.set('n', '<leader>gP', ':Neogit push<CR>', { desc = 'Neogit push' })
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
  -- harpoon:list():select(4)
end, { desc = 'Open fourth harpoon item' })
vim.keymap.set('n', '<leader>hc', function()
  harpoon:list():clear()
end, { desc = 'Clear harpoon items' })

--#endregion

--#region Neotree
vim.keymap.set('n', '<leader>ft', ':Neotree filesystem toggle right<CR>', { desc = 'Toggle filetree' })
--#endregion

--#region Terminal
vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], { desc = 'Toggle filetree' })
--#endregion
