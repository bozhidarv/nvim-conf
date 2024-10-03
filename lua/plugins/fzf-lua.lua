return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    -- calling `setup` is optional for customization

    local actions = require 'fzf-lua.actions'

    require('fzf-lua').setup {
      'telescope',
      defaults = {
        file_icons = 'mini',
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
          -- preview_pager = false,
          actions = {
            -- actions inherit from 'actions.files' and merge
            ['right'] = false,
            ['left'] = false,
            ['ctrl-s'] = { fn = actions.git_stage_unstage, reload = true },
            ['ctrl-x'] = { fn = actions.git_reset, reload = true },
          },
        },
      },
    }
    require('fzf-lua').register_ui_select {
      winopts = {
        relative = 'editor',
        row = 0.48,
        col = 0.48,
        height = 0.2,
        width = 0.2,
        win_border = true,
      },
    }
  end,
}
