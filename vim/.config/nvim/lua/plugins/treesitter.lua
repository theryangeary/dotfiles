return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local ts = require('nvim-treesitter')

        ts.setup({}) -- default install_dir: stdpath('data')/site

        local ensure_installed = {
            "lua", "python", "typescript", "java", "go", "rust",
            "json", "yaml", "toml", "markdown", "bash", "sql",
        }
        ts.install(ensure_installed)

        -- Replaces master's `auto_install = true`: install the parser for a
        -- filetype the first time it is opened, if one is available.
        local installed = {}
        for _, lang in ipairs(ts.get_installed()) do
            installed[lang] = true
        end
        local available = {}
        for _, lang in ipairs(ts.get_available()) do
            available[lang] = true
        end

        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang or not available[lang] then
                    return
                end

                if not installed[lang] then
                    installed[lang] = true -- guard against re-triggering
                    ts.install({ lang })
                end

                -- highlight (provided by Neovim, `:h treesitter-highlight`)
                pcall(vim.treesitter.start, args.buf, lang)

                -- indent (experimental, provided by nvim-treesitter)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                -- folds (provided by Neovim)
                vim.wo[0][0].foldmethod = 'expr'
                vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            end,
        })

        vim.opt.foldlevel = 99 -- start with everything unfolded
    end,
}
