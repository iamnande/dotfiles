require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        -- system
        "awk",
        "bash",
        "c",
        "lua",
        "luadoc",
        "editorconfig",
        "make",
        "markdown",
        "mermaid",
        "perl",
        "properties",
        "ssh_config",
        "toml",
        "vim",
        "vimdoc",

        -- deployment
        "arduino",
        "dockerfile",
        "hcl",
        "helm",
        "jq",
        "json",
        "starlark",
        "sql",
        "terraform",
        "yaml",

        -- sadness
        "groovy",
        "java",
        "kotlin",
        "python",
        "scala",

        -- git
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",

        -- training
        "rust",
        "zig",

        -- golang
        "go",
        "goctl",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",

        -- tech bro
        "javascript",
        "typescript",
        "vue",
    },

    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

local vim = vim
local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- clipboard
opt.clipboard = "unnamedplus"
