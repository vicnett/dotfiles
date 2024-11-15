return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Next change" } )

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Previous change" } )

          -- Actions
          map(
            "n",
            "<leader>hs",
            gitsigns.stage_hunk,
            { desc = "[h]unk [s]tage" }
          )
          map(
            "n",
            "<leader>hr",
            gitsigns.reset_hunk,
            { desc = "[h]unk [r]eset" }
          )
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "[h]unk [s]tage" })
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "[h]unk [r]eset" })
          map(
            "n",
            "<leader>hS",
            gitsigns.stage_buffer,
            { desc = "[h]unk [S]tage (entire buffer)" }
          )
          map(
            "n",
            "<leader>hu",
            gitsigns.undo_stage_hunk,
            { desc = "[h]unk [u]ndo stage" }
          )
          map(
            "n",
            "<leader>hR",
            gitsigns.reset_buffer,
            { desc = "[h]unk [R]eset (entire buffer)" }
          )
          map(
            "n",
            "<leader>hp",
            gitsigns.preview_hunk,
            { desc = "[h]unk [p]review" }
          )
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "[h]unk [b]lame" })
          map(
            "n",
            "<leader>tb",
            gitsigns.toggle_current_line_blame,
            { desc = "[t]oggle [b]lame (virtual text)" }
          )
          map("n", "<leader>hd", gitsigns.diffthis, { desc = "[h]unk [d]iff" })
          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, { desc = "[h]unk [D]iff (entire buffer)" })
          map(
            "n",
            "<leader>td",
            gitsigns.toggle_deleted,
            { desc = "[t]oggle show [d]iff (virtual text)" }
          )

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
}
