return {
		"mfussenegger/nvim-dap",
		dependencies = {
				"rcarriga/nvim-dap-ui",
				"nvim-neotest/nvim-nio"
		},

		config = function()
				local dap = require("dap")
				local dapui = require("dapui")

				dapui.setup()

				-- setup an event listener for when the debugger is launched
				dap.listeners.before.launch.dapui_config = function()
						-- when the debuigger is launched open up the debug ui
						dapui.open()
				end

				-- vim motions
				vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[D]ebug [T]oggle Breakpoint" })
				vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[D]ebug [S]tart" })
				vim.keymap.set("n", "<leader>dc", dap.close, { desc = "[D]ebug [C]lose" })
		end
}
