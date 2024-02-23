local utils = require('options.utils')

return {
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		opts = {
			flavour = 'mocha', -- latte, frappe, macchiato, mocha
			background = {  -- :h background
				light = 'latte',
				dark = 'mocha',
			},
			transparent_background = utils.checkTransperancy(), -- disables setting the background color.
			show_end_of_buffer = false,                      -- shows the '~' characters after the end of buffers
			term_colors = true,                              -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false,                               -- dims the background color of inactive window
				shade = 'dark',
				percentage = 0.15,                             -- percentage of the shade to apply to the inactive window
			},
			no_italic = false,                               -- Force no italic
			no_bold = false,                                 -- Force no bold
			no_underline = false,                            -- Force no underline
			styles = {                                       -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { 'italic' },                       -- Change the style of comments
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
				style = 'darker',                    -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
				transparent = utils.checkTransperancy(), -- Show/hide background
				term_colors = true,                  -- Change terminal color as per the selected theme style
				ending_tildes = false,               -- Show the end-of-buffer tildes. By default they are hidden
				cmp_itemkind_reverse = false,        -- reverse item kind highlights in cmp menu

				-- toggle theme style ---
				toggle_style_key = nil,                                                          -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
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
				colors = {}, -- Override default colors
				highlights = {}, -- Override highlight groups

				-- Plugins Config --
				diagnostics = {
					darker = true, -- darker colors for diagnostic
					undercurl = true, -- use undercurl instead of underline for diagnostics
					background = true, -- use background color for virtual text
				},
			}
		end,
	},
	{
		'edeneast/nightfox.nvim',
		priority = 1000,
		config = function()
			require('nightfox').setup({
				options = {
					-- Compiled file's destination location
					compile_path = vim.fn.stdpath("cache") .. "/nightfox",
					compile_file_suffix = "_compiled",  -- Compiled file suffix
					transparent = utils.checkTransperancy(), -- Disable setting background
					terminal_colors = true,             -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
					dim_inactive = false,               -- Non focused panes set to alternative background
					module_default = true,              -- Default enable value for modules
					colorblind = {
						enable = false,                   -- Enable colorblind support
						simulate_only = false,            -- Only show simulated colorblind colors and not diff shifted
						severity = {
							protan = 0,                     -- Severity [0,1] for protan (red)
							deutan = 0,                     -- Severity [0,1] for deutan (green)
							tritan = 0,                     -- Severity [0,1] for tritan (blue)
						},
					},
					styles = {     -- Style to be applied to different syntax groups
						comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
						conditionals = "NONE",
						constants = "NONE",
						functions = "NONE",
						keywords = "NONE",
						numbers = "NONE",
						operators = "NONE",
						strings = "NONE",
						types = "NONE",
						variables = "NONE",
					},
					inverse = { -- Inverse highlight for different types
						match_paren = false,
						visual = false,
						search = false,
					},
					modules = { -- List of various plugins and additional options
						-- ...
					},
				},
				palettes = {},
				specs = {},
				groups = {},
			})
		end
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				style = "night",                     -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
				light_style = "day",                 -- The theme is used when the background is set to light
				transparent = utils.checkTransperancy(), -- Enable this to disable setting the background color
				terminal_colors = true,              -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark",          -- style for sidebars, see below
					floats = "dark",            -- style for floating windows
				},
				sidebars = { "qf", "help" },  -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.3,         -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false,         -- dims inactive windows
				lualine_bold = false,         -- When `true`, section headers in the lualine theme will be bold

				--- You can override specific color groups to use other groups or a hex color
				--- function will be called with a ColorScheme table
				---@param colors ColorScheme
				on_colors = function(colors) end,

				--- You can override specific highlights to use other groups or a hex color
				--- function will be called with a Highlights and ColorScheme table
				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors) end,
			})
		end
	}
}
