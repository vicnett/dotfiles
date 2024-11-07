-- General Vim Settings
-- --------------------

-- vim.g.python_indent = {}
-- vim.g.python_indent.open_paren = 'shiftwidth()'
-- vim.g.python_indent.closed_paren_align_last_line = v:false

vim.g.python_indent = {
  open_paren = 'shiftwidth()',
  closed_paren_align_last_line = false,
}

-- Fuzzy file finding
vim.opt.path:append '**'

-- Assume POSIX-compliant shell syntax for highlighting purposes, when other
-- detection methods fail
vim.g.is_posix = 1
