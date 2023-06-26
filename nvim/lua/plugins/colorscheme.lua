math.randomseed(os.time())

local t = os.date("*t")

local isDay = 6 <= t.hour and t.hour < 19

local daySchemes = {
  "zellner",
  "delek",
  "morning",
  "peachpuff",
  "shine",
  "tokyonight-day",
}

local nightSchemes = {
  "torte",
  "tokyonight-storm",
  "tokyonight-night",
  "tokyonight-moon",
  "tokyonight",
  "slate",
  "ron",
  "quiet",
  "pablo",
  "murphy",
  "lunaperche",
  "koehler",
  "industry",
  "habamax",
  "evening",
  "elflord",
  "desert",
  "default",
  "darkblue",
  "blue",
}

local schemesPool
if isDay then
  schemesPool = daySchemes
else
  schemesPool = nightSchemes
end

local chosenScheme = schemesPool[math.random(#schemesPool)]

return {
  "LazyVim/LazyVim",
  opts = {
    colorscheme = chosenScheme,
  },
}
