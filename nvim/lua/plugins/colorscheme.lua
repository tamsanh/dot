math.randomseed(os.time())

local t = os.date("*t")

local isDay = 6 <= t.hour and t.hour < 19

local daySchemes = {
  "blue",
  -- "delek",
  -- "morning",
  "peachpuff",
  "shine",
  "tokyonight-day",
  "zellner",
}

local nightSchemes = {
  "catppuccin",
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-mocha",
  "darkblue",
  -- "default",
  "desert",
  "elflord",
  "evening",
  "habamax",
  "industry",
  "kanagawa",
  -- "koehler",
  "lunaperche",
  "murphy",
  "oxocarbon",
  "pablo",
  -- "quiet",
  "ron",
  "slate",
  "tokyonight",
  "tokyonight-moon",
  "tokyonight-night",
  "tokyonight-storm",
  -- "torte",
}

local schemesPool = nightSchemes
if isDay then
  for I = 1, #daySchemes do
    schemesPool[#schemesPool + 1] = daySchemes[I]
  end
end

local chosenScheme = schemesPool[math.random(#schemesPool)]

return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
  },
  {
    "savq/melange-nvim",
    lazy = false,
  },
  {
    "catppuccin/nvim",
    lazy = false,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = chosenScheme,
    },
  },
}
