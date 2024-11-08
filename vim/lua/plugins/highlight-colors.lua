return {
  {
    "brenoprata10/nvim-highlight-colors",
    lazy = false,
    config = function()
      require("nvim-highlight-colors").setup {
        render = 'virtual',
        enable_named_colors = false,
      }
    end
  },
}
