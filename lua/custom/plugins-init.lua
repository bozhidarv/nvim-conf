-- You can add your own plugins here or in other files in this directory!plu
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
	-- NOTE: First, some plugins that don't require any configuration

	require 'custom.plugins.git',
	require 'custom.plugins.ui',

	-- Detect tabstop and shiftwidth automatically
	{ 'christoomey/vim-tmux-navigator' },

	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
		config = function()
			require('lspconfig').lua_ls.setup {
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = 'LuaJIT',
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								'vim',
								'require',
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file('', true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			}
		end,
	},

	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
	},

	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim',          opts = {} },
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
				vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
			end,
		},
	},
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		opts = {
			flavour = 'mocha', -- latte, frappe, macchiato, mocha
			background = {     -- :h background
				light = 'latte',
				dark = 'mocha',
			},
			transparent_background = true, -- disables setting the background color.
			show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
			term_colors = true,            -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false,             -- dims the background color of inactive window
				shade = 'dark',
				percentage = 0.15,           -- percentage of the shade to apply to the inactive window
			},
			no_italic = false,             -- Force no italic
			no_bold = false,               -- Force no bold
			no_underline = false,          -- Force no underline
			styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { 'italic' },     -- Change the style of comments
				conditionals = { 'italic' },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = function(c)
				return {

					NvimTreeRootFolder = { fg = c.pink },
					NvimTreeIndentMarker = { fg = c.surface0 },

					-- For telescope.nvim
					TelescopeBorder = { fg = c.mantle, bg = c.mantle },
					TelescopePromptBorder = { fg = c.surface0, bg = c.surface0 },
					TelescopePromptNormal = { fg = c.text, bg = c.surface0 },
					TelescopePromptPrefix = { fg = c.flamingo, bg = c.surface0 },
					TelescopeNormal = { bg = c.mantle },
					TelescopePreviewTitle = { fg = c.base, bg = c.green },
					TelescopePromptTitle = { fg = c.base, bg = c.red },
					TelescopeResultsTitle = { fg = c.mantle, bg = c.mantle },
					TelescopeSelection = { fg = c.text, bg = c.surface0 },
					TelescopeResultsDiffAdd = { fg = c.green },
					TelescopeResultsDiffChange = { fg = c.yellow },
					TelescopeResultsDiffDelete = { fg = c.red },
				}
			end,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				telescope = true,
				notify = true,
				mini = false,
				neotree = true,
				mason = true,
				treesitter_context = true,
				which_key = true,
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		},
	},
	{
		-- Theme inspired by Atom
		'navarasu/onedark.nvim',
		priority = 1000,
		config = function()
			require('onedark').setup {
				style = 'dark',               -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
				transparent = false,          -- Show/hide background
				term_colors = true,           -- Change terminal color as per the selected theme style
				ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
				cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

				-- toggle theme style ---
				toggle_style_key = nil,                                                              -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
				toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

				-- Change code style ---
				-- Options are italic, bold, underline, none
				-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
				code_style = {
					comments = 'italic',
					keywords = 'none',
					functions = 'none',
					strings = 'none',
					variables = 'none',
				},

				-- Lualine options --
				lualine = {
					transparent = false, -- lualine center bar transparency
				},

				-- Custom Highlights --
				colors = {},     -- Override default colors
				highlights = {}, -- Override highlight groups

				-- Plugins Config --
				diagnostics = {
					darker = true,     -- darker colors for diagnostic
					undercurl = true,  -- use undercurl instead of underline for diagnostics
					background = true, -- use background color for virtual text
				},
			}
		end,
	},

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'catppuccin-mocha',
				globalstatus = true,
				-- component_separators = '|',
				-- section_separators = '',
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = '┊',
			show_trailing_blankline_indent = false,
		},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
		},
		config = function()
			require('telescope').load_extension 'file_browser'
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
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},
	{
		'jose-elias-alvarez/null-ls.nvim',
		dependencies = {
			{
				'jay-babu/mason-null-ls.nvim',
				cmd = { 'NullLsInstall', 'NullLsUninstall' },
				opts = { handlers = {} },
			},
		},
		opts = function()
			local nls = require 'null-ls'
			return {
				sources = {
					nls.builtins.formatting.beautysh.with {
						command = 'beautysh',
						args = {
							'--indent-size=2',
							'$FILENAME',
						},
					},
					nls.builtins.code_actions.gomodifytags,
				},
			}
		end,
	},

	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v2.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
		},
	},
	-- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
	--       These are some example plugins that I've included in the kickstart repository.
	--       Uncomment any of the lines below to enable them.
	require 'kickstart.plugins.autoformat',
	require 'kickstart.plugins.debug',

	-- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
	--    up-to-date with whatever is in the kickstart repo.
	--
	--    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
}, {})
