return {
	"goolord/alpha-nvim",

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.buttons.val = {
			dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
			dashboard.button("SPC f d", "󰈞  Find file", ":Telescope find_files <CR>"),
			dashboard.button("SPC t t", "Open Terminal", ":Floatingterminal <CR>"),
			dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
		}

		dashboard.config.opts.noautocmd = true
		alpha.setup(dashboard.config)
	end,
}
