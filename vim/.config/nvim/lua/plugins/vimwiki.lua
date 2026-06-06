return {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      {
        syntax = "markdown",
        ext = "md",
      },
    }
  end,
}
