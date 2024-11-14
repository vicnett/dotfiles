return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config

    config = function()
      -- Set line colors to be ones from Solarized
      local highlight = {
        "SolarizedMagenta",
        "SolarizedYellow",
        "SolarizedBlue",
        "SolarizedOrange",
        "SolarizedGreen",
        "SolarizedViolet",
        "SolarizedCyan",
      }

      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are
      -- reset every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "SolarizedMagenta", { fg = "#D33682" })
        vim.api.nvim_set_hl(0, "SolarizedYellow", { fg = "#B58900" })
        vim.api.nvim_set_hl(0, "SolarizedBlue", { fg = "#268BD2" })
        vim.api.nvim_set_hl(0, "SolarizedOrange", { fg = "#CB4B16" })
        vim.api.nvim_set_hl(0, "SolarizedGreen", { fg = "#859900" })
        vim.api.nvim_set_hl(0, "SolarizedViolet", { fg = "#6C71C4" })
        vim.api.nvim_set_hl(0, "SolarizedCyan", { fg = "#2AA198" })
      end)

      -- Sync highlight colors with rainbow_delimiters
      vim.g.rainbow_delimiters = { highlight = highlight }

      local default_config = require("ibl.config").default_config
      require("ibl").setup({
        -- Don't enable by default, so as to not distract with rainbow colors
        -- unless needed
        enabled = false,
        scope = { highlight = highlight },
        indent = {
          highlight = highlight,
          -- Use default char instead of following listchars
          char = default_config.indent.tab_char,
        },
      })

      -- Sync scope line color with rainbow-delimiters
      hooks.register(
        hooks.type.SCOPE_HIGHLIGHT,
        hooks.builtin.scope_highlight_from_extmark
      )
    end,
  },
}
