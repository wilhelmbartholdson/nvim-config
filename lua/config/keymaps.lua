-- setup leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- aliases
vim.api.nvim_create_user_command("Lz", function() vim.cmd("Lazy") end, { desc = "Opens Lazy GUI" }) -- Lazy GUI

-- tmux keymaps
vim.keymap.set({ 'n' }, "<C>h", "<cmd> TmuxNavigateLeft<CR>", { desc = "tmux window left" })
vim.keymap.set({ 'n' }, "<C>l", "<cmd> TmuxNavigateRight<CR>", { desc = "tmux window right" })
vim.keymap.set({ 'n' }, "<C>j", "<cmd> TmuxNavigateDown<CR>", { desc = "tmux window down" })
vim.keymap.set({ 'n' }, "<C>k", "<cmd> TmuxNavigateUp<CR>", { desc = "tmux window up" })
