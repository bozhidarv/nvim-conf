local add = MiniDeps.add

if vim.fn.executable 'make' == 1 then
  add {
    source = 'nvim-telescope/telescope-fzf-native.nvim',
    hooks = {
      post_checkout = function(params)
        local handle = io.popen('cd ' .. params.path .. '&& make')
        local result = handle:read '*a'
        handle:close()
        print(result)
      end,
    },
  }
end

add {
  source = 'nvim-telescope/telescope.nvim',
  depends = { 'nvim-lua/plenary.nvim' },
}

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

require('telescope').load_extension 'fzf'
