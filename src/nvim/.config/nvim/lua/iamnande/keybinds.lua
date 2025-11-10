-- NOTE: prefer <leader> based operations over <C> when possible
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

-- find and explore
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- block movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- yank
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", 'gg"+yG')

-- navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- diagnostics
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
	desc = "See next message",
})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
	desc = "See previous message",
})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
	desc = "Open floating diagnostic message",
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
	desc = "Open diagnostics list",
})
