return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  enabled = true,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    terminal = { enabled = false },
    git = { enabled = true },

    image = {
      enabled = true,
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
        "icns",
      },
      doc = {
        -- enable image viewer for documents
        -- a treesitter parser must be available for the enabled languages.
        enabled = true,
        -- render the image inline in the buffer
        -- if your env doesn't support unicode placeholders, this will be disabled
        -- takes precedence over `opts.float` on supported terminals
        inline = true,
        -- render the image in a floating window
        -- only used if `opts.inline` is disabled
        float = false,
        max_width = 80,
        max_height = 40,
        -- Set to `true`, to conceal the image text when rendering inline.
        -- (experimental)
        ---@param lang string tree-sitter language
        ---@param type snacks.image.Type image type
        conceal = function(lang, type)
          -- only conceal math expressions
          return type == "math"
        end,
      },
    },
    notifier = { enabled = true },
    lazygit = { enabled = true },
    gitbrowse = {
      enabled = true,
      ---@class snacks.gitbrowse.Config
      ---@field url_patterns? table<string, table<string, string|fun(fields:snacks.gitbrowse.Fields):string>>
      notify = true, -- show notification on open
      -- Handler to open the url in a browser
      ---@param url string
      open = function(url)
        if vim.fn.has("nvim-0.10") == 0 then
          require("lazy.util").open(url, { system = true })
          return
        end
        vim.ui.open(url)
      end,
      ---@type "repo" | "branch" | "file" | "commit" | "permalink"
      what = "commit", -- what to open. not all remotes support all types
      commit = nil, ---@type string?
      branch = nil, ---@type string?
      line_start = nil, ---@type number?
      line_end = nil, ---@type number?
      -- patterns to transform remotes to an actual URL
      remote_patterns = {
        { "^(https?://.*)%.git$",               "%1" },
        { "^git@(.+):(.+)%.git$",               "https://%1/%2" },
        { "^git@(.+):(.+)$",                    "https://%1/%2" },
        { "^git@(.+)/(.+)$",                    "https://%1/%2" },
        { "^org%-%d+@(.+):(.+)%.git$",          "https://%1/%2" },
        { "^ssh://git@(.*)$",                   "https://%1" },
        { "^ssh://([^:/]+)(:%d+)/(.*)$",        "https://%1/%3" },
        { "^ssh://([^/]+)/(.*)$",               "https://%1/%2" },
        { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
        { "^https://%w*@(.*)",                  "https://%1" },
        { "^git@(.*)",                          "https://%1" },
        { ":%d+",                               "" },
        { "%.git$",                             "" },
      },
      url_patterns = {
        ["github%.com"] = {
          branch = "/tree/{branch}",
          file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
          permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
          commit = "/commit/{commit}",
        },
        ["gitlab%.com"] = {
          branch = "/-/tree/{branch}",
          file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
          permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
          commit = "/-/commit/{commit}",
        },
        ["bitbucket%.org"] = {
          branch = "/src/{branch}",
          file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
          permalink = "/src/{commit}/{file}#lines-{line_start}-L{line_end}",
          commit = "/commits/{commit}",
        },
        ["git.sr.ht"] = {
          branch = "/tree/{branch}",
          file = "/tree/{branch}/item/{file}",
          permalink = "/tree/{commit}/item/{file}#L{line_start}",
          commit = "/commit/{commit}",
        },
      },
    },

    scroll = { enabled = true },

    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
        { section = "startup" },
      },
    },
  },
  keys = {
    { "<leader>LG", function() Snacks.lazygit() end,     desc = "Lazygit" },
    { "<leader>ir", function() Snacks.image.hover() end, desc = "Preview image on hover" },
    ---@param opts? snacks.gitbrowse.Config
    { "<leader>go", function() Snacks.gitbrowse() end,   desc = "Open github remote repo" }
  }
}
