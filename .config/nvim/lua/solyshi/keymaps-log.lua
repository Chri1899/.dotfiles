-- check_keymaps.lua
-- Zeigt doppelte Keymaps mit Modus, Taste, Kommando und Datei

local function find_duplicate_keymaps()
	local seen = {}
	local duplicates = {}

	-- Modi, die wir prüfen wollen
	local modes = { "n", "i", "v", "x", "s", "c", "o" }

	for _, mode in ipairs(modes) do
		local maps = vim.api.nvim_get_keymap(mode)
		for _, map in ipairs(maps) do
			local key = mode .. ":" .. map.lhs
			local entry = {
				mode = mode,
				lhs = map.lhs,
				rhs = map.rhs,
				desc = map.desc or "",
				buffer = map.buffer or "global",
				file = map.silent and "(unknown)" or "(unknown file)",
			}

			-- versuche die Datei zu bekommen
			local ok, info = pcall(vim.api.nvim_get_keymap, mode)
			if ok then
				entry.file = map.buffer and "buffer local" or "global"
			end

			if seen[key] then
				table.insert(duplicates, { prev = seen[key], current = entry })
			else
				seen[key] = entry
			end
		end
	end

	if #duplicates == 0 then
		print("Keine doppelten Keymaps gefunden 👍")
	else
		print("Doppelte Keymaps gefunden:\n")
		for _, d in ipairs(duplicates) do
			print(
				string.format(
					"[%s] %s -> %s (%s)\n    Konflikt mit: %s -> %s (%s)\n",
					d.current.mode,
					d.current.lhs,
					d.current.rhs,
					d.current.file,
					d.prev.lhs,
					d.prev.rhs,
					d.prev.file
				)
			)
		end
	end
end

-- Aufruf
find_duplicate_keymaps()
