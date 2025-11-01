function SetColorScheme(colorscheme)
    vim.cmd.colorscheme(colorscheme)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
end

return {
    {
        "sainnhe/everforest", tag = "v0.3.0",

        config = function()
            vim.g.everforest_enable_italic = false
            vim.g.everforest_disable_underline = false
            vim.g.everforest_dim_inactive_windows = true
            SetColorScheme("everforest")
        end
    }
}
