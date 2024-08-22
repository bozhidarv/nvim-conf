return {
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup {
        lsp = {
          ['error'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultError' },
          ['warning'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultWarning' },
          ['info'] = { glyph = ' ', hl = 'LspDiagnosticsDefaultInformation' },
          ['hint'] = { glyph = '', hl = 'LspDiagnosticsDefaultHint' },
        },
      }
    end,
  },
  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      draw = {
        delay = 0,
        animation = function()
          return 0
        end,
      },
      options = { border = 'top', try_as_border = true },
      symbol = '▏',
    },
    config = function(_, opts)
      require('mini.indentscope').setup(opts)

      -- Disable for certain filetypes
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        desc = 'Disable indentscope for certain filetypes',
        callback = function()
          local ignored_filetypes = {
            'aerial',
            'dashboard',
            'help',
            'lazy',
            'leetcode.nvim',
            'mason',
            'neo-tree',
            'NvimTree',
            'neogitstatus',
            'notify',
            'startify',
            'toggleterm',
            'Trouble',
            'calltree',
            'coverage',
          }
          if vim.tbl_contains(ignored_filetypes, vim.bo.filetype) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end,
  },
  -- {
  --   'echasnovski/mini.statusline',
  --   version = '*',
  --   config = function()
  --     local statusline = require 'mini.statusline'
  --     -- set use_icons to true if you have a Nerd Font
  --     statusline.setup {
  --       use_icons = true,
  --     }
  --
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     statusline.section_location = function()
  --       return '%2l:%-2v'
  --     end
  --
  --     statusline.section_lsp = function()
  --       return ''
  --     end
  --
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --
  --     statusline.section_diagnostics = function(_)
  --       local count = {}
  --
  --       local severities = vim.diagnostic.severity
  --
  --       for level in pairs(vim.diagnostic.severity) do
  --         count[level] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  --       end
  --
  --       if count[severities.ERROR] == 0 and count[severities.WARN] == 0 and count[severities.HINT] == 0 and count[severities.INFO] == 0 then
  --         return ''
  --       end
  --
  --       local errors = ''
  --       local warnings = ''
  --       local hints = ''
  --       local info = ''
  --
  --       if count[severities.ERROR] ~= 0 then
  --         local icon, _ = MiniIcons.get('lsp', 'error')
  --         errors = icon .. ' ' .. count[severities.E] .. ' '
  --       end
  --       if count[severities.WARN] ~= 0 then
  --         local icon, _ = MiniIcons.get('lsp', 'warning')
  --         warnings = icon .. ' ' .. count[severities.WARN] .. ' '
  --       end
  --       if count[severities.HINT] ~= 0 then
  --         local icon, _ = MiniIcons.get('lsp', 'hint')
  --         hints = icon .. ' ' .. count[severities.HINT] .. ' '
  --       end
  --       if count[severities.HINT] ~= 0 then
  --         local icon, _ = MiniIcons.get('lsp', 'info')
  --         info = icon .. ' ' .. count[severities.HINT] .. ' '
  --       end
  --
  --       return '|' .. errors .. warnings .. hints .. info .. '|'
  --     end
  --   end,
  -- },
}
