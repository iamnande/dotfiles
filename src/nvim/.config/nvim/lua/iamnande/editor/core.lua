return {
	{
		-- window: file navigation sidebar
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				update_cwd = true,
				hijack_cursor = true,
				git = { ignore = false },
				actions = { open_file = { resize_window = true } },
				view = {
					width = 30,
					side = "left",
					preserve_window_proportions = true,
				},
				renderer = {
					highlight_git = true,
					root_folder_modifier = ":t",
					icons = {
						glyphs = {
							default = "",
							symlink = "",
							bookmark = "◉",
							git = {
								unstaged = "",
								staged = "",
								unmerged = "",
								renamed = "",
								deleted = "",
								untracked = "",
								ignored = "",
							},
							folder = {
								default = "",
								open = "",
								symlink = "",
							},
						},
						show = {
							git = false,
							file = true,
							folder = true,
							folder_arrow = false,
						},
					},
					indent_markers = {
						enable = true,
					},
				},
			})

			-- open nvim-tree on startup, without a need for <ENTER>
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					require("nvim-tree.api").tree.open()
				end,
			})
		end,
	},
	{
		-- window: search
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },

		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git", "yarn.lock" },
				},
				pickers = {
					find_files = {
						hidden = true, -- include dotfiles
						no_ignore = true, -- respect .gitignore
					},
				},
			})

			-- keymaps
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
			vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "[s]earch [g]it files" })
			vim.keymap.set("n", "<leader>sw", function()
				builtin.grep_string({ search = vim.fn.input("search > ") })
			end, { desc = "[s]earch by [w]ord" })
		end,
	},
	{
		-- window: search fuzzy finder algorithm
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		-- window: status line
		"nvim-lualine/lualine.nvim",
		opts = {
			icons_enabled = false,
			theme = "everforest",
			component_separators = "|",
			section_separators = "",
		},
	},
	{
		-- editor: highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencie = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"javascript",
					"go",
					"lua",
					"python",
					"ruby",
					"rust",
					"tsx",
					"typescript",
					"vimdoc",
					"vim",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true, disable = { "python" } },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>ps"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>pS"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
	{
		-- editor: language formatting
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 5000,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					c = { "clang-format" },
					cpp = { "clang-format" },
					lua = { "stylua" },
					go = { "gofmt" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					elixir = { "mix" },
				},
				formatters = {
					["clang-format"] = {
						prepend_args = { "-style=file", "-fallback-style=LLVM" },
					},
				},
			})

			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({ bufnr = 0 })
			end)
		end,
	},
	{
		-- editor: commenting
		"numToSTr/Comment.nvim",
		opts = {},
	},
	{
		-- utility: show pending keybinds
		"folke/which-key.nvim",
		opts = {},
	},
}
