return {
  {
    -- A session manager
    "olimorris/persisted.nvim",
    lazy = false, -- make sure the plugin is always loaded at startup
    opts = {
      autostart = false,
      use_git_branch = true,
    },
    config = true
  },

  -- Colorschemes
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000,
  },
  {
    "drewtempelmeyer/palenight.vim",
    priority = 1000,
  },
  {
    "eldritch-theme/eldritch.nvim",
    priority = 1000,
    opts = {},
  },
  {
    "embark-theme/vim",
    name = "embark",
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "sainnhe/everforest",
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
  },
  {
    "uhs-robert/oasis.nvim",
    priority = 1000,
  },
}
