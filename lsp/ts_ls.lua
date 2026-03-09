return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'jsx',
    'typescript',
    'typescriptreact',
    'tsx',
  },
  init_options = { hostInfo = 'neovim' },
}
