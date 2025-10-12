-- NOTE: Debugging
return {
	"rcarriga/nvim-dap-ui",
	init = function()
		require("which-key").add({
			{ "<leader>Dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
			{ "<leader>Do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
			{ "<leader>Di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
			{ "<leader>DO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },
			{ "<leader>Db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Breakpoint Toggle" },
			{
				"<leader>DB",
				"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
				desc = "Breakpoint Condition",
			},
			{ "<leader>Du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "DAP UI" },
			{ "<leader>Dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Run Last" },
		})
	end,
	dependencies = {
		{ "nvim-neotest/nvim-nio" },
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		{ "mfussenegger/nvim-dap" },
	},
	opts = {
		layouts = {
			{
				elements = {
					-- Elements can be strings or table with id and size keys.
					{ id = "scopes", size = 0.25 },
					"breakpoints",
					"stacks",
					"watches",
				},
				size = 40, -- 40 columns
				position = "left",
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 0.25, -- 25% of total lines
				position = "bottom",
			},
		},
	},
}
