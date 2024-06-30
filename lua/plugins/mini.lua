return {
  {
    'echasnovski/mini.statusline',
    enabled = false,
    version = '*',
    config = function()
      local signs = require('options.utils').lspSigns
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

        local severities = vim.diagnostic.severity

        for level in pairs(vim.diagnostic.severity) do
          count[level] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
        end

        if count[severities.ERROR] == 0 and count[severities.WARN] == 0 and count[severities.HINT] == 0 and count[severities.INFO] == 0 then
          return ''
        end

        local errors = ''
        local warnings = ''
        local hints = ''
        local info = ''

        if count[severities.ERROR] ~= 0 then
          errors = signs.Error .. ' ' .. count[severities.E] .. ' '
        end
        if count[severities.WARN] ~= 0 then
          warnings = signs.Warn .. ' ' .. count[severities.WARN] .. ' '
        end
        if count[severities.HINT] ~= 0 then
          hints = signs.Hint .. ' ' .. count[severities.HINT] .. ' '
        end
        if count[severities.HINT] ~= 0 then
          info = signs.Info .. ' ' .. count[severities.HINT] .. ' '
        end

        return '|' .. errors .. warnings .. hints .. info .. '|'
      end
    end,
  },
}
