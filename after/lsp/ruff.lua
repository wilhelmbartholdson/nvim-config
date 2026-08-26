return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  settings = {},
  init_options = {
    settings = {
      -- Ruff language server settings go here
      showSyntaxErrors = true,
      organizeImports = true,
      lineLength = 80,
    }
  },
}
