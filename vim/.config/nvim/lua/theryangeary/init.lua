require("theryangeary.remap")
print("Hello")

vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

vim.lsp.inlay_hint.enable(true)
