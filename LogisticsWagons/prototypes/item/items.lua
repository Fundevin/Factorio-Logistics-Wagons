data:extend(
{
	{
		type = "item-subgroup",
		name = "lw-provider-wagons",
		group = "logistics",
		order = "z"
	},
	{
		type = "item",
		name = "lw-cargo-wagon-passive",
		icon = "__LogisticsWagons__/resources/icons/wagon-passive-provider.png",
		flags = {"goes-to-quickbar"},
		subgroup = "lw-provider-wagons",
		order = "w",
		place_result = "lw-cargo-wagon-passive",
		stack_size = 5
	},
	{
		type = "item",
		name = "lw-cargo-wagon-active",
		icon = "__LogisticsWagons__/resources/icons/wagon-active-provider.png",
		flags = {"goes-to-quickbar"},
		subgroup = "lw-provider-wagons",
		order = "x",
		place_result = "lw-cargo-wagon-active",
		stack_size = 5
	},
	{
		type = "item",
		name = "lw-cargo-wagon-storage",
		icon = "__LogisticsWagons__/resources/icons/wagon-storage.png",
		flags = {"goes-to-quickbar"},
		subgroup = "lw-provider-wagons",
		order = "y",
		place_result = "lw-cargo-wagon-storage",
		stack_size = 5
	},
	{
		type = "item",
		name = "lw-cargo-wagon-requester",
		icon = "__LogisticsWagons__/resources/icons/wagon-requester.png",
		flags = {"goes-to-quickbar"},
		subgroup = "lw-provider-wagons",
		order = "y",
		place_result = "lw-cargo-wagon-requester",
		stack_size = 5
	},
})