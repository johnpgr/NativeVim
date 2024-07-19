-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = "*",
})

-- TODO have the netrw current file path appended
local function touch_file()
    if vim.bo.filetype == "netrw" then
        vim.ui.input({ prompt = "Enter file name: " }, function(file_name)
            if not file_name or file_name == "" then
                return
            end
            local file = io.open(file_name, "w")
            if file then
                file:close()
                vim.cmd("e")
            end
        end)
    end
end

vim.api.nvim_create_user_command("Touch", touch_file, {})

-- Terminal mode
vim.cmd [[
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
]]

vim.cmd [[
    highlight NormalFloat guibg=#504945
    highlight FoldColumn guibg=#282828
    highlight SignColumn guibg=#282828
]]
