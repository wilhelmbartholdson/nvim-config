--
-- YouTube-video used to set up ts
-- https://www.youtube.com/watch?v=NL8D8EkphUw
--

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    -- { "antonosha417/nvim-lsp-file-operations", config = true }, EXPERIMENTAL
  },
  config = function()
    --import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import cmp-nvim-lsp-plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- alias for readability

    local opts = { noremap = true, silent = true }

    --  controls what happens when an LSP is attached to a buffer
    local on_attach = function (client, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definition

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show diagnostics for file

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if neccesary
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change diagnostics symbols in the sign column (gutter)
    local signs = { Error = "✘ ", Warn  = "⚠ ", Hint  = "➤ ", Info  = "ℹ" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = ""})
    end

    -- Configure all the languages
    -- PYTHON
          -- Python
    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
        }
      },
      root_dir = lspconfig.util.root_pattern(".gitignore")
    })

      -- HTML
    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- yaml
    lspconfig["yamlls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- css
    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- TypeScript
    lspconfig["ts_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- emmet
    lspconfig["emmet_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css"}
    })

      -- R
    lspconfig["r_language_server"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = {"r"}
    })

      -- DOCKER
        -- "docker_compose_language_service",
    lspconfig["docker_compose_language_service"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

        -- "dockerls",
    lspconfig["dockerls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- "graphql",
    lspconfig["graphql"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- "jsonls",
    lspconfig["jsonls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- "prismals",
    lspconfig["prismals"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

      -- lua (with special settings)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          -- make LS recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make LS aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,
}
