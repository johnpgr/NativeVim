if vim.fn.has("nvim-0.11") == 0 then
    vim.notify("NativeVim only supports Neovim 0.11+", vim.log.levels.ERROR)
    return
end
require("core.options")
require("core.cmds")
require("core.treesitter")
require("core.lsp")
require("core.statusline")
require("core.snippet")
require("plugins.netrw")
require("plugins.fzf")
require("core.keymaps")
require("plugins.splitrun").setup()
