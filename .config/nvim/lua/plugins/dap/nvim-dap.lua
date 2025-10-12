-- NOTE: Debug Adapter Protocol
return {
	"mfussenegger/nvim-dap",
	config = function()
		-- NOTE: Check out this for guide
		-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
		local dap = require("dap")
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

		local dapui = require("dapui")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		-- dap.listeners.before.event_terminated["dapui_config"] = function()
		--   dapui.close()
		-- end

		-- dap.listeners.before.event_exited["dapui_config"] = function()
		--   dapui.close()
		-- end

		-- NOTE: Make sure to install the needed files/exectubles through mason
		require("plugins.dap.settings.cpptools")
		require("plugins.dap.settings.java-debug")
	end,
}
