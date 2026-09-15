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

	local keymaps = {}
	local longest_lhs = 0
	for _, map in pairs(by_lhs) do
		local lhs = display_lhs(map.lhs)
		keymaps[lhs] = map.desc or (map.rhs ~= "" and map.rhs) or "(no description)"
		longest_lhs = math.max(longest_lhs, #lhs)
	end

	return keymaps, longest_lhs
end

local function disable_blink_in_new_buffers(before)
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if not before[bufnr] then
			-- wf.nvim creates three temporary scratch buffers for this picker.
			-- This is Blink's supported buffer-local switch, so it cannot affect
			-- completion in the invoking buffer or in other buffers.
			vim.b[bufnr].completion = false
		end
	end
end

local function open_keymap_help()
	local keymaps, longest_lhs = normal_mode_keymaps(vim.api.nvim_get_current_buf())
	local existing_buffers = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		existing_buffers[bufnr] = true
	end

	-- wf.select fuzzy-matches table keys. Supplying lhs as each key therefore
	-- searches the key sequence, while its value is rendered as the description.
	require("wf").select(keymaps, {
		title = "Keymap help",
		selector = "fuzzy",
		-- wf normally truncates key labels to seven characters because it is a
		-- which-key UI. A keymap reference needs to show the complete lhs.
		prefix_size = math.max(longest_lhs, 1),
	}, function()
		-- This is deliberately a no-op: selecting a mapping must never run it.
	end)

	disable_blink_in_new_buffers(existing_buffers)
end

return {
	{
		"Cassin01/wf.nvim",
		version = "*",
		config = function()
			vim.keymap.set("n", "<Leader>wf", open_keymap_help, {
				noremap = true,
				silent = true,
				desc = "Search keymaps",
			})
		end,
	},
}
