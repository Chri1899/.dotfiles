-- Autocmd: cmake-tools Root auf aktuellen Projektordner setzen
vim.api.nvim_create_autocmd("User", {
	pattern = { "NeovimProjectLoad", "NeovimProjectDiscover" },
	callback = function()
		local cwd = vim.fn.getcwd()
		local ok, cmake_tools = pcall(require, "cmake-tools")
		if ok then
			cmake_tools.set_project_path(cwd)
			-- Optional: Info ausgeben
			vim.notify("cmake-tools Projekt-Root gesetzt auf: " .. cwd, vim.log.levels.INFO)
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function(data)
		-- 1️⃣ Prüfe, ob du eine Datei oder ein Verzeichnis geöffnet hast
		local is_directory = vim.fn.isdirectory(data.file) == 1
		local is_file = vim.fn.filereadable(data.file) == 1

		-- 2️⃣ Falls Datei oder Verzeichnis: Dashboard NICHT starten
		if is_file then
			return
		end

		-- 3️⃣ Nur starten, wenn kein Buffer offen oder leerer Start
		if vim.fn.argc() == 0 or is_directory then
			-- Snacks Dashboard starten
			require("snacks.dashboard").open()
		end
	end,
})
