return {
	-- Git related plugins
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua",    -- optional
		},
		config = true
	},
	'tpope/vim-rhubarb',
	{
		'NeogitOrg/neogit',
		dependencies = 'nvim-lua/plenary.nvim',
		config = function()
			require('neogit').setup {}
		end,
	},
	{
		'kdheepak/lazygit.nvim',
		-- optional for floating window border decoration
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
}
