return {
	"Civitasv/cmake-tools.nvim",
	ft = { "cmake", "cxx", "c", "cpp" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("cmake-tools").setup({
			cmake_command = "cmake",
			cmake_build_directory = "build",
			cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
			cmake_build_options = {},
			cmake_build_type = "Debug",
			cmake_soft_link_compile_commands = true,
			cmake_regenerate_on_save = true,
			cmake_kits_path = nil,
			cmake_variants_message = {
				short = { show = true },
				long = { show = true, max_length = 40 },
			},
		})

		local wk = require("which-key")
		wk.add({
			{ "<leader>Cc", "<cmd>CMakeClean<CR>", desc = "Clean Project" },
			{ "<leader>Cb", "<cmd>CMakeBuild<CR>", desc = "Build Project" },
			{ "<leader>Cg", "<cmd>CmakeGenerate<CR>", desc = "Generate Project" },
			{ "<leader>Cr", "<cmd>CMakeRun<cr>", desc = "Run Project" },
		})
	end,
}
