-- Formatting settings
----------------------

-- Set maximum line length
vim.opt.textwidth = 80

-- Formatting options:
-- j Remove comment leaders when joining lines (where it makes sense)
-- tc Auto-wrap in both text and comments
-- r Continue comment on new line when hitting <Enter> in insert mode
-- o Continue comment on new line when hitting "o" or "O"
-- q Allow formatting comments with "gq"
-- l Don't automatically break the line if it was already longer than
--   'textwidth' when the insert command started
-- 1 Don't break a line after a one-letter word; break it before it if possible
vim.opt.formatoptions = jtcroql1

-- Default to 2 space indentation
-- Note: vim-sleuth will dynamically adjust these based on context
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.softtabstop = -1
vim.opt.shiftround = true
vim.opt.expandtab = true
