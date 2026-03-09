return {
  "windwp/nvim-ts-autotag",
  enabled = true,
  opts = {
    -- looks weird but this double-option is to silence the warning about nvim-treesitter legacy things
    opts = {
      enable_close = true,          -- Auto close tags
      enable_rename = true,         -- Auto rename pairs of tags
      enable_close_on_slash = false -- Auto close on trailing </
    },
    per_filetupe = {
      ["html"] = {
        enable_close = false
      }
    }
  },
}
