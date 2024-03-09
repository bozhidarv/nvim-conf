return {
	-- Git related plugins
	-- { 'tpope/vim-fugitive' },
	{ 'sindrets/diffview.nvim' },
	{ 'tpope/vim-rhubarb' },
	-- {
	-- 	'NeogitOrg/neogit',
	-- 	dependencies = 'nvim-lua/plenary.nvim',
	-- 	config = function()
	-- 		require('neogit').setup {}
	-- 	end,
	-- },
	{
		'kdheepak/lazygit.nvim',
		-- optional for floating window border decoration
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua",           -- optional
		},
		config = true
	},
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signcolumn = true,
			signs = {
				add = { text = "┃" },
				change = { text = '┋' },
				delete = { text = '' },
				topdelete = { text = '' },
				changedelete = { text = '┃' },
			},
			attach_to_untracked = true,
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			on_attach = function(_)
				-- vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
				-- vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
				-- vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
			end,
		},
	},
}
