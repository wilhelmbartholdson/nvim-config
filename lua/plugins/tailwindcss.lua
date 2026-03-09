-- return {
--   cmd = { 'pyright-langserver', '--stdio' },
--   filetypes = { 'python' },
--   root_markers = {
--     'pyproject.toml',
--     'setup.py',
--     'setup.cfg',
--     'requirements.txt',
--     'Pipfile',
--     'pyrightconfig.json',
--     '.git',
--   },
--   settings = {
--     python = {
--       analysis = {
--         autoSearchPaths = true,
--         useLibraryCodeForTypes = true,
--         diagnosticMode = 'openFilesOnly',
--       },
--     },
--   },
-- }
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  },
  opts = function(_, opts)
    opts.formatting = {
      format = require("tailwindcss-colorizer-cmp").formatter,
    }
  end,
}
