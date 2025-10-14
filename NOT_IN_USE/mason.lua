return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- enable mason and configure icons  
    mason.setup({
      ui = {
        icons = {
        package_installed = "✔",
        package_pending = "➜",
        package_uninstalled = "✘",
        },
      },
    })

    -- setup the mason-lspconfig
    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        -- "ts_ls",
        -- "html",
        -- "cssls",
        -- "lua_ls",
        -- "graphql",
        -- "emmet_ls",
        -- "prismals",
        -- "pyright",
        "cssls",
        "docker_compose_language_service",
        "dockerls",
        "emmet_ls",
        "graphql",
        "html",
        "jsonls",
        "lua_ls",
        "prismals",
        "pyright",
        "r_language_server",
        "ruff",
        "ts_ls",
        "yamlls"
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- NOT the same as enure_installed
    })

  end,
}
