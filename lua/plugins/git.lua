MiniDeps.add {
  source = 'NeogitOrg/neogit',
  depends = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    'ibhagwan/fzf-lua', -- optional
  },
}

require('neogit').setup {}
require('custom.branch_name').register_autocmd()

MiniDeps.add {
  source = 'yt20chill/inline_git_blame.nvim',
}

require('inline_git_blame').setup {
  -- excluded_filetypes will be extended from default
  excluded_filetypes = { 'NvimTree', 'neo-tree', 'TelescopePrompt', 'help' },
  debounce_ms = 150,
  autocmd = true,
  you_label = 'You', -- can be any string, or false to disable replacement
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

---@type Terminal?
local git_term = nil
vim.api.nvim_create_user_command('LazyGitOpen', function(args)
  if git_term == nil then
    local cmd = 'lazygit'
    if args.args ~= 'all' then
      cmd = cmd .. ' ' .. args.args
    end
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new {
      cmd = cmd,
      hidden = true,
      mappings = {
        '<leader>gg',
      },
      on_exit = function()
        git_term = nil
      end,
    }
    git_term = lazygit
  end
  git_term:toggle()
end, { nargs = 1 })
