local dap = require("dap")

-- Adapter configuration
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		-- Adjust this path to where you installed codelldb
		command = vim.fn.expand("~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"),
		args = { "--port", "${port}" },
		detached = false,
	},
}

-- C++ configuration
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
		args = {}, -- Add program arguments here if needed
	},
}

-- C configuration uses the same setup
dap.configurations.c = dap.configurations.cpp
