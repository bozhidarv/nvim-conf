return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
			'nvim-telescope/telescope-ui-select.nvim',
			'debugloop/telescope-undo.nvim',
			'tom-anders/telescope-vim-bookmarks.nvim'
		},
		config = function()
			require('telescope').load_extension 'file_browser'
			require('telescope').load_extension 'ui-select'
			require("telescope").load_extension "undo"
			require('telescope').load_extension 'vim_bookmarks'
		end,
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},
	{
		'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = {
					"icon",
					"permissions",
					-- "size",
					-- "mtime",
				}
			})
		end
	},
	{
		'MattesGroeger/vim-bookmarks'
	},
	{
		'RRethy/vim-illuminate',
		config = function()
			require('illuminate').configure({})
		end,
	},
	{
		'github/copilot.vim'
	},
	'tpope/vim-dadbod',
	'kristijanhusak/vim-dadbod-ui',
	'kristijanhusak/vim-dadbod-completion',
}
