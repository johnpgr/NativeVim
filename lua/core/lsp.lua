local util = require("util")
local keymap = util.keymap
local pumvisible = util.pumvisible
local feedkeys = util.feedkeys

-- :h lsp-defaults
--
-- NORMAL MODE
-- K        : hover
-- grn      : rename
-- gra      : code action
-- grr      : references
-- CTRL-]   : definition
-- CTRL-W_] : definition in new window
-- CTRL-W_} : definition in preview window
--
-- VISUAL MODE
-- gq : format
--
-- INSERT MODE
-- CTRL-S        : signature help
-- CTRL-X_CTRL-O : completion
--

---server configurations copied from <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md>
---@type table<string, vim.lsp.ClientConfig>
local servers = {
    lua_ls = {
        name = "lua-language-server",
        cmd = { "lua-language-server" },
        root_dir = vim.fs.root(0, { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" }),
        filetypes = { "lua" },
        on_init = require("util").lua_ls_on_init,
    },
    tsserver = {
        name = "typescript-language-server",
        cmd = { "typescript-language-server", "--stdio" },
        root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json", ".git" }),
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        init_options = {
            hostInfo = "neovim",
        },
    },
    gopls = {
        name = "gopls",
        cmd = { "gopls" },
        root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
    },
    rust_analyzer = {
        name = "rust-analyzer",
        cmd = { "rust-analyzer" },
        root_dir = vim.fs.root(0, {"Cargo.toml"}),
        filetypes = { "rust" }
    }
}

local group = vim.api.nvim_create_augroup("UserLspStart", { clear = true })
for name, config in pairs(servers) do
    if vim.fn.executable(servers[name].cmd[1]) ~= 0 then
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = config.filetypes,
            callback = function (ev)
                vim.lsp.start(servers[name], { bufnr = ev.buf })
            end,
        })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = false }),
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
    -- Use enter to accept completions.
    keymap('<cr>', function()
        return pumvisible() and '<C-y>' or '<cr>'
    end, { expr = true }, 'i')
    -- Use slash to dismiss the completion menu.
    keymap('/', function()
        return pumvisible() and '<C-e>' or '/'
    end, { expr = true }, 'i')

    -- Use <C-n> to navigate to the next completion or:
    -- - Trigger LSP completion.
    -- - If there's no one, fallback to vanilla omnifunc.
    keymap('<C-n>', function()
        if pumvisible() then
            feedkeys '<C-n>'
        else
            if next(vim.lsp.get_clients { bufnr = 0 }) then
                vim.lsp.completion.trigger()
            else
                if vim.bo.omnifunc == '' then
                    feedkeys '<C-x><C-n>'
                else
                    feedkeys '<C-x><C-o>'
                end
            end
        end
    end, 'Trigger/select next completion', 'i')

    -- Buffer completions.
    keymap('<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' }, 'i')

    -- Use <Tab> to accept a Copilot suggestion, navigate between snippet tabstops,
    -- or select the next completion.
    -- Do something similar with <S-Tab>.
    keymap('<Tab>', function()
        -- local copilot = require 'copilot.suggestion'
        --
        -- if copilot.is_visible() then
        --     copilot.accept()
        if pumvisible() then
            feedkeys '<C-n>'
        elseif vim.snippet.active { direction = 1 } then
            vim.snippet.jump(1)
        else
            feedkeys '<Tab>'
        end
    end, {}, { 'i', 's' })
    keymap('<S-Tab>', function()
        if pumvisible() then
            feedkeys '<C-p>'
        elseif vim.snippet.active { direction = -1 } then
            vim.snippet.jump(-1)
        else
            feedkeys '<S-Tab>'
        end
    end, {}, { 'i', 's' })

    -- Inside a snippet, use backspace to remove the placeholder.
    keymap('<BS>', '<C-o>s', {}, 's')
    end
})

