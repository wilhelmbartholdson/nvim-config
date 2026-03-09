-- Enable servers
local servers = {
  "ruff",
  "jsonls",
  "lua_ls",
  "pyright",
  "html",
  "ts_ls",
  "clangd",
  "solidity_ls_nomicfoundation",
  "bash"
  -- "eslint"
  -- "tailwindcss",
  -- "solc"
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.enable(servers, {
  capabilities = capabilities
})

-- Enable virtual diagnostic lines under lines
vim.diagnostic.config({
  virtual_lines = {

    -- Only show for current line
    current_line = true,
  },
})

-- Enable autocomplete
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "fuzzy", "popup" }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

-- Set round borders for floats
vim.o.winborder = 'rounded'
