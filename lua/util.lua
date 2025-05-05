local M = {}

function M.toggle_spaces_width()
    local current_width = vim.opt.shiftwidth:get()
    local current_tabstop = vim.opt.tabstop:get()

    if current_width == 2 and current_tabstop == 2 then
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
    else
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
    end
    -- Print a message to indicate the current values
    print("Shiftwidth: " .. vim.opt.shiftwidth:get() .. " Tabstop: " .. vim.opt.tabstop:get())
end

function M.toggle_indent_mode()
    -- Get the current value of 'expandtab' (whether spaces are being used)
    local expandtab = vim.bo.expandtab

    if expandtab then
        -- If spaces are being used, toggle to tabs
        vim.bo.expandtab = false
    else
        -- If tabs are being used, toggle to spaces
        vim.bo.expandtab = true
    end

    -- Retab the buffer to apply the changes
    vim.fn.execute("retab!")

    -- Display a message indicating the toggle is done
    local current_mode = vim.bo.expandtab == true and "Spaces" or "Tabs"
    print("Current indentation mode: " .. current_mode)
end

function M.lua_ls_on_init(client)
	local path = vim.tbl_get(client, "workspace_folders", 1, "name")
	if not path then
		return
	end
	-- override the lua-language-server settings for Neovim config
	client.settings = vim.tbl_deep_extend("force", client.settings, {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		},
	})
end

local default_wildignore = {
    "*.o",
    "*.pyc",
    "*.bak",
    "*.swp",
    ".git/*", -- Simplified: .git is often at the root
    "node_modules/*",
}

function M.update_wildignore()
	-- Find .gitignore in CWD or parent directories
	local gitignore_path = vim.fn.findfile(".gitignore", vim.fn.getcwd() .. ";")
	local gitignore_patterns = {}

	if gitignore_path ~= "" then
		-- Read .gitignore file
		for line in io.lines(gitignore_path) do
			-- Skip empty lines, comments, and negated patterns
			if line ~= "" and not line:match("^#") and not line:match("^!") then
				-- Convert .gitignore pattern to wildignore format
				local pattern = line:gsub("^/", ""):gsub("/$", "")
				if pattern:match("/$") then
					pattern = pattern .. "*"
				elseif pattern:match("^[^%.].*[^%*]$") then
					-- Add trailing /* for directories (but not for file patterns like *.log)
					pattern = pattern .. "/*"
				end
				table.insert(gitignore_patterns, pattern)
			end
		end
	end

	-- Combine default and .gitignore patterns
	local wildignore = vim.tbl_extend("force", default_wildignore, gitignore_patterns)
	vim.opt.wildignore = wildignore
end

---Utility for keymap creation.
---@param lhs string|string[]
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
function M.keymap(lhs, rhs, opts, mode)
    opts = type(opts) == "string" and { desc = opts } or vim.tbl_extend("error", opts --[[@as table]], { buffer = 0 })
    mode = mode or { "n", "v" }

    if type(lhs) == "table" then
        for _, l in ipairs(lhs) do
            vim.keymap.set(mode, l, rhs, opts)
        end
    else
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

return M
