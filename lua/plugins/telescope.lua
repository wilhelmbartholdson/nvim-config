return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>pf", ":Telescope find_files<cr>", desc = "Find files" },
      { "<leader>lg", ":Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>of", ":Telescope oldfiles<cr>", desc = "Old files" },

      { "<leader>gf", ":Telescope git_files<cr>", desc = "Git files" },
      { "<leader>gb", ":Telescope git_commits<cr>", desc = "Git commits" },
    },

    pickers = {
      find_files = {
        opts = {
          hidden = true,  -- show hidden files
          no_ignore = true  -- show files hidden by .gitignore
        }
      },
      git_commits = {
        opts = {  }
      }
    }
  },
}
