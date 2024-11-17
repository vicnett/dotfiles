return {
  "stevearc/conform.nvim",
  -- Load plugin before writing file, since it will automatically format when
  -- writing
  event = { "BufWritePre" },
  -- Also load
  cmd = { "ConformInfo" },
  init = function()
    -- Set formatexpr so builtin vim formatting commands will use conform.
    -- This sets the following options automatically:
    -- opts = vim.tbl_deep_extend("keep", opts or {}, {
    --   timeout_ms = 500,
    --   lsp_format = "fallback",
    --   bufnr = vim.api.nvim_get_current_buf(),
    -- })
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't have a
      -- well standardized coding style. You can add additional languages here
      -- or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = "never"
      else
        lsp_format_opt = "fallback"
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    -- Configure formatters per file type.
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      markdown = { "markdownlint" },
    },
  },
}
