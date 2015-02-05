data:extend(
{
  {
    type = "recipe",
    name = "cargo-wagon-passive",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
	  {"logistic-chest-passive-provider", 1}
    },
    result = "cargo-wagon-passive"
  },
  
    {
    type = "recipe",
    name = "cargo-wagon-active",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
	  {"logistic-chest-active-provider", 1}
    },
    result = "cargo-wagon-active"
  },
	{
    type = "recipe",
    name = "cargo-wagon-storage",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
	  {"logistic-chest-storage", 1}
    },
    result = "cargo-wagon-storage"
  },
  
  {
    type = "recipe",
    name = "cargo-wagon-requester",
    enabled = "false", -- TESTING ONLY
    ingredients =
    {
      {"cargo-wagon", 1},
	  {"logistic-chest-requester", 1}
    },
    result = "cargo-wagon-requester"
  },
 })