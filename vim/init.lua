vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Config files
require("config.general")
require("config.abbreviations")
require("config.formatting")
require("config.remaps")
require("config.visual")

-- Plugin manager
require("config.lazy")
