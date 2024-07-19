-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = "*",
})

-- Terminal mode
vim.cmd [[
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
]]

vim.cmd [[
    highlight NormalFloat guibg=#2C2E33
]]

vim.cmd [[
    highlight Normal guibg=none
    highlight NonText guibg=none
    highlight Normal ctermbg=none
    highlight NonText ctermbg=none
]]
