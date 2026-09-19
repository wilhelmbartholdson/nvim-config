return {
	"mfussenegger/nvim-lint",
	config = function ()
		local lint = require("lint")

		local eslint = vim.fn.executable("eslint_d") == 1 and "eslint_d" or "eslint"

		-- lint.linters.lintr = {
		--   cmd = "/opt/homebrew/bin/R",
		--   args = {
		--     "--vanilla",
		--     "--no-echo",
		--     "-e",
		--     "print(lintr::lint(commandArgs(trailingOnly = TRUE)))",
		--     "--args",
		--   },
		--   stdin = false,
		--   ignore_exitcode = true,
		--   parser = require("lint.parser").from_pattern(
		--     "(.-):(%d+):(%d+): (%a+): %[(.-)%] (.+)",
		--     { "file", "lnum", "col", "severity", "code", "message" },
		--     {
		--       error = vim.diagnostic.severity.ERROR,
		--       style = vim.diagnostic.severity.WARN,
		--       warning = vim.diagnostic.severity.WARN,
		--     },
		--     { source = "lintr" }
		--   ),
		-- }

		lint.linters_by_ft = {
			javascript = { eslint },
			javascriptreact = { eslint },
			typescript = { eslint },
			typescriptreact = { eslint },
			vue = { eslint },
			svelte = { eslint },
			python = { "ruff" }
			-- r = { "lintr" },
		}

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			callback = function ()
				lint.try_lint()
			end
		})
	end
}
