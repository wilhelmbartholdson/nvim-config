-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
require("config.keymaps")
require("config.options")

-- initialize lazy.nvim
require("config.lazy")

-- clipboard is in p (not "+ i.e +-registry)
vim.opt.clipboard = "unnamedplus"

-- initialize lsp
require("config.lsp")

-- nvim-treesitter
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'python',
    'javascript',
    'jsx',
    'typescript',
    'tsx',
    'lua',
    'html',
    'css',
    'markdown'
  },
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.opt.foldenable = false -- disable folding on startup
  end,
})
