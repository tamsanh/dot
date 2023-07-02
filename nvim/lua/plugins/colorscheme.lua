math.randomseed(os.time())

local t = os.date("*t")

local isDay = 6 <= t.hour and t.hour < 19

local daySchemes = {
  "OceanNextLight",
  "blue",
  "catppuccin-latte",
  "dawnfox",
  "dayfox",
  -- "delek", --
  "kanagawa-lotus",
  "material",
  "material-lighter",
  "material-oceanic",
  -- "morning", --
  "nord",
  "nordfox",
  "peachpuff",
  "shine",
  "terafox",
  "tokyonight-day",
  "zellner",
}

local nightSchemes = {
  "OceanNext",
  "catppuccin",
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-mocha",
  -- "darkblue", --
  -- "default", --
  "desert",
  "dracula",
  "duskfox",
  "edge",
  "elflord",
  "evening",
  "everforest",
  "falcon",
  "github_dark_tritanopia",
  "github_dimmed",
  "gruvbox",
  "habamax",
  "industry",
  "kanagawa",
  "kanagawa-dragon",
  "kanagawa-wave",
  -- "koehler", --
  "lunaperche",
  "material-darker",
  "material-deep-ocean",
  "material-palenight",
  "melange",
  "murphy",
  "nightfly",
  "nightfox",
  "oxocarbon",
  "pablo",
  -- "quiet", --
  "ron",
  "slate",
  "tokyonight",
  "tokyonight-moon",
  "tokyonight-night",
  "tokyonight-storm",
  -- "torte", --
}

local schemesPool = nightSchemes
if isDay then
  for I = 1, #daySchemes do
    schemesPool[#schemesPool + 1] = daySchemes[I]
  end
end

local chosenScheme = schemesPool[math.random(#schemesPool)]

return {
  { "EdenEast/nightfox.nvim", lazy = false },
  { "bluz71/vim-nightfly-colors", lazy = false },
  { "catppuccin/nvim", lazy = false },
  { "dracula/vim", lazy = false },
  { "ellisonleao/gruvbox.nvim", lazy = false },
  { "fenetikm/falcon", lazy = false },
  { "folke/tokyonight.nvim", lazy = false },
  { "marko-cerovac/material.nvim", lazy = false },
  { "mhartington/oceanic-next", lazy = false },
  { "nyoom-engineering/oxocarbon.nvim", lazy = false },
  { "projekt0n/github-nvim-theme", lazy = false },
  { "rebelot/kanagawa.nvim", lazy = false },
  { "sainnhe/edge", lazy = false },
  { "sainnhe/everforest", lazy = false },
  { "savq/melange-nvim", lazy = false },
  { "shaunsingh/nord.nvim", lazy = false },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = chosenScheme,
    },
  },
}
