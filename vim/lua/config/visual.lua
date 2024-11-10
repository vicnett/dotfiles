-- Visual settings
------------------

-- Make it obvious where the textwidth limit is
vim.opt.colorcolumn = "+1"

-- Display extra whitespace
vim.opt.list = true
vim.opt.listchars:append({
	tab = "▏›",
	leadmultispace = "▏ ",
	trail = "·",
	nbsp = "·",
	multispace = "·",
})

-- Display relative line numbers, with absolute line number for current line
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.relativenumber = true

-- Automatically turn off relative line numbers when not in focus
-- ... But also don't turn them on and off for help buffers!
local numbertogglegroup =
	vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
	callback = function()
		if vim.bo.filetype ~= "help" then
			vim.opt.relativenumber = true
		end
	end,
	group = numbertogglegroup,
	pattern = "*",
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
	callback = function()
		vim.opt.relativenumber = false
	end,
	group = numbertogglegroup,
	pattern = "*",
})

-- Open new split panes to right and bottom
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Ignore whitespace only changes in diff, always use vertical diffs
vim.opt.diffopt:append({
	iwhite,
	vertical,
	"linematch:60",
	algorithm = histogram,
})
