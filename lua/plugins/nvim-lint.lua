return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    local eslint = vim.fn.executable("eslint_d") == 1 and "eslint_d" or "eslint"

    lint.linters_by_ft = {
      javascript = { eslint },
      javascriptreact = { eslint },
      typescript = { eslint },
      typescriptreact = { eslint },
      vue = { eslint },
      svelte = { eslint },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      callback = function()
        if vim.fn.executable(eslint) == 1 then
          lint.try_lint()
        end
      end,
    })
  end,
}
