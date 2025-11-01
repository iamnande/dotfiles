return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = {
                file_ignore_patterns = { "%.git/" }, -- ignore .git dirs
            },
            pickers = {
                find_files = {
                    hidden = true,  -- include dotfiles
                },
                live_grep = {
                    additional_args = function(_)
                        return { "--hidden" } -- include dotfiles in grep
                    end,
                },
            },
        })

        -- keymaps
        vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("search > ") })
        end)
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end,
}
