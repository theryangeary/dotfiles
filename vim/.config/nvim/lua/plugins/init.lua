return {
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "vimwiki/vimwiki",
    "neovim/nvim-lspconfig",

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "ansible-language-server" },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
            vim.lsp.enable("gopls")
        end,
    },

    -- Completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "L3MON4D3/LuaSnip" },

    -- Airline
    {
        "vim-airline/vim-airline",
        lazy = false,
        priority = 1000,
        dependencies = {
            {"vim-airline/vim-airline-themes"},
            {"ryanoasis/vim-devicons"}, 
        }
    }
}
