-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24-bit colors
vim.opt.termguicolors = true

-- Set general indentation rules
vim.opt.tabstop = 4      -- A tab is 4 spaces
vim.opt.shiftwidth = 4   -- Indentation width
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.softtabstop = 4  -- Insert 4 spaces for a Tab

-- Set relative line numbers
vim.opt.relativenumber = true

-- Indentation for Lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
    vim.bo.softtabstop = 2
  end,
})

-- folding defaults
vim.opt.foldlevel = 99
vim.opt.foldenable = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.wrap = true       -- setting wrap
vim.opt.sidescrolloff = 8 -- how many columns the cursor keeps from the side of the screen when sidescrolling
