return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "sql",
        "tmux",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
      ignore_install = {
        "csv",
        "psv",
        "tsv",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
