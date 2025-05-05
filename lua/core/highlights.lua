local function hl(name, opts)
	local hl_group = vim.api.nvim_create_namespace(name)
	vim.api.nvim_set_hl(0, name, opts)
	return hl_group
end

-- Remove normal background color
hl("Normal", { bg = "none" })

-- Force undercurls in diagnostics
hl("DiagnosticUnderlineError", { undercurl = true })
hl("DiagnosticUnderlineHint", { undercurl = true })
hl("DiagnosticUnderlineInfo", { undercurl = true })
hl("DiagnosticUnderlineOk", { undercurl = true })
hl("DiagnosticUnderlineWarn", { undercurl = true })
