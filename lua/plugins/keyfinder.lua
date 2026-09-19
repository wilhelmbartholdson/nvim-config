-- Read-only keymap lookup.  This module is deliberately dependency-free apart
-- from the installed `fzf` executable used to get fzf's matching behaviour.
local M = {}

local modes = { "n", "v", "x", "s", "o", "!", "i", "l", "c", "t" }
local namespace = vim.api.nvim_create_namespace("keyfinder")

local state = {
	query_buf = nil,
	query_win = nil,
	results_buf = nil,
	results_win = nil,
	source_win = nil,
	entries = {},
	visible = {},
	selected = 1,
	closing = false
}

local function valid(win)
	return win and vim.api.nvim_win_is_valid(win)
end

-- Collect both scopes explicitly: a buffer-local mapping may shadow a global
-- one, but showing both makes this a lookup tool rather than an executor.
local function collect_keymaps(bufnr)
	local entries = {}
	local serial = 0

	local function add(maps, scope)
		for _, map in ipairs(maps) do
			serial = serial + 1
			local lhs = vim.fn.keytrans(map.lhs or "")
			local desc = map.desc
			if type(desc) ~= "string" or desc == "" then
				desc = "[no description]"
			end

			table.insert(entries, {
				mode = map.mode or "?",
				scope = scope,
				lhs = lhs,
				desc = desc:gsub("[\r\n]+", " "),
				serial = serial
			})
		end
	end

	for _, mode in ipairs(modes) do
		add(vim.api.nvim_get_keymap(mode), "global")
		add(vim.api.nvim_buf_get_keymap(bufnr, mode), "buffer")
	end

	-- A deterministic base order keeps equal fzf matches predictable.
	table.sort(entries, function (a, b)
		if a.mode ~= b.mode then
			return a.mode < b.mode
		end
		if a.lhs ~= b.lhs then
			return a.lhs < b.lhs
		end
		if a.scope ~= b.scope then
			return a.scope < b.scope
		end
		if a.desc ~= b.desc then
			return a.desc < b.desc
		end
		return a.serial < b.serial
	end)

	return entries
end

-- Ask fzf only whether each string matches, retaining our stable base order.
-- `--nth=2..` prevents the private numeric ID from affecting the query.
local function fzf_match_indexes(entries, query, field)
	local input = {}
	for index, entry in ipairs(entries) do
		table.insert(input, string.format("%d\t%s", index, field(entry)))
	end

	local output = vim.fn.systemlist({
		"fzf",
		"--filter=" .. query,
		"--no-sort",
		"--delimiter=\t",
		"--nth=2.."
	}, table.concat(input, "\n"))

	local matches = {}
	for _, line in ipairs(output) do
		local index = tonumber(line:match("^(%d+)\t"))
		if index then
			matches[index] = true
		end
	end
	return matches
end

-- Key-sequence matches always precede description-only matches.  Within each
-- group the original sorted order is retained rather than using fzf's scores.
local function filter_entries(entries, query)
	if query == "" then
		return vim.deepcopy(entries)
	end

	local lhs_matches = fzf_match_indexes(entries, query, function (entry)
		return entry.lhs
	end)
	local desc_matches = fzf_match_indexes(entries, query, function (entry)
		return entry.desc
	end)
	local visible = {}

	for index, entry in ipairs(entries) do
		if lhs_matches[index] then
			table.insert(visible, entry)
		end
	end
	for index, entry in ipairs(entries) do
		if not lhs_matches[index] and desc_matches[index] then
			table.insert(visible, entry)
		end
	end
	return visible
end

local function close()
	if state.closing then
		return
	end
	state.closing = true

	if valid(state.query_win) then
		vim.api.nvim_win_close(state.query_win, true)
	end
	if valid(state.results_win) then
		vim.api.nvim_win_close(state.results_win, true)
	end
	if valid(state.source_win) then
		vim.api.nvim_set_current_win(state.source_win)
	end

	state.query_buf, state.query_win = nil, nil
	state.results_buf, state.results_win = nil, nil
	state.source_win, state.entries, state.visible = nil, {}, {}
	state.closing = false
end

