if vim.fn.has("nvim-0.11") == 0 then
    vim.notify("NativeVim only supports Neovim 0.11+", vim.log.levels.ERROR)
    return
end

require("core.options")
require("core.treesitter")
require("core.lsp")
require("core.statusline")
require("core.keymaps")
require("core.commands")
require("core.highlights")

local nightly_vimrc = vim.fn.stdpath("config") .. "/native-completion-find-grep.vim"
vim.cmd("source " .. vim.fn.fnameescape(nightly_vimrc))
