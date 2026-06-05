require("theryangeary.remap")
print("Hello")

vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

vim.lsp.inlay_hint.enable(true)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buf = args.buf
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = buf })
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover,       { buffer = buf })
  end,
})
