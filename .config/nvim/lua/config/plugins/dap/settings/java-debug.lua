local dap = require("dap")

dap.configurations.java = {
	{
		name = "Launch Java",
		javaExec = "java",
		request = "launch",
		type = "java",
	},
}
