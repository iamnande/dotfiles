return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {
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
                        default = '',
                        symlink = '',
                        bookmark = '◉',
                        git = {
                            unstaged = '',
                            staged = '',
                            unmerged = '',
                            renamed = '',
                            deleted = '',
                            untracked = '',
                            ignored = '',
                        },
                        folder = {
                            default = '',
                            open = '',
                            symlink = '',
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
        }

        -- open nvim-tree on startup, without a need for <ENTER>
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                require("nvim-tree.api").tree.open()
            end,
        })
    end,
}
