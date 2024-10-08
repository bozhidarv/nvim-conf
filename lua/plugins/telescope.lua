return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
		config = function()
			require('telescope').setup {
				defaults = {
					mappings = {
						i = {
							-- ['<esc>'] = require('telescope.actions').close,
						},
					},
					path_display = { 'truncate' },
					sorting_strategy = 'ascending',
					layout_config = {
						horizontal = {
							prompt_position = 'top',
						},
						vertical = {
							prompt_position = 'top',
							mirror = false,
						},
						preview_cutoff = 120,
					},
				},
				pickers = {
					lsp_document_symbols = {
						width = 0.25,
					},
				},
				extensions = {},
			}
			pcall(require('telescope').load_extension, 'fzf')
		end,
	},
}
