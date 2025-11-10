return {
	{
		-- LSP base & workspace support
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/lazydev.nvim", ft = "lua", opts = {} },
		},
		config = function()
			-- common on_attach for LSP servers
			local on_attach = function(client, bufnr)
				-- disable built‑in formatting if using external formatter
				if client.server_capabilities.documentFormattingProvider then
					client.server_capabilities.documentFormattingProvider = false
				end

				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
				nmap("<leader>ssd", require("telescope.builtin").lsp_document_symbols, "[S]ymbols [S]how in [D]ocument")
				nmap(
					"<leader>ssw",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					"[S]ymbols [S]how in [W]orkspace"
				)
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("<C‑k>", vim.lsp.buf.signature_help, "Signature Documentation")
				nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
				nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
				nmap("<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "[W]orkspace [L]ist Folders")

				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					require("conform").format({ async = false, timeout_ms = 50000, lsp_fallback = true })
					vim.lsp.buf.format({ async = false })
				end, { desc = "Format current buffer with LSP" })
			end

			-- capabilities for nvim‑cmp + LSP
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- define servers & per‑server settings
			local servers = {
				gopls = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				ts_ls = {
					filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
					cmd = { "typescript-language-server", "--stdio" },
				},
				solargraph = { timeout_ms = 2000 },
				zls = {},
			}

			-- register each server
			for name, opts in pairs(servers) do
				vim.lsp.config(name, {
					on_attach = on_attach,
					capabilities = capabilities,
					settings = opts.settings,
					filetypes = opts.filetypes,
					cmd = opts.cmd,
				})
			end

			-- enable all servers
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},

	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C‑n>"] = cmp.mapping.select_next_item(),
					["<C‑p>"] = cmp.mapping.select_prev_item(),
					["<C‑d>"] = cmp.mapping.scroll_docs(-4),
					["<C‑f>"] = cmp.mapping.scroll_docs(4),
					["<C‑Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S‑Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			})
		end,
	},
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})

			-- Toggle Aerial globally
			vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
		end,
	},
}
