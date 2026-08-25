return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>pf", ":Telescope find_files<cr>",  desc = "Find files" },
      { "<leader>lg", ":Telescope live_grep<cr>",   desc = "Live grep" },
      { "<leader>of", ":Telescope oldfiles<cr>",    desc = "Old files" },

      { "<leader>gf", ":Telescope git_files<cr>",   desc = "Git files" },
      { "<leader>gb", ":Telescope git_commits<cr>", desc = "Git commits" },
    },
    config = function()
      require("telescope").load_extension('media_files')
      require("telescope").load_extension('fzf')
    end,

    pickers = {
      find_files = {
        opts = {
          hidden = true,   -- show hidden files
          no_ignore = true -- show files hidden by .gitignore
        }
      },
      git_commits = {
        opts = {}
      }
    },
  },
  -- media_files picker
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
      -- 'nvim-telescope/telescope-media-files.nvim',
    },
    opts = {
      extensions = {
        media_files = {
          -- filetypes whitelist
          -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
          filetypes = { "png", "webp", "jpg", "jpeg" },
          -- find command (defaults to `fd`)
          find_cmd = "rg"
        }
      },
    }
  },
  {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  }
}
