return {
	-- Git related plugins
	'tpope/vim-fugitive',
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
