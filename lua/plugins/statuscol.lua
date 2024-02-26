return {
	"luukvbaal/statuscol.nvim",
	config = function()
		local builtin = require("statuscol.builtin")
		require("statuscol").setup({
			-- configuration goes here, for example:
			relculright = false,
			segments = {
				{ sign = { name = { 'Bookmark' }, maxwidth = 1, auto = true }, click = 'v:lua.ScSa' },
				{ sign = { name = { 'signs*' }, maxwidth = 1, auto = true },   click = 'v:lua.ScSa' },
				{ sign = { name = { 'Dap' }, maxwidth = 1, auto = true },      click = 'v:lua.ScSa' },
				{
					sign = { namespace = { 'gitsigns*' }, maxwidth = 1, colwidth = 1, auto = false },
					click = 'v:lua.ScSa',
				},
				{ sign = { name = { 'Diagnostic' }, maxwidth = 1, auto = true }, click = 'v:lua.ScSa' },

				{ text = { builtin.foldfunc, ' ' },                              click = 'v:lua.ScFa' },
				{ text = { builtin.lnumfunc, '  ' },                             click = 'v:lua.ScLa' },
			}
		})
	end,
}
