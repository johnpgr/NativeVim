local util = require "util"
local keymap = util.keymap

-- Function to set tree-style netrw
local function open_tree_netrw()
    vim.g.netrw_browse_split = 4
    vim.g.netrw_altv = 1
    vim.g.netrw_liststyle = 3
    -- Disable netrw's <C-l> mapping in the netrw buffer
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "netrw",
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
        end
    })
    vim.cmd("25Lex")
end

-- Function to open default netrw
local function open_default_netrw()
    vim.g.netrw_browse_split = 0
    vim.g.netrw_altv = 0
    vim.g.netrw_liststyle = 0
    vim.cmd("Ex")
end

local function qf_toggle()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_exists = true
        end
    end
    if qf_exists then
        vim.cmd.cclose()
    else
        vim.cmd.copen()
    end
end

local function qf_next()
    local qf_list = vim.fn.getqflist()
    local qf_length = #qf_list
    if qf_length == 0 then
        return
    end

    local current_idx = vim.fn.getqflist({ idx = 0 }).idx
    if current_idx >= qf_length then
        vim.cmd("cfirst")
    else
        vim.cmd("cnext")
    end
    vim.cmd("copen")
end

local function qf_prev()
    local qf_list = vim.fn.getqflist()
    local qf_length = #qf_list
    if qf_length == 0 then
        return
    end

    local current_idx = vim.fn.getqflist({ idx = 0 }).idx
    if current_idx <= 1 then
        vim.cmd("clast")
    else
        vim.cmd("cprevious")
    end
    vim.cmd("copen")
end

keymap("<leader>e", open_default_netrw, "File Explorer")
-- open netrw file explorer as a sidebar at the left
keymap("<leader>b", open_tree_netrw, "File Explorer (Sidebar)")
keymap("<leader>ff", ":find ", "Find files")
keymap("<leader>fw", ":Grep ", "Find word")
keymap("<leader>ts", util.toggle_spaces_width, "Toggle spaces width")
keymap("<leader>ti", util.toggle_indent_mode, "Toggle indent mode")
keymap("<C-h>", "<C-w>h", "Window left")
keymap("<C-j>", "<C-w>j", "Window down")
keymap("<C-k>", "<C-w>k", "Window up")
keymap("<C-l>", "<C-w>l", "Window right")
keymap("<C-Up>", ":resize -2<CR>", "Window resize up")
keymap("<C-Down>", ":resize +2<CR>", "Window resize down")
keymap("<C-Left>", ":vertical resize -2<CR>", "Window resize left")
keymap("<C-Right>", ":vertical resize +2<CR>", "Window resize right")
keymap("<", "<gv", "Keep selection when indenting multiple lines", "v")
keymap(">", ">gv", "Keep selection when indenting multiple lines", "v")
keymap("J", ":m '>+1<CR>gv=gv", "Move line down", "v")
keymap("K", ":m '<-2<CR>gv=gv", "Move line up", "v")
keymap("gd", vim.lsp.buf.definition, "Goto Definition")
keymap("gD", vim.lsp.buf.type_definition, "Goto Type Definition")
keymap("gD", vim.lsp.buf.references, "Goto References")
keymap("<leader>ca", vim.lsp.buf.code_action, "LSP: Code actions")
keymap("<leader>gh", vim.lsp.buf.signature_help, "LSP: Signature help")
keymap("<leader>df", vim.diagnostic.open_float, "Diagnostics: Open Hover")
keymap("<leader>dl", vim.diagnostic.setqflist, "Diagnostics: Set quickfix list", "n")
keymap("<leader>lh", "<cmd>checkhealth vim.lsp<cr>", "LSP: Check health")
keymap("<leader>qf", qf_toggle, "Quickfixlist toggle")
keymap("]q", qf_next, "Quickfixlist next")
keymap("[q", qf_prev, "Quickfixlist previous")
keymap("<leader>tt", "<cmd>tabnew<cr><cmd>term<cr>", "Open terminal in a new tab")
keymap("<leader>tn", "<cmd>tabnew<cr>", "Open new tab")
keymap("]t", "<cmd>tabnext<cr>", "Tab next")
keymap("[t", "<cmd>tabprevious<cr>", "Tab previous")
keymap("<Esc>", "<C-\\><C-n>", "Terminal mode easy exit", "t")
