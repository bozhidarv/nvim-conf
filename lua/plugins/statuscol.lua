return {
  'luukvbaal/statuscol.nvim',
  config = function()
    local builtin = require 'statuscol.builtin'
    require('statuscol').setup {
      relculright = false,
      segments = {
        { sign = { name = { 'signs*' }, maxwidth = 1, auto = true }, click = 'v:lua.ScSa' },
        { sign = { name = { 'Dap' }, maxwidth = 1, auto = true }, click = 'v:lua.ScSa' },
        {
          sign = { namespace = { 'gitsigns*' }, maxwidth = 1, colwidth = 1, auto = true },
          click = 'v:lua.ScSa',
        },
        {
          sign = { namespace = { 'diagnostic/signs' }, maxwidth = 1, auto = true },
          click = 'v:lua.ScSa',
        },
        { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
        { text = { builtin.lnumfunc, '  ' }, click = 'v:lua.ScLa' },
      },
    }
  end,
}
