local util = require("util")

util.update_wildignore()

-- Auto update wildignore
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
	callback = function()
		util.update_wildignore()
	end,
})

-- Auto start treesitter
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Better :grep command
vim.api.nvim_create_user_command('Grep', function(opts)
    vim.cmd('silent! grep! ' .. opts.args)
    vim.cmd('cwindow')
    vim.cmd('redraw!')
end, { nargs = '+', complete = 'file' })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Better terminal buffer
vim.cmd([[
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
    autocmd TermEnter * setlocal nospell
]])

-- Disable LSP semantic tokens
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})
