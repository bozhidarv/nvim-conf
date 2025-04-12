MiniDeps.add {
  source = 'tpope/vim-fugitive',
}

require('mini.diff').setup {
  -- Options for how hunks are visualized
  view = {
    style = 'sign',
    signs = { add = '┃', change = '┋', delete = '' },
    priority = 199,
  },
  source = nil,
  delay = {
    text_change = 200,
  },
  mappings = {
    apply = 'gh',
    reset = 'gH',
    textobject = 'gh',
    goto_prev = '[g',
    goto_next = ']g',
  },
  options = {
    algorithm = 'histogram',
    indent_heuristic = true,
    linematch = 60,
    wrap_goto = false,
  },
}

---@type Terminal
local git_term = nil
vim.api.nvim_create_user_command('LazyGitOpen', function()
  if git_term == nil then
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      mappings = {
        '<leader>gg',
      },
    }
    git_term = lazygit
  end
  git_term:toggle()
end, {})
