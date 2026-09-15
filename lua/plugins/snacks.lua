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

            -- Let Snacks render LaTeX while render-markdown handles other Markdown elements.
            math = { enabled = true },
            -- ObsidianPasteImg writes attachments under the active vault root. Teach
      -- Snacks to resolve those vault-relative links from that root as well.
            resolve = function (_, src)
                if not vim.startswith(src, "assets/imgs/") then
                    return nil
                end

                local ok, client = pcall(function ()
                    return require("obsidian").get_client()
                end)
                if not ok then
                    return nil
                end

                local path = client:vault_root() / src
                return path:is_file() and tostring(path) or nil
            end,
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
                "icns"
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
                max_height = 40
                -- Set to `true`, to conceal the image text when rendering inline.
        -- (experimental)
        ---@param lang string tree-sitter language
        ---@param type snacks.image.Type image type
        -- conceal = function(lang, type)
        --   -- only conceal math expressions
        --   return type == "math"
        -- end,
            }
        },

        notifier = { enabled = true },

        lazygit = { enabled = true },

        gitbrowse = {
            enabled = true,
            ---@class snacks.gitbrowse.Config
            ---@field url_patterns? table<string, table<string, string | fun(fields: snacks.gitbrowse.Fields): string>>
            notify = true,    -- show notification on open
            -- Handler to open the url in a browser
      ---@param url string
            open = function (url)
                if vim.fn.has("nvim-0.10") == 0 then
                    require("lazy.util").open(url, { system = true })
                    return
                end
                vim.ui.open(url)
            end,
            ---@type "repo" | "branch" | "file" | "commit" | "permalink"
            what = "commit",  -- what to open. not all remotes support all types
            commit = nil,     ---@type string?
            branch = nil,     ---@type string?
            line_start = nil, ---@type number?
            line_end = nil,   ---@type number?
            -- patterns to transform remotes to an actual URL
            remote_patterns = {
                { "^(https?://.*)%.git$", "%1" },
                { "^git@(.+):(.+)%.git$", "https://%1/%2" },
                { "^git@(.+):(.+)$", "https://%1/%2" },
                { "^git@(.+)/(.+)$", "https://%1/%2" },
                { "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
                { "^ssh://git@(.*)$", "https://%1" },
                { "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
                { "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
                { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
                { "^https://%w*@(.*)", "https://%1" },
                { "^git@(.*)", "https://%1" },
                { ":%d+", "" },
                { "%.git$", "" }
            },
            url_patterns = {
                ["github%.com"] = {
                    branch = "/tree/{branch}",
                    file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
                    permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
                    commit = "/commit/{commit}"
                },
                ["gitlab%.com"] = {
                    branch = "/-/tree/{branch}",
                    file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
                    permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
                    commit = "/-/commit/{commit}"
                },
                ["bitbucket%.org"] = {
                    branch = "/src/{branch}",
                    file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
                    permalink = "/src/{commit}/{file}#lines-{line_start}-L{line_end}",
                    commit = "/commits/{commit}"
                },
                ["git.sr.ht"] = {
                    branch = "/tree/{branch}",
                    file = "/tree/{branch}/item/{file}",
                    permalink = "/tree/{commit}/item/{file}#L{line_start}",
                    commit = "/commit/{commit}"
                }
            }
        },

        scroll = { enabled = true },

        -- Dashboard
    -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ---@class snacks.dashboard.Config
    ---@field enabled? boolean
    ---@field sections snacks.dashboard.Section
    ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
        dashboard = {
            width = 60,
            row = nil,                                                                   -- dashboard position. nil for center
            col = nil,                                                                   -- dashboard position. nil for center
            pane_gap = 4,                                                                -- empty columns between vertical panes
            autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
            -- These settings are used by some built-in sections
            preset = {
                -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
                pick = nil,
                -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        ---@type snacks.dashboard.Item[]
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    {
                        icon = " ",
                        key = "r",
                        desc = "Recent Files",
                        action = ":lua Snacks.dashboard.pick('oldfiles')"
                    },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})"
                    },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" }
                },
                header = [[
 .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| | _____  _____ | || |  _________   | || |   _____      | || |     ______   | || |     ____     | || | ____    ____ | || |  _________   | |
| ||_   _||_   _|| || | |_   ___  |  | || |  |_   _|     | || |   .' ___  |  | || |   .'    `.   | || ||_   \  /   _|| || | |_   ___  |  | |
| |  | | /\ | |  | || |   | |_  \_|  | || |    | |       | || |  / .'   \_|  | || |  /  .--.  \  | || |  |   \/   |  | || |   | |_  \_|  | |
| |  | |/  \| |  | || |   |  _|  _   | || |    | |   _   | || |  | |         | || |  | |    | |  | || |  | |\  /| |  | || |   |  _|  _   | |
| |  |   /\   |  | || |  _| |___/ |  | || |   _| |__/ |  | || |  \ `.___.'\  | || |  \  `--'  /  | || | _| |_\/_| |_ | || |  _| |___/ |  | |
| |  |__/  \__|  | || | |_________|  | || |  |________|  | || |   `._____.'  | || |   `.____.'   | || ||_____||_____|| || | |_________|  | |
| |              | || |              | || |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
        ]]
            },
            -- item field formatters
            formats = {
                icon = function (item)
                    if item.file and item.icon == "file" or item.icon == "directory" then
                        return Snacks.dashboard.icon(item.file, item.icon)
                    end
                    return { item.icon, width = 2, hl = "icon" }
                end,
                footer = { "%s", align = "center" },
                header = { "%s", align = "center" },
                file = function (item, ctx)
                    local fname = vim.fn.fnamemodify(item.file, ":~")
                    fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                    if #fname > ctx.width then
                        local dir = vim.fn.fnamemodify(fname, ":h")
                        local file = vim.fn.fnamemodify(fname, ":t")
                        if dir and file then
                            file = file:sub(-(ctx.width - #dir - 2))
                            fname = dir .. "/…" .. file
                        end
                    end
                    local dir, file = fname:match("^(.*)/(.+)$")
                    return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
                end
            },

            sections = {
                { section = "header" },
                {
                    pane = 1,
                    {
                        section = "terminal",
                        cmd = 'figlet -f Bulbhead "$(date +%Y-%m-%d)"',
                        height = 7,
                        padding = 1
                    },
                    { section = "keys", gap = 1, padding = 1 },
                    { section = "startup" }
                }
            }
        }
    },
    keys = {
        { "<leader>lg", function () Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>ir", function () Snacks.image.hover() end, desc = "Preview image on hover" },
        { "<leader>go", function () Snacks.gitbrowse() end, desc = "Open github remote repo" }
    }
}
