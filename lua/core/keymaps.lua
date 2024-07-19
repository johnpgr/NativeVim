local utils = require("util")
local keymap = utils.keymap
local feedkeys = utils.feedkeys

keymap("<C-/>", "gcc", {remap = true, silent = true, desc = "Comment toggle"}, "n")
keymap("<C-/>", "gc", {remap = true, silent = true, desc = "Comment toggle"}, "v")
keymap("<leader>e", "<cmd>Explore<cr>", "Explorer")
keymap("<C-p>", "<cmd>Files<cr>", "Fuzzy Files Finder")
keymap("<C-f>", "<cmd>LiveGrep<cr>", "Live Grep")
keymap("<C-k>", "<C-w>k", "Focus up split")
keymap("<C-l>", "<C-w>l", "Focus left split")
keymap("<C-j>", "<C-w>j", "Focus down split")
keymap("<C-h>", "<C-w>h", "Focus right split")
keymap("<A-h>", "<C-w><", "Resize <")
keymap("<A-l>", "<C-w>>", "Resize >")
keymap("<A-j>", "<C-w>-", "Resize -")
keymap("<A-k>", "<C-w>+", "Resize +")
keymap("<A-=>", "<C-w>=", "Reset splits sizes")
keymap("<leader>v", "<C-w>v<C-w>l", "New vertical split")
keymap("<leader>h", "<C-w>s<C-w>j", "New horizontal split")
keymap("<Esc>", "<cmd>noh<cr>", "Clear search highlights","n")
keymap("<C-d>", "<C-d>zz", "Better scroll down")
keymap("<C-u>", "<C-u>zz", "Better scroll up")
keymap("n", "nzz", "Better jump next", "n")
keymap("]d", function()
    vim.diagnostic.goto_next()
    feedkeys "zz"
end, {desc = "Better jump next diagnostic", remap = true}, "n")
keymap("[d", function()
    vim.diagnostic.goto_prev()
    feedkeys "zz"
end, {desc = "Better jump prev diagnostic", remap = true}, "n")
keymap("J", ":m '>+1<CR>gv=gv", "Move line down","v")
keymap("K", ":m '<-2<CR>gv=gv", "Move line up","v")
keymap("<", "<gv", "Keep selection when indenting multiple lines","v")
keymap(">", ">gv", "Keep selection when indenting multiple lines","v")
keymap("J", ":m '>+1<CR>gv=gv", "Move line down", "v")
keymap("K", ":m '<-2<CR>gv=gv", "Move line up","v")
keymap("gd", vim.lsp.buf.definition, "LSP: Goto definition","n")
keymap("gr", vim.lsp.buf.references, "LSP: Goto definition","n")
keymap("<leader>lr", vim.lsp.buf.rename, "LSP: Goto definition","n")
keymap("K", function()
    local next_diag_pos = vim.diagnostic.get_next_pos()
    local current_pos = vim.api.nvim_win_get_cursor(0)

    if next_diag_pos then
        if next_diag_pos[1]+1 == current_pos[1] then
            vim.diagnostic.open_float()
            return
        end
    end

    vim.lsp.buf.hover()
end, "LSP: Show hover message", "n")
keymap("<F1>", function() feedkeys(":SplitrunNew ") end, "Splitrun")
keymap("<leader>tt","<cmd>tabnew<cr><cmd>terminal<cr>", "Open terminal tab")
keymap("<leader>tn", "<cmd>tabnew<cr>", "Open new tab")
keymap("<Esc>", "<C-\\><C-n>","Terminal mode easy exit", "t")
keymap("<M-]>", "<cmd>tabnext<cr>","Tab next")
keymap("<M-[>", "<cmd>tabprevious<cr>","Tab previous")
keymap("<C-g>", "<cmd>tabnew<cr><cmd>terminal<cr>lazygit<cr>", "Lazygit")
