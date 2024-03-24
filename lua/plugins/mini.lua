return {
  {
    'echasnovski/mini.statusline',
    version = '*',
    config = function()
      local signs = { Error = '', Warn = '', Hint = '', Info = '' }
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup {
        use_icons = true,
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_diagnostics = function(_)
        local count = {}
        local levels = {
          errors = 'Error',
          warnings = 'Warn',
          info = 'Info',
          hints = 'Hint',
        }

        for k, level in pairs(levels) do
          count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
        end

        local errors = ''
        local warnings = ''
        local hints = ''
        local info = ''

        if count['errors'] ~= 0 then
          errors = signs.Error .. ' ' .. count['errors'] .. ' '
        end
        if count['warnings'] ~= 0 then
          warnings = signs.Warn .. ' ' .. count['warnings'] .. ' '
        end
        if count['hints'] ~= 0 then
          hints = signs.Hint .. ' ' .. count['hints'] .. ' '
        end
        if count['info'] ~= 0 then
          info = signs.Info .. ' ' .. count['info'] .. ' '
        end

        return errors .. warnings .. hints .. info
      end
    end,
  },
}
