return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'debugloop/telescope-undo.nvim',
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
              ['<esc>'] = require('telescope.actions').close,
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
          buffers = {
            theme = 'ivy',
          },
          find_files = {
            theme = 'ivy',
            hidden = true,
          },
          git_files = {
            theme = 'ivy',
          },
          live_grep = {
            theme = 'ivy',
          },
          oldfiles = {
            theme = 'ivy',
          },
          tags = {
            theme = 'ivy',
          },
          treesitter = {
            theme = 'ivy',
          },
          lsp_document_symbols = {
            previewer = false,
            width = 0.25,
          },
        },
        extensions = {},
      }
      require('telescope').load_extension 'undo'
      pcall(require('telescope').load_extension, 'fzf')
    end,
  },
}
