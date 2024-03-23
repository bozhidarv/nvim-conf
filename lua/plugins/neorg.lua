return {
	"nvim-neorg/neorg",
	build = ":Neorg sync-parsers",
	event = "VeryLazy",
	lazy = true, -- specify lazy = false because some lazy.nvim distributions set lazy = true by default
	-- tag = "*",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("neorg").setup {
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.concealer"] = {}, -- Adds pretty icons to your documents
				["core.dirman"] = {  -- Manages Neorg workspaces
					config = {
						workspaces = {
							notes = "~/notes",
						},
					},
				},
			},
		}
	end,
}
