data:extend(
{
	{
		type = "item-subgroup",
		name = "provider-wagons",
		group = "logistics",
		order = "z"
	},
	{
		type = "item",
		name = "cargo-wagon-passive",
		icon = "__LogisticsWagons__/resources/icons/wagon-passive-provider.png",
		flags = {"goes-to-quickbar"},
		subgroup = "provider-wagons",
		order = "w",
		place_result = "cargo-wagon-passive",
		stack_size = 5
	},
	{
		type = "item",
		name = "cargo-wagon-active",
		icon = "__LogisticsWagons__/resources/icons/wagon-active-provider.png",
		flags = {"goes-to-quickbar"},
		subgroup = "provider-wagons",
		order = "x",
		place_result = "cargo-wagon-active",
		stack_size = 5
	},
	{
		type = "item",
		name = "cargo-wagon-storage",
		icon = "__LogisticsWagons__/resources/icons/wagon-storage.png",
		flags = {"goes-to-quickbar"},
		subgroup = "provider-wagons",
		order = "y",
		place_result = "cargo-wagon-storage",
		stack_size = 5
	},
	{
		type = "item",
		name = "cargo-wagon-requester",
		icon = "__LogisticsWagons__/resources/icons/wagon-requester.png",
		flags = {"goes-to-quickbar"},
		subgroup = "provider-wagons",
		order = "y",
		place_result = "cargo-wagon-requester",
		stack_size = 5
	},
})