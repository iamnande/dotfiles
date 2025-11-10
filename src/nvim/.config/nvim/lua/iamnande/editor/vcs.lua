return {
	-- git in a box
	{ "tpope/vim-fugitive" },

	-- show signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},

			-- TODO: should we use diff checks more often? why?
		},
	},
}
