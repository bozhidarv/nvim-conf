local utils = require 'options.utils'

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      background = {     -- :h background
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = utils.checkTransperancy(), -- disables setting the background color.
      show_end_of_buffer = true,                          -- shows the '~' characters after the end of buffers
      term_colors = true,                                 -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false,                                  -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.15,                                -- percentage of the shade to apply to the inactive window
      },
      no_italic = false,                                  -- Force no italic
      no_bold = false,                                    -- Force no bold
      no_underline = false,                               -- Force no underline
      styles = {                                          -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { 'italic' },                          -- Change the style of comments
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
        telescope = true,
        notify = true,
        mini = true,
        mason = true,
        treesitter_context = true,
        which_key = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    },
  },
  {
    'AstroNvim/astrotheme',
    opts = {
      palette = 'astrodark',
      plugins = {
        ['dashboard-nvim'] = true,
        ['gitsigns.nvim'] = true,
      },
      style = {
        transparent = utils.checkTransperancy(),
        inactive = not (utils.checkTransperancy()),
      },
    },
  },
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    opts = {
      style = 'darker',             -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      -- transparent = utils.checkTransperancy(), -- Show/hide background
      transparent = false,          -- Show/hide background
      term_colors = true,           -- Change terminal color as per the selected theme style
      ending_tildes = true,         -- Show the end-of-buffer tildes. By default they are hidden
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
    },
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { 'rose-pine/neovim', name = 'rose-pine' },
}
