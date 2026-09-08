return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      svelte = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      markdown_inline = { "prettier" },
      r = { "styler" },
    },
    formatters = {
      styler = {
        -- Prevent a project .Rprofile (for example, renv) from hiding the
        -- globally installed styler package when Conform invokes R.
        prepend_args = { "--no-init-file" },
      },
    },
    format_on_save = function()
      return { timeout_ms = 1000, lsp_fallback = true }
    end,
  },
}
