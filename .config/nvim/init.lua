vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.expandtab = true
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>d", ":t.<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope fd<CR>")
vim.keymap.set("n", "<leader>gr", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "<leader>gd", ":Telescope lsp_definitions<CR>")
vim.keymap.set("n", "<leader>p", ":Pick grep pattern<CR>")
vim.keymap.set("n", "<leader>cc", ":ClaudeCode<CR>")
vim.keymap.set("n", "<leader>t", ":split | terminal<CR>")

vim.pack.add {
	-- lsp
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },

	-- telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-file-browser.nvim" },

	-- theme
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },

	-- Niceties
	{ src = "https://github.com/nvim-mini/mini.nvim" },

    -- AI
    { src = "https://github.com/greggh/claude-code.nvim"}

}

require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "ruff", "ts_ls", "eslint", "gopls", "pyright", "jsonls", "yamlls" },
}

require("telescope").setup()
require("telescope").load_extension "file_browser"
require("oil").setup()
require("mini.pick").setup()
require("mini.comment").setup()
require("mini.ai").setup()
require("mini.completion").setup({
	mappings = {
		force_twostep = '<C-n>',
	}
})
require("claude-code").setup()

vim.cmd [[colorscheme tokyonight-night]]


vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.tsx', '*.ts', '*.cts', '*.jsx', '*.js', '*.cjs' },
	command = 'LspEslintFixAll',
	group = vim.api.nvim_create_augroup('EslintAutoFormat', {})
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.py' },
	callback = function()
		vim.lsp.buf.code_action {
			context = {
				only = { 'source.fixAll' },
				diagnostics = {}
			},
			apply = true,
		}
		vim.lsp.buf.format { async = true }
	end,
	group = vim.api.nvim_create_augroup('RuffAutoFormat', {})
})


vim.keymap.set('n', 'gK', function()
	local new_config = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })
