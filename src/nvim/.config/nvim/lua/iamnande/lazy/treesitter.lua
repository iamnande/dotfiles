return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            local config = require('nvim-treesitter.configs')

            config.setup({
                ensure_installed = {
                    "bash",
                    "c", 
                    "javascript",
                    "jsdoc",
                    "lua", 
                    "go", 
                    "markdown", 
                    "markdown_inline", 
                    "rust",
                    "typescript",
                    "vim", 
                    "vimdoc",
                },

                sync_install = false,
                auto_install = true,

                highlight = {
                    enable = true,
                },
            })
        end
    },
}
