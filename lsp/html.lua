--Enable (broadcasting) snippet capability for completion
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- vim.lsp.config('html', {
--   capabilities = capabilities,
-- })

return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html", "templ" },
  root_markers = { "package.json", ".git" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    },
    provideFormatter = true
  },
  settings = {}
}
