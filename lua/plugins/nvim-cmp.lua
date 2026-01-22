return {
  "hrsh7th/nvim-cmp",
  version = false,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "L3MON4D3/cmp-luasnip-choice", -- completes clauses (e.g if-else)
    "SergioRibera/cmp-dotenv", -- env-variables
  },

  opts = function()

    -- set ghosttext
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- loads vscode-style snippets from installed plugins (e.g friendly_snippets)
    require("luasnip.loaders.from_vscode").lazy_load({ paths="~/.config/nvim/all_snippets"})

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect"
      },

      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
          -- vim.snippet.expand(args.body)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- backwards in docs preview
        ["<C-f>"] = cmp.mapping.scroll_docs(4), -- forwards in docs preview
        ["<C-Space>"] = cmp.mapping.complete(), -- Show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- Close completion suggestions
        ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Select completion
      }),

      -- Ghosttext
      experimental = {
        ghost_text = true
      },

      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'dotenv' },

        }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline( ':' , {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
        })
      })
    --   sources = cmp.config.sources({
    --     { name = "nvim_lsp" }, -- auto-cmp from language server
    --     { name = "luasnip" }, -- snippets
    --     { name = "buffer" }, -- text within current buffer
    --     { name = "path" }, -- file system paths
    --   }),
    --
    -- })
  end,
}
