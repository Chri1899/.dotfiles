return {
  "christoomey/vim-tmux-navigator",
  cmd = {
	"TmuxNavigateLeft",
	"TmuxNavigateRight",
	"TmuxNavigateUp",
	"TmuxNavigateDown",
	"TmuxNavigatePrevious",
  },
  keys = {
	{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
	{ "<c-j>", "<cmd><C-J>TmuxNavigateDown<cr>" },
	{ "<c-k>", "<cmd><C-K>TmuxNavigateUp<cr>" },
	{ "<c-l>", "<cmd><C-L>TmuxNavigateRight<cr>" },
  },
}
