local function display_lhs(lhs)
	local leader = vim.g.mapleader or "\\"
	if lhs:sub(1, #leader) == leader then
		return "<leader>" .. lhs:sub(#leader + 1)
	end
	return lhs
end

local function normal_mode_keymaps(bufnr)
	local by_lhs = {}

	for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
		by_lhs[map.lhs] = map
	end

	-- Buffer-local maps take precedence over global maps with the same lhs.
	for _, map in ipairs(vim.api.nvim_buf_get_keymap(bufnr, "n")) do
		by_lhs[map.lhs] = map
	end

	local maps = {}
	for _, map in pairs(by_lhs) do
		local lhs = display_lhs(map.lhs)
		table.insert(maps, {
			lhs = lhs,
			desc = map.desc or (map.rhs and map.rhs ~= "" and map.rhs) or "(no description)",
			-- Search both Neovim's literal lhs and the familiar <leader> form.
			search = map.lhs .. " " .. lhs,
		})
	end
	table.sort(maps, function(left, right)
		return left.lhs < right.lhs
	end)
	return maps
end

local function open_keymap_help()
	local source_buf = vim.api.nvim_get_current_buf()
	local maps = normal_mode_keymaps(source_buf)
	local query_buf = vim.api.nvim_create_buf(false, true)
	local results_buf = vim.api.nvim_create_buf(false, true)
	local windows = {}
	local closed = false
	local matches = maps
	local selected_index = 1
	local selection_namespace = vim.api.nvim_create_namespace("keymap-help-selection")

	vim.bo[query_buf].bufhidden = "wipe"
	vim.bo[query_buf].filetype = "keymap-help-query"
	vim.b[query_buf].completion = false
	vim.bo[results_buf].bufhidden = "wipe"
	vim.bo[results_buf].filetype = "keymap-help-results"
	vim.bo[results_buf].modifiable = false

	local width = math.max(1, math.min(100, vim.o.columns - 8))
	local col = math.max(0, math.floor((vim.o.columns - width) / 2))
	local max_results_height = math.max(1, math.min(20, vim.o.lines - 6))
	local query_row = math.max(1, vim.o.lines - 4)

	windows.query = vim.api.nvim_open_win(query_buf, true, {
		relative = "editor",
		width = width,
		height = 1,
		col = col,
		row = query_row,
		style = "minimal",
		border = "rounded",
		title = " Search keymaps ",
		title_pos = "center",
	})
	vim.wo[windows.query].cursorline = false

	local function close()
		if closed then
			return
		end
		closed = true
		for _, win in pairs(windows) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end
		for _, buf in ipairs({ query_buf, results_buf }) do
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	end

	local function render(reset_selection)
		if not vim.api.nvim_buf_is_valid(query_buf) or not vim.api.nvim_buf_is_valid(results_buf) then
			return
		end

		local query = vim.api.nvim_buf_get_lines(query_buf, 0, 1, false)[1] or ""
		matches = query == "" and maps or vim.fn.matchfuzzy(maps, query, { key = "search" })
		if reset_selection then
			selected_index = 1
		end
		selected_index = math.min(selected_index, math.max(#matches, 1))

		local lhs_width = 0
		for _, map in ipairs(matches) do
			lhs_width = math.max(lhs_width, vim.fn.strdisplaywidth(map.lhs))
		end

		local lines = {}
		for _, map in ipairs(matches) do
			local padding = string.rep(" ", lhs_width - vim.fn.strdisplaywidth(map.lhs))
			table.insert(lines, map.lhs .. padding .. "  " .. map.desc)
		end
		if #lines == 0 then
			lines = { "No keymaps match this sequence." }
		end

		vim.bo[results_buf].modifiable = true
		vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, lines)
		vim.bo[results_buf].modifiable = false
		vim.api.nvim_buf_clear_namespace(results_buf, selection_namespace, 0, -1)
		if #matches > 0 then
			vim.api.nvim_buf_add_highlight(results_buf, selection_namespace, "Visual", selected_index - 1, 0, -1)
		end

		local height = math.min(max_results_height, #lines)
		local result_row = math.max(0, query_row - height - 2)
		local config = {
			relative = "editor",
			width = width,
			height = height,
			col = col,
			row = result_row,
			title = string.format(" Keymaps: %d / %d  •  <C-n>/<C-p> select  •  <Esc> close ", #matches, #maps),
			title_pos = "center",
		}
		if windows.results and vim.api.nvim_win_is_valid(windows.results) then
			vim.api.nvim_win_set_config(windows.results, config)
			if #matches > 0 then
				vim.api.nvim_win_set_cursor(windows.results, { selected_index, 0 })
			end
		else
			config.style = "minimal"
			config.border = "rounded"
			windows.results = vim.api.nvim_open_win(results_buf, false, config)
			vim.wo[windows.results].cursorline = false
			vim.wo[windows.results].wrap = false
		end
	end

	local function move_selection(delta)
		if #matches == 0 then
			return
		end
		selected_index = ((selected_index - 1 + delta) % #matches) + 1
		render(false)
	end

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		buffer = query_buf,
		callback = function()
			render(true)
		end,
	})
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = query_buf,
		once = true,
		callback = close,
	})

	for _, mode in ipairs({ "i", "n" }) do
		vim.keymap.set(mode, "<Esc>", close, { buffer = query_buf, silent = true })
		vim.keymap.set(mode, "<CR>", "<Nop>", { buffer = query_buf, silent = true })
		vim.keymap.set(mode, "<C-n>", function()
			move_selection(1)
		end, { buffer = query_buf, silent = true })
		vim.keymap.set(mode, "<C-p>", function()
			move_selection(-1)
		end, { buffer = query_buf, silent = true })
	end

	render(true)
	vim.cmd("startinsert!")
end

return {
    {
        "Cassin01/wf.nvim",
        version = "*",
        -- opts = {
        --     theme = "chad"
        -- }
        config = function ()
            local which_key = require("wf.builtin.which_key")
            local register = require("wf.builtin.register")
            local bookmark = require("wf.builtin.bookmark")
            local buffer = require("wf.builtin.buffer")
            local mark = require("wf.builtin.mark")

            -- Register
            vim.keymap.set(
                "n",
                "<Space>wr",
                -- register(opts?: table) -> function
  -- opts?: option
                register(),
                { noremap = true, silent = true, desc = "[wf.nvim] register" }
            )

            -- Bookmark
            vim.keymap.set(
                "n",
                "<Space>wbo",
                -- bookmark(bookmark_dirs: table, opts?: table) -> function
  -- bookmark_dirs: directory or file paths
  -- opts?: option
                bookmark({
                    nvim = "~/.config/nvim",
                    zsh = "~/.zshrc"
                }),
                { noremap = true, silent = true, desc = "[wf.nvim] bookmark" }
            )

            -- Buffer
            vim.keymap.set(
                "n",
                "<Space>wbu",
                -- buffer(opts?: table) -> function
  -- opts?: option
                buffer(),
                { noremap = true, silent = true, desc = "[wf.nvim] buffer" }
            )

            -- Mark
            vim.keymap.set(
                "n",
                "'",
                -- mark(opts?: table) -> function
  -- opts?: option
                mark(),
                { nowait = true, noremap = true, silent = true, desc = "[wf.nvim] mark" }
            )

            -- Which Key
            vim.keymap.set(
                "n",
                "<Leader>",
                -- mark(opts?: table) -> function
   -- opts?: option
                which_key({ text_insert_in_advance = "<Leader>" }),
                { noremap = true, silent = true, desc = "[wf.nvim] which-key /" }
            )

            vim.keymap.set(
                "n",
                "<Leader>wf",
                open_keymap_help,
                { noremap = true, silent = true, desc = "Search keymaps" }
            )
        end
    }
}
