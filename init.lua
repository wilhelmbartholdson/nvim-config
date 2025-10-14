-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
require("config.keymaps")
require("config.options")

-- initialize lazy.nvim
require("config.lazy")

-- initialize lsp
require("config.lsp")
