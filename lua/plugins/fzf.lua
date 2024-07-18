--[[
latest fzf comes with builtin Vim/Neovim plugin.
If you installed fzf via homebrew or manually build from source, you can use cloned fzf repo as vim plugin

see <https://github.com/junegunn/fzf/blob/master/README-VIM.md> for more information about fzf plugin
--]]
vim.opt.runtimepath:append("~/.fzf")

local fzf_file_finder_cmd = [[FZF --preview=~/.fzf/bin/fzf-preview.sh\ {}]]
vim.api.nvim_create_user_command("Files", fzf_file_finder_cmd, {})

vim.cmd[[
    function! ParseRipgrepOutput(output)
        let l:parts = split(a:output, ':')
        if len(l:parts) >= 3
            let l:filename = l:parts[0]
            let l:line = str2nr(l:parts[1])
            let l:col = str2nr(l:parts[2])
            execute 'e ' . l:filename
            call cursor(l:line, l:col)
        endif
    endfunction
]]

local INITIAL_QUERY = [[${*:-}]]
local RG_PREFIX = [[rg --column --line-number --no-heading --color=always --smart-case]]

local fzf_live_grep_cmd = [[call fzf#run(fzf#wrap({'source': ']]..RG_PREFIX..[[', 'options': '--ansi --disabled --query "]]..INITIAL_QUERY..[[" --bind "start:reload:]]..RG_PREFIX..[[ {q}" --bind "change:reload:sleep 0.1; ]]..RG_PREFIX..[[ {q} || true" --delimiter : --preview "bat --style="${BAT_STYLE:-numbers}" --pager=never --color=always --highlight-line {2} {1}"', 'sink': function("ParseRipgrepOutput")}))]]

vim.api.nvim_create_user_command("LiveGrep", fzf_live_grep_cmd, {})
