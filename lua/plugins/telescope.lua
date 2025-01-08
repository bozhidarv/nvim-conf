local add = MiniDeps.add

local function build_telescope_fzf(params)
  vim.notify('Building fzf', vim.log.levels.INFO)
  local obj = vim.system({ 'make' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building fzf done', vim.log.levels.INFO)
  else
    vim.notify('Building fzf failed', vim.log.levels.ERROR)
  end
end

if vim.fn.executable 'make' == 1 then
  add {
    source = 'nvim-telescope/telescope-fzf-native.nvim',
    hooks = {
      post_checkout = build_telescope_fzf,
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
    find_files = {
      theme = 'ivy',
    },
    lsp_document_symbols = {
      width = 0.25,
    },
  },
  extensions = {},
}

require('telescope').load_extension 'fzf'