local function highlight_selection()
	if not state.results_buf or not vim.api.nvim_buf_is_valid(state.results_buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(state.results_buf, namespace, 0, -1)
	if #state.visible > 0 then
		-- The input overlays line 1 and line 2 is the column heading.
		vim.api.nvim_buf_add_highlight(state.results_buf, namespace, "Visual", state.selected + 1, 0, -1)
		if valid(state.results_win) then
			vim.api.nvim_win_set_cursor(state.results_win, { state.selected + 2, 0 })
		end
	end
end

local function render()
	if not state.query_buf or not vim.api.nvim_buf_is_valid(state.query_buf) then
		return
	end
	local query = vim.api.nvim_buf_get_lines(state.query_buf, 0, 1, false)[1] or ""
	state.visible = filter_entries(state.entries, query)
	state.selected = math.min(math.max(state.selected, 1), math.max(#state.visible, 1))

	-- Reserve the first results line for the search float that sits above it.
	local lines = { "", "MODE  SCOPE    KEY SEQUENCE                      DESCRIPTION" }
	if #state.visible == 0 then
		table.insert(lines, "                  No mappings match this fzf query.")
	else
		for _, entry in ipairs(state.visible) do
			local scope = entry.scope == "buffer" and "[buffer]" or "global"
			table.insert(lines, string.format("%-5s %-8s %-33s %s", entry.mode, scope, entry.lhs, entry.desc))
		end
	end

	vim.bo[state.results_buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.results_buf, 0, -1, false, lines)
	vim.bo[state.results_buf].modifiable = false
	highlight_selection()
end

local function move_selection(delta)
	if #state.visible == 0 then
		return
	end
	state.selected = ((state.selected - 1 + delta) % #state.visible) + 1
	highlight_selection()
end

local function map_controls(buf)
	local opts = { buffer = buf, silent = true, nowait = true }
	vim.keymap.set({ "n", "i" }, "<Esc>", close, opts)
	vim.keymap.set("n", "q", close, opts)
	-- Enter only dismisses the UI; it intentionally never invokes a mapping.
	vim.keymap.set({ "n", "i" }, "<CR>", close, opts)
	vim.keymap.set({ "n", "i" }, "<C-n>", function ()
		move_selection(1)
	end, opts
	)
	vim.keymap.set({ "n", "i" }, "<C-p>", function ()
		move_selection(-1)
	end, opts
	)
end

local function make_buffer(modifiable)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = modifiable
	return buf
end

local function open()
	if vim.fn.executable("fzf") ~= 1 then
		vim.notify(
			"Keyfinder requires the external `fzf` executable for fuzzy matching; it was not found in $PATH.",
			vim.log.levels.WARN
		)
		return
	end
	if valid(state.results_win) then
		vim.api.nvim_set_current_win(state.query_win)
		return
	end

	state.source_win = vim.api.nvim_get_current_win()
	state.entries = collect_keymaps(vim.api.nvim_get_current_buf())
	state.selected = 1
	state.results_buf = make_buffer(false)
	state.query_buf = make_buffer(true)
	-- Blink honours this buffer-local switch, leaving completion unchanged
	-- everywhere else while the dedicated search input remains plain text.
	vim.b[state.query_buf].completion = false

	-- Keep the lookup out of the editor's centre: anchor it near lower-right.
	local width = math.min(math.max(70, math.floor(vim.o.columns * 0.55)), 120)
	local height = math.min(math.max(12, math.floor(vim.o.lines * 0.55)), vim.o.lines - 4)
	local row = math.max(1, vim.o.lines - height - 3)
	local col = math.max(0, vim.o.columns - width - 3)

	-- The results and editable input are coordinated floats, so the search box
	-- remains visibly at the top while the listing buffer stays read-only.
	state.results_win = vim.api.nvim_open_win(state.results_buf, false, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = " Keymap lookup ",
		title_pos = "center",
		footer = " Esc/q close  ·  C-n/C-p select  ·  Enter closes only ",
		footer_pos = "center"
	})
	vim.wo[state.results_win].wrap = false
	vim.wo[state.results_win].cursorline = false

	state.query_win = vim.api.nvim_open_win(state.query_buf, true, {
		relative = "editor",
		row = row + 1,
		col = col + 2,
		width = width - 4,
		height = 1,
		style = "minimal",
		border = "single",
		title = " Search (fzf) ",
		title_pos = "left"
	})
	vim.wo[state.query_win].wrap = false

	map_controls(state.query_buf)
	map_controls(state.results_buf)
	vim.api.nvim_buf_attach(state.query_buf, false, {
		on_lines = function ()
			vim.schedule(function ()
				if valid(state.query_win) and valid(state.results_win) then
					render()
				end
			end)
		end
	})

	render()
	vim.cmd("startinsert")
end

function M.setup()
	if vim.g.keyfinder_loaded then
		return
	end
	vim.g.keyfinder_loaded = true
	vim.keymap.set("n", "<leader>wk", open, { desc = "Keymap lookup" })
end

-- Configuration lives here so this file can be imported directly by lazy.nvim.
M.setup()

-- lazy.nvim imports every file in lua/plugins as a plugin spec.  Setup has
-- already run above, so return an empty spec instead of exposing this module.
return {}
