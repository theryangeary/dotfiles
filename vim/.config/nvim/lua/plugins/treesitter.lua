return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "lua", "python", "typescript", "java", "go", "rust",
                "json", "yaml", "toml", "markdown", "bash", "sql",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
