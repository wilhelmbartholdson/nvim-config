return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  config = function()
    require("render-markdown").setup({
      ft = { 'markdown' },
      render_modes = { 'n', 'c', 't' },
      completions = { lsp = { enabled = true } },
      latex = {
        enabled = true,
        converter = "latex2text",
        position = "above"
      },
      links = {
        enabled = true
      },
    })
  end
}
