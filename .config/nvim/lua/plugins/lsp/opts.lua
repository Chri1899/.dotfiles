local M = {}
local keymap = vim.keymap.set
-- local cmp_nvim_lsp = require "cmp_nvim_lsp"

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.lsp_keymaps = function(bufnr)
	local wk = require("which-key")
	wk.add({
		{ "<leader>lF", "<cmd>Lspsaga finder<cr>", { desc = "Finder", buffer = bufnr, silent = true } },
		{ "<leader>ld", "<cmd>Lspsaga goto_defintion<cr>", { desc = "Definition", buffer = bufnr, silent = true } },
		{
			"<leader>li",
			"<cmd>Telescope lsp_implementations<cr>",
			desc = "Implementations",
		},
		{ "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration" },
		{ "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "Hover Doc", buffer = bufnr, silent = true } },
	})
end

-- Highlight symbol under cursor
M.lsp_highlight = function(client, bufnr)
	if client:supports_method("textDocument/documentHighlight") then
		vim.api.nvim_create_augroup("lsp_document_highlight", {
			clear = false,
		})
		vim.api.nvim_clear_autocmds({
			buffer = bufnr,
			group = "lsp_document_highlight",
		})
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

M.on_attach = function(client, bufnr)
	M.lsp_keymaps(bufnr)
	M.lsp_highlight(client, bufnr)
end

M.on_init = function(client, _)
	if client:supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

return M
