return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'debugloop/telescope-undo.nvim',
      {
        'tom-anders/telescope-vim-bookmarks.nvim',
        dependencies = {
          'MattesGroeger/vim-bookmarks'
        }
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      }
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<C-/>'] = false,
              ['<C-h>'] = 'which_key'
            },
            n = {
              ["<esc>"] = actions.close
            }
          },
        },
      }
      require('telescope').load_extension 'file_browser'
      require('telescope').load_extension 'ui-select'
      require("telescope").load_extension "undo"
      require('telescope').load_extension 'vim_bookmarks'
    end,
  },
}
