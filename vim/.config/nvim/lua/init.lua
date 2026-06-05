-- use nvim-tree instead
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrw= 1

-- Use system clipboard
--vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Scrolling and UI settings
--vim.opt.signcolumn = 'yes'
--vim.opt.wrap = false
--vim.opt.sidescrolloff = 8
--vim.opt.scrolloff = 8

--vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
--vim.opt.undofile = true


local plugins = {
    --{ 'fatih/vim-go' },
    --{ 'psf/black' },
    --{ 'folke/lsp-colors.nvim' },
    { 'bronson/vim-trailing-whitespace' },
    -- { 'junegunn/fzf' },
    -- { 'junegunn/fzf.vim' },
    { 'rust-lang/rust.vim' },
    -- { 'scrooloose/nerdcommenter' },
    --{ 'scrooloose/nerdtree' },
    -- { 'sickill/vim-pasta' },
    { 'tpope/vim-abolish' },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },
    { 'tpope/vim-surround' },
    { 'tpope/vim-unimpaired' },
    { 'vim-airline/vim-airline' },
    { 'vim-airline/vim-airline-themes' },
    { 'wellle/targets.vim' },
    { 'morhetz/gruvbox' },
    { 'shaunsingh/solarized.nvim' },
    { 'vimwiki/vimwiki' },

    {  "nvim-lua/plenary.nvim"  },       -- used by other plugins
    {  "nvim-tree/nvim-web-devicons"  }, -- used by other plugins

    -- Telescope command menu
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- TreeSitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- LSP stuff
    { 'mason-org/mason.nvim' },          -- installs LSP servers
    { 'neovim/nvim-lspconfig' },         -- configures LSPs
    { 'mason-org/mason-lspconfig.nvim' },-- links the two above

    -- Some LSPs don't support formatting, this fills the gaps
    { 'stevearc/conform.nvim' },

    -- Autocomplete engine (LSP, snippets etc)
    -- see keymap:
    -- https://cmp.saghen.dev/configuration/keymap.html#default
    {
        'saghen/blink.cmp',
        opts = {
            keymap = { preset = 'super-tab' },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
        opts_extend = { "sources.default" }
    },
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)

require("telescope").setup()    -- command menu

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "typescript",
    "python",
    "rust",
    "go",
    -- etc!
  },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true, },
})

-- some stuff so code folding uses treesitter instead of older methods
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "basedpyright",
    "eslint",
    "ruff",
    "rust_analyzer",
  },
})

require("conform").setup({
  default_format_opts = { lsp_format = "fallback" },
  formatters_by_ft = {
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    rust = { "rustfmt" },
    go = { "gofmt" },
  },
})

-- local tele_builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<leader>ff", tele_builtin.git_files, {})
-- vim.keymap.set("n", "<leader>fa", tele_builtin.find_files, {})
-- vim.keymap.set("n", "<leader>fr", tele_builtin.live_grep, {})
-- vim.keymap.set("n", "<leader>bl", tele_builtin.buffers, {})
-- vim.keymap.set("n", "<leader>fh", tele_builtin.help_tags, {})


