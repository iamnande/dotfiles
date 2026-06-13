-- constants
local vim = vim
local configure = vim.opt

-- disable swap & backup
configure.backup = false
configure.undofile = false
configure.swapfile = false

-- set the cursor
configure.guicursor = ""

-- show (relative) line numbers
configure.nu = true
configure.relativenumber = true

-- set line wrapping & indentation
configure.wrap = false
configure.tabstop = 4
configure.shiftwidth = 4
configure.softtabstop = 4
configure.expandtab = true
configure.smartindent = true
configure.scrolloff = 10
configure.signcolumn = "yes"
configure.colorcolumn = "80"

-- search
configure.hlsearch = false
configure.incsearch = true
