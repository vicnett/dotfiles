-- Visual settings
------------------

-- Make it obvious where the textwidth limit is
vim.opt.colorcolumn = "+1"

-- Display extra whitespace
local vert_char = "▏"
vim.opt.list = true
vim.opt.listchars:append({
  tab = vert_char .. "▏›",
  trail = "·",
  nbsp = "·",
  multispace = "·",
})

-- Automatically adapt leadmultispace to current indentation settings, adapted
-- from:
-- https://github.com/gravndal/shiftwidth_leadmultispace.nvim/blob/master/plugin/shiftwidth_leadmultispace.lua
local char = "leadmultispace:" .. vert_char

local function lms(rep)
  return char .. string.rep(" ", rep > 0 and rep - 1 or 0)
end

local function update(old, rep)
  return old:gsub("leadmultispace:[^,]*", lms(rep))
end

local function update_curbuf()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(w) == vim.api.nvim_get_current_buf() then
      vim.wo[w].listchars = update(
        vim.wo[w].listchars,
        vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop
      )
    end
  end
end

local group = vim.api.nvim_create_augroup("ShiftwidthLeadmultispace", {})

-- Sync with 'shiftwidth'.
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "shiftwidth,tabstop",
  group = group,
  callback = function()
    if vim.v.option_type ~= "local" then
      vim.go.listchars = update(
        vim.go.listchars,
        vim.go.shiftwidth > 0 and vim.go.shiftwidth or vim.go.tabstop
      )
    end
    update_curbuf()
  end,
})

-- Update 'listchars' when displaying buffer in a window.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  callback = function()
    vim.wo.listchars = update(
      vim.wo.listchars,
      vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop
    )
  end,
})

-- Handle cases where 'filetype' is set after BufWinEnter.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function()
    update_curbuf()
  end,
})

-- Set global default.
vim.opt_global.listchars:append(lms(vim.go.shiftwidth))

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
