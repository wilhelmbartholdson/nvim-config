return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      less = { "prettier" },
      lua = { "luafmt" },
      markdown = { "prettier" },
      markdown_inline = { "prettier" },
      r = { "styler" },
      python = { "ruff" },
      svelte = { "prettier" },
      scss = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      yaml = { "prettier" },
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
