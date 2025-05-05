local function hl(name, opts)
    local hl_group = vim.api.nvim_create_namespace(name)
    vim.api.nvim_set_hl(0, name, opts)
    return hl_group
end

hl("Normal", { bg = "none" })

-- Force diagnostics to use undercurls
vim.cmd [[ 
    hi DiagnosticUnderlineError gui=undercurl
    hi DiagnosticUnderlineHint gui=undercurl
    hi DiagnosticUnderlineInfo gui=undercurl
    hi DiagnosticUnderlineOk gui=undercurl
    hi DiagnosticUnderlineWarn gui=undercurl
]]

