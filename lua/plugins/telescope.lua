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
      local telescope = require("telescope")

      telescope.load_extension('media_files')
      telescope.load_extension('fzf')

      telescope.setup(
        {
          pickers = {
            find_files = {
              find_command = {
                "rg",
                "--files",
                "--hidden",             -- include hidden files
                "--no-ignore-vcs",      -- don't respect .gitignore
                "--glob", "!**/.git/*", -- Exclude .git/
                -- Exclude config files and cache
                "--glob", "!.DS_Store",
                "--glob", "!*cache*",
                "--glob", "!.venv",
                "--glob", "!.uv",
                -- Exclude filetypes that can not be viewed in previewer
                "--glob", "!*.mp3",
                "--glob", "!*.mp4",
                "--glob", "!*.png",
                "--glob", "!*.jpg",
                "--glob", "!*.jpeg",
                "--glob", "!*.pdf",
                "--glob", "!*.pptx",
                "--glob", "!*.docx",
                "--glob", "!*.xlsx",
                "--glob", "!*.xlsm",
                "--glob", "!*.xls",
                "--glob", "!*.zip",
                "--glob", "!*.canvas"
              }
            },
            git_commits = {
              -- opts = {}
            }
          },
        }
      )
    end,

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
