-- Completion configuration.
--
-- nvim-cmp displays completion items; a "source" supplies the items.  Most
-- sources need two entries below:
--   1. its plugin repository in `dependencies`, and
--   2. its documented source name in `sources` below.
--
-- Example: to add calculator completion, install `hrsh7th/cmp-calc` and add
-- `{ name = "calc" }` to the first `cmp.config.sources` list.  Then run
-- `:Lazy sync` and restart Neovim.  Check the source plugin's README for the
-- exact source name and any source-specific `setup()` call it requires.
return {
  {
    -- The completion menu and completion engine.
    "hrsh7th/nvim-cmp",
    -- Use the latest commit rather than only tagged releases.
    enabled = false,
    version = false,
    dependencies = {
      -- Language-server configuration.  Servers themselves are configured in
      -- lua/config/lsp.lua; this plugin does not add an nvim-cmp source alone.
      "neovim/nvim-lspconfig",
      -- Bridge from enabled language servers to the `nvim_lsp` source.
      "hrsh7th/cmp-nvim-lsp",
      -- Sources used below: words in open buffers, filesystem paths, and
      -- Ex-command names/arguments respectively.
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      -- Bridge that exposes LuaSnip snippets through the `luasnip` source.
      "saadparwaiz1/cmp_luasnip",
      -- The snippet engine that expands both your snippets and LSP snippets.
      "L3MON4D3/LuaSnip",
      -- Exposes environment-variable names through the `dotenv` source.
      "SergioRibera/cmp-dotenv",
      -- Provides Lua/Neovim API completion through the `lazydev` source.
      "folke/lazydev.nvim",
      -- Colours Tailwind class candidates in the completion menu.  This is a
      -- formatter, not a source, so it has no entry in `sources`.
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    config = function()
      -- Load nvim-cmp after lazy.nvim has installed and loaded dependencies.
      local cmp = require("cmp")

      -- Render the inline ghost suggestion using the Comment highlight group.
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      -- Load personal VS Code-format snippets from all_snippets/.  Add a
      -- snippet file to all_snippets/snippets/ and register it in that
      -- directory's package.json; restart Neovim to reload it.
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = vim.fn.stdpath("config") .. "/all_snippets",
      })

      cmp.setup({

        completion = {
          -- Show a menu and documentation; do not preselect an item.
          completeopt = "menu,menuone,preview,noselect",
        },

        snippet = {
          -- Required by nvim-cmp: tells it how to insert a snippet item after
          -- confirmation.  LuaSnip handles snippets from LSPs and this config.
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        window = {
          -- Use bordered floating windows for the menu and its documentation.
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          -- Add Tailwind colours to matching completion candidates.
          format = require("tailwindcss-colorizer-cmp").formatter,
        },

        mapping = cmp.mapping.preset.insert({
          -- Completion-menu navigation and documentation scrolling.
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- Open the menu, close it, or accept its current/first entry.
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),

        experimental = {
          -- Display the currently selected candidate inline as ghost text.
          ghost_text = true,
        },

        -- The first list contains primary sources.  To add a normal completion
        -- package, add its `{ name = "..." }` entry here after adding the
        -- matching plugin in `dependencies` above.  The source name is set by
        -- the plugin, not necessarily its GitHub repository name.
        sources = cmp.config.sources({
          -- Completion candidates returned by active LSP servers.
          { name = "nvim_lsp" },
          -- Extra Lua/Neovim API candidates, especially useful in config files.
          { name = "lazydev" },
          -- Snippets loaded by LuaSnip, including all_snippets/.
          { name = "luasnip" },
          -- Variables found by cmp-dotenv from .env files.
          { name = "dotenv" },
        }, {
          -- A lower-priority fallback: words already in open buffers.
          { name = "buffer" },
        }),
      })

      -- In search commands (`/` and `?`), complete only text from buffers.
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- In Ex commands (`:`), complete paths first, then command names and
      -- command arguments.  Symbol matching allows inputs such as `:!`.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}
