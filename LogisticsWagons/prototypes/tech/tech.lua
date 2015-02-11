data:extend(
{
  {
    type = "technology",
    name = "lw-logistic-wagons",
    icon = "__LogisticsWagons__/resources/icons/wagon-passive-provider.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "lw-cargo-wagon-passive"
      },
      {
        type = "unlock-recipe",
        recipe = "lw-cargo-wagon-active"
      },
      {
        type = "unlock-recipe",
        recipe = "lw-cargo-wagon-storage"
      },
	  {
        type = "unlock-recipe",
        recipe = "lw-cargo-wagon-requester"
      },
    },
    prerequisites = { "logistic-system"},
    unit = {
      count = 200,
      ingredients = {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1}
      },
      time = 30
    },
    order = "c-k-d-z",
  },
})