local add = MiniDeps.add

add {
  source = 'kevinhwang91/nvim-ufo',
  depends = {
    'kevinhwang91/promise-async'
  }
}

require('ufo').setup { preview = {
			mappings = {
				scrollB = '<C-b>',
				scrollF = '<C-f>',
				scrollU = '<C-u>',
				scrollD = '<C-d>',
			},
		},
		provider_selector = function(_, filetype, buftype)
			local function handleFallbackException(bufnr, err, providerName)
				if type(err) == 'string' and err:match 'UfoFallbackException' then
					return require('ufo').getFolds(bufnr, providerName)
				else
					return require('promise').reject(err)
				end
			end

			vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

			return (filetype == '' or buftype == 'nofile') and 'indent' -- only use indent until a file is opened
					or function(bufnr)
						return require('ufo')
								.getFolds(bufnr, 'lsp')
								:catch(function(err)
									return handleFallbackException(bufnr, err, 'treesitter')
								end)
								:catch(function(err)
									return handleFallbackException(bufnr, err, 'indent')
								end)
					end
		end,
}
