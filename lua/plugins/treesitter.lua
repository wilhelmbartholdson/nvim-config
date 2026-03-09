return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  branch = 'main',

  -- opts = {
  --   -- LazyVim config for treesitter
  --   indent = { enable = true }, ---@type lazyvim.TSFeat
  --   highlight = { enable = true }, ---@type lazyvim.TSFeat
  --   folds = { enable = true }, ---@type lazyvim.TSFeat
  --   ensure_installed = {
  --     "bash",
  --     "c",
  --     "diff",
  --     "html",
  --     "javascript",
  --     "jsdoc",
  --     "json",
  --     "jsonc",
  --     "lua",
  --     "luadoc",
  --     "luap",
  --     "markdown",
  --     "markdown_inline",
  --     "printf",
  --     "python",
  --     "query",
  --     "regex",
  --     "toml",
  --     "tsx",
  --     "typescript",
  --     "vim",
  --     "vimdoc",
  --     "xml",
  --     "yaml",
  --   },
  -- }

  -- opts = {
  -- ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
  -- sync_install = false,
  -- highlight = { enable = true },
  -- indent = { enable = true },
  -- },

  config = function()
    require 'nvim-treesitter'.install {
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
      "tsx",
      "html",
      "markdown",
      "markdown_inline",
      "latex",
      "regex",
      "css"
    }



    -- require"nvim-treesitter".setup({
    --   ensure_installed = {
    --     "python",
    --     "c",
    -- "lua",
    -- "vim",
    --     "vimdoc",
    --     "query",
    --     "elixir",
    --     "heex",
    --     "javascript",
    --     "typescript",
    --     "html",
    --     "markdown",
    --     "markdown_inline",
    --     "latex",
    --     "regex"
    --   },
    --   sync_install = false,
    --   highlight = {
    --     enable = true, disable = {}
    --   },
    --   indent = { enable = true },
    --   }
    -- )
  end

}
