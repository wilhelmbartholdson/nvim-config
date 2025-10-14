return {
  "nvim-treesitter/nvim-treesitter",
  build = {":TSUpdate"},
  branch = 'master',
  opts = {
    -- ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
    -- sync_install = false,
    -- highlight = { enable = true },
    -- indent = { enable = true },
  },
  config = function ()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
          "python",
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "elixir",
          "heex",
          "javascript",
          "typescript",
          "html",
          "markdown",
          "markdown_inline",
          "latex",
          "regex"
        },
      sync_install = false,
      highlight = { enable = true, disable = {} },
      indent = { enable = true },
      }
    )
  end
}
