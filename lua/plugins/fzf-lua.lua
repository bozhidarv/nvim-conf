MiniDeps.add {
  source = 'ibhagwan/fzf-lua',
  depends = {
    'echasnovski/mini.icons',
  },
}

local actions = require 'fzf-lua.actions'

require('fzf-lua').setup {
  -- 'default-title',
  'ivy',
  defaults = {
    file_icons = 'mini',
    actions = {},
  },
  keymap = {
    builtin = {
      true,
      ['<C-d>'] = 'preview-page-down',
      ['<C-u>'] = 'preview-page-up',
    },
    fzf = {
      true,
      ['ctrl-d'] = 'preview-page-down',
      ['ctrl-u'] = 'preview-page-up',
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  fzf_opts = {
    -- options are sent as `<left>=<right>`
    -- set to `false` to remove a flag
    -- set to `true` for a no-value flag
    -- for raw args use `fzf_args` instead
    ['--ansi'] = true,
    ['--info'] = 'inline-right', -- fzf < v0.42 = "inline"
    ['--height'] = '100%',
    ['--layout'] = 'reverse',
    ['--border'] = 'none',
    ['--highlight-line'] = true, -- fzf >= v0.53
  },
  git = {
    status = {
      prompt = 'GitStatus❯ ',
      cmd = 'git -c color.status=false --no-optional-locks status --porcelain=v1 -u',
      multiprocess = true, -- run command in a separate process
      file_icons = true,
      git_icons = true,
      color_icons = true,
      previewer = 'git_diff',
      -- git-delta is automatically detected as pager, uncomment to disable
      preview_pager = false,
      actions = {
        -- actions inherit from 'actions.files' and merge
        ['right'] = false,
        ['left'] = false,
        ['ctrl-s'] = { fn = actions.git_stage_unstage, reload = true },
        ['ctrl-x'] = { fn = actions.git_reset, reload = true },
      },
    },
  },
  winopts = {
    row = 1,
    col = 0,
    width = 1,
    height = 0.4,
    title_pos = 'left',
    border = { '', '─', '', '', '', '', '', '' },
    preview = {
      layout = 'horizontal',
      title_pos = 'right',
      border = function(_, m)
        if m.type == 'fzf' then
          return 'single'
        else
          assert(m.type == 'nvim' and m.name == 'prev' and type(m.layout) == 'string')
          local b = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
          if m.layout == 'down' then
            b[1] = '├' --top right
            b[3] = '┤' -- top left
          elseif m.layout == 'up' then
            b[7] = '├' -- bottom left
            b[6] = '' -- remove bottom
            b[5] = '┤' -- bottom right
          elseif m.layout == 'left' then
            b[3] = '┬' -- top right
            b[5] = '┴' -- bottom right
            b[6] = '' -- remove bottom
          else -- right
            b[1] = '┬' -- top left
            b[7] = '┴' -- bottom left
            b[6] = '' -- remove bottom
          end

          return b
        end
      end,
    },
  },
}

require('fzf-lua').register_ui_select {
  winopts = {
    height = 0.3, -- window height
    width = 0.3, -- window width
    row = 0.47, -- window row position (0=top, 1=bottom)
    col = 0.47, -- window col position (0=left, 1=right)
    border = 'rounded',
    backdrop = 60,
    fullscreen = false, -- start fullscreen?
    preview = {
      hidden = true, -- start preview hidden
    },
  },
}
