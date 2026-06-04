return {
    "vimwiki/vimwiki",
    "neovim/nvim-lspconfig",

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "rust_analyzer", "gopls" },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    -- Completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "L3MON4D3/LuaSnip" },
}
