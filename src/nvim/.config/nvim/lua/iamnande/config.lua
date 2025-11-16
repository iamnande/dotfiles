local vim = vim
local config = vim.opt
local global = vim.g

-- GLOBALS
global.loaded_netrw = 1
global.loaded_netrwPlugin = 1
global.markdown_folding = 1

-- base
config.guicursor = ""
config.nu = true
config.relativenumber = true
config.termguicolors = true

-- backup
config.backup = false
config.undofile = true
config.swapfile = false
config.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- folding
-- TODO: this feels a bit circular. verify.
config.foldmethod = "indent"
config.foldexpr = "nvim_treesitter#foldexpr()"

-- wrap & indent
config.wrap = false
config.tabstop = 4
config.shiftwidth = 4
config.softtabstop = 4
config.expandtab = true
config.smartindent = true

-- scroll
config.scrolloff = 10
config.signcolumn = "yes"
config.colorcolumn = "80"

-- search
config.hlsearch = false
config.incsearch = true
