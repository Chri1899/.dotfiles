return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		explorer = { enabled = false },
		dashboard = {
			enabled = true,
			preset = {
				header = [[
 ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
 ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
 ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███
 ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███
 ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███
 ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███
 ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███
  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀

             ]],
			},
		},
		indent = {
			priority = 1,
			enabled = true, -- enable indent guides
			char = "│",
			only_scope = false, -- only show indent guides of the scope
			only_current = false, -- only show indent guides in the current window
			hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
		},
		animate = {
			enabled = vim.fn.has("nvim-0.10") == 1,
			style = "out",
			easing = "inOutCubic",
			duration = {
				step = 10, -- ms per step
				total = 500, -- maximum duration
			},
		},
		scope = {
			enabled = true, -- enable highlighting the current scope
			priority = 200,
			char = "│",
			underline = false, -- underline the start of the scope
			only_current = false, -- only show scope in the current window
			hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
		},
		chunk = {
			-- when enabled, scopes will be rendered as chunks, except for the
			-- top-level scope which will be rendered as a scope.
			enabled = false,
			-- only show chunk scopes in the current window
			only_current = false,
			priority = 200,
			hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
			char = {
				corner_top = "┌",
				corner_bottom = "└",
				-- corner_top = "╭",
				-- corner_bottom = "╰",
				horizontal = "─",
				vertical = "│",
				arrow = ">",
			},
		},
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		picker = { enabled = true },
		quickfile = { enabled = true },
		scroll = {
			animate = {
				duration = { step = 15, total = 250 },
				easing = "linear",
			},
			-- faster animation when repeating scroll after delay
			animate_repeat = {
				delay = 100, -- delay in ms before using the repeat animation
				duration = { step = 5, total = 50 },
				easing = "linear",
			},
			-- what buffers to animate
			filter = function(buf)
				return vim.g.snacks_scroll ~= false
					and vim.b[buf].snacks_scroll ~= false
					and vim.bo[buf].buftype ~= "terminal"
			end,
		},
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				-- wo = { wrap = true } -- Wrap notifications
			},
		},
	},
	keys = {
		-- FIND
		{
			"<leader>ff",
			function()
				Snacks.picker.smart()
			end,
			desc = "Files (SMART)",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>fF",
			function()
				Snacks.picker.files()
			end,
			desc = "Files",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffer()
			end,
			desc = "Buffers",
		},
		{
			"<leader>tn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notifications",
		},
		{
			"<leader>Fr",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename",
		},
		{
			"<leader>N",
			function()
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,
					height = 0.6,
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
			desc = "NEWS",
		},
		-- SEARCH
		{
			"<leader>sc",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.man()
			end,
			desc = "MAN",
		},
	},
}
