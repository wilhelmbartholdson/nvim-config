-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
require("config.keymaps")
require("config.options")

-- initialize lazy.nvim
require("config.lazy")

-- clipboard is in p (not "+ i.e +-registry)
vim.opt.clipboard = "unnamedplus"

-- set scrolloff
vim.opt.scrolloff = 8

-- set conceallevel
vim.o.conceallevel = 1

-- set commandline height to 0 for floating cmdline
-- vim.o.cmdheight = 0

-- initialize lsp
require("config.lsp")

-- enable ui2
require('vim._core.ui2').enable({
	enable = true, -- Whether to enable or disable the UI.
	msg = { -- Options related to the message module.
		---@type string | table<string, 'cmd' | 'msg' | 'pager'> Default message target
		--- or table mapping |ui-messages| kinds, triggers and IDs to a target.
		--- Table keys are matched as a Lua pattern to the message ID. 'default'
		--- mapping applies to any omitted kind: { default = 'cmd', progress = 'msg' }.
		targets = 'cmd',
		dialog = { -- Options related to dialog window.
			height = 0.5 -- Maximum height.
		},
		msg = { -- Options related to msg window.
			height = 0.5 -- Maximum height.
		},
		pager = { -- Options related to message window.
			height = 0.999 -- Maximum height.
		}
	}
})

-- set filetypes explicitly
vim.filetype.add({
	pattern = {
		-- implicit ^ and $ is added so don't add manually
		[".*tmux%.conf"] = "tmux"
	}
})
-- nvim-treesitter
vim.api.nvim_create_autocmd('FileType', {
	pattern = {
		'python',
		'javascript',
		'jsx',
		'typescript',
		'tsx',
		'lua',
		'html',
		'css',
		'markdown',
		"r"
	},
	callback = function ()
		vim.treesitter.start()
		vim.wo[0][0].foldmethod = 'expr'
		vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.opt.foldenable = false -- disable folding on startup
	end
})
