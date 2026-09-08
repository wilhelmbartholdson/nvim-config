return {
  {
    "R-nvim/R.nvim",
    -- Only required if you also set defaults.lazy = true
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "quarto-dev/quarto-nvim"
    },
    -- R.nvim is still young and we may make some breaking changes from time
    -- to time (but also bug fixes all the time). If configuration stability
    -- is a high priority for you, pin to the latest minor version, but unpin
    -- it and try the latest version before reporting an issue:
    -- version = "~0.1.0"

    ---@type RConfigUserOpts
    opts = {
      hook = {
        on_filetype = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
          vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
        end
      },
      R_args = { "--quiet", "--no-save" },
      min_editor_width = 72,
      rconsole_width = 78,
      objbr_mappings = { -- Object browser keymap
        c = 'class',     -- Call R functions
        -- Use {object} notation to write arbitrary R code.
        ['<localleader>gg'] = 'head({object}, n = 15)',
        v = function()
          -- Run lua functions
          require('r.browser').toggle_view()
        end
      },
      disable_cmds = {
        "RClearConsole",
        "RCustomStart",
        "RSPlot",
        "RSaveClose",
      },
    }
  },

}
