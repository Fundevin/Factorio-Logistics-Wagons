function logistics_stock_back_light()
  return
  {
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = {-0.6, 3.0},
      size = 2,
      intensity = 0.6
    },
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = {0.6, 3.0},
      size = 2,
      intensity = 0.6
    }
  }
end

function logistics_stock_stand_by_light()
  return
  {
    {
      minimum_darkness = 0.3,
      color = {b=1},
      shift = {-0.6, -3.0},
      size = 2,
      intensity = 0.5
    },
    {
      minimum_darkness = 0.3,
      color = {b=1},
      shift = {0.6, -3.0},
      size = 2,
      intensity = 0.5
    }
  }
end

data:extend(
{
  {
    type = "cargo-wagon",
    name = "lw-cargo-wagon-passive",
		icon = "__LogisticsWagons__/resources/icons/wagon-passive-provider.png",
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    inventory_size = 30,
    minable = {mining_time = 1, result = "lw-cargo-wagon-passive"},
    max_health = 600,
    corpse = "medium-remnants",
    mined_sound = {filename = "__core__/sound/deconstruct-medium.ogg"},
    dying_explosion = "huge-explosion",
    collision_box = {{-0.6, -2.4}, {0.6, 2.4}},
    selection_box = {{-0.7, -2.5}, {1, 2.5}},
    drawing_box = {{-10, -40}, {10, 40}},
    weight = 1000,
    max_speed = 1.5,
    braking_force = 3,
    friction_force = 0.0015,
    air_resistance = 0.002,
    connection_distance = 3.3,
    joint_distance = 4,
    energy_per_hit_point = 5,
    resistances =
    {
      {
        type = "fire",
        decrease = 15,
        percent = 50
      },
      {
        type = "physical",
        decrease = 15,
        percent = 30
      },
      {
        type = "impact",
        decrease = 50,
        percent = 60
      },
      {
        type = "explosion",
        decrease = 15,
        percent = 30
      },
      {
        type = "acid",
        decrease = 10,
        percent = 20
      }
    },
    back_light = logistics_stock_back_light(),
    stand_by_light = logistics_stock_stand_by_light(),
	pictures =
	{
		priority = "very-low",
		width = 285,
		height = 250,
		axially_symmetrical = false,
		direction_count = 256,
		filenames =
		{
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-0.png",
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-1.png",
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-2.png",
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-3.png",
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-4.png",
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-5.png",
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-6.png",
		"__LogisticsWagons__/resources/wagon-passive-provider/sprites-7.png"
		},
		line_length = 4,
		lines_per_file = 8,
		shift = {0.00, -0.60}
	},
    rail_category = "regular",
    drive_over_tie_trigger = drive_over_tie(),
    tie_distance = 50,
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/train-wheels.ogg",
        volume = 0.5
      },
      match_volume_to_activity = true,
    },
    crash_trigger = crash_trigger(),
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    sound_minimum_speed = 0.5;
  },
  
  {
    type = "cargo-wagon",
    name = "lw-cargo-wagon-active",
		icon = "__LogisticsWagons__/resources/icons/wagon-active-provider.png",
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    inventory_size = 30,
    minable = {mining_time = 1, result = "lw-cargo-wagon-active"},
    max_health = 600,
    corpse = "medium-remnants",
    mined_sound = {filename = "__core__/sound/deconstruct-medium.ogg"},
    dying_explosion = "huge-explosion",
    collision_box = {{-0.6, -2.4}, {0.6, 2.4}},
    selection_box = {{-0.7, -2.5}, {1, 2.5}},
    weight = 1000,
    max_speed = 1.5,
    braking_force = 3,
    friction_force = 0.0015,
    air_resistance = 0.002,
    connection_distance = 3.3,
    joint_distance = 4,
    energy_per_hit_point = 5,
    resistances =
    {
      {
        type = "fire",
        decrease = 15,
        percent = 50
      },
      {
        type = "physical",
        decrease = 15,
        percent = 30
      },
      {
        type = "impact",
        decrease = 50,
        percent = 60
      },
      {
        type = "explosion",
        decrease = 15,
        percent = 30
      },
      {
        type = "acid",
        decrease = 10,
        percent = 20
      }
    },
    back_light = logistics_stock_back_light(),
    stand_by_light = logistics_stock_stand_by_light(),
    pictures =
	{
		priority = "very-low",
		width = 285,
		height = 250,
		axially_symmetrical = false,
		direction_count = 256,
		filenames =
		{
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-0.png",
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-1.png",
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-2.png",
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-3.png",
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-4.png",
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-5.png",
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-6.png",
		"__LogisticsWagons__/resources/wagon-active-provider/sprites-7.png"
		},
		line_length = 4,
		lines_per_file = 8,
		shift = {0.00, -0.60}
	},
    rail_category = "regular",
    drive_over_tie_trigger = drive_over_tie(),
    tie_distance = 50,
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/train-wheels.ogg",
        volume = 0.5
      },
      match_volume_to_activity = true,
    },
    crash_trigger = crash_trigger(),
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    sound_minimum_speed = 0.5;
  },
  {
    type = "cargo-wagon",
    name = "lw-cargo-wagon-requester",
		icon = "__LogisticsWagons__/resources/icons/wagon-requester.png",
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    inventory_size = 30,
    minable = {mining_time = 1, result = "lw-cargo-wagon-requester"},
    max_health = 600,
    corpse = "medium-remnants",
    mined_sound = {filename = "__core__/sound/deconstruct-medium.ogg"},
    dying_explosion = "huge-explosion",
    collision_box = {{-0.6, -2.4}, {0.6, 2.4}},
    selection_box = {{-0.7, -2.5}, {1, 2.5}},
    weight = 1000,
    max_speed = 1.5,
    braking_force = 3,
    friction_force = 0.0015,
    air_resistance = 0.002,
    connection_distance = 3.3,
    joint_distance = 4,
    energy_per_hit_point = 5,
    resistances =
    {
      {
        type = "fire",
        decrease = 15,
        percent = 50
      },
      {
        type = "physical",
        decrease = 15,
        percent = 30
      },
      {
        type = "impact",
        decrease = 50,
        percent = 60
      },
      {
        type = "explosion",
        decrease = 15,
        percent = 30
      },
      {
        type = "acid",
        decrease = 10,
        percent = 20
      }
    },
    back_light = logistics_stock_back_light(),
    stand_by_light = logistics_stock_stand_by_light(),
    pictures =
	{
		priority = "very-low",
		width = 285,
		height = 250,
		axially_symmetrical = false,
		direction_count = 256,
		filenames =
		{
		"__LogisticsWagons__/resources/wagon-requester/sprites-0.png",
		"__LogisticsWagons__/resources/wagon-requester/sprites-1.png",
		"__LogisticsWagons__/resources/wagon-requester/sprites-2.png",
		"__LogisticsWagons__/resources/wagon-requester/sprites-3.png",
		"__LogisticsWagons__/resources/wagon-requester/sprites-4.png",
		"__LogisticsWagons__/resources/wagon-requester/sprites-5.png",
		"__LogisticsWagons__/resources/wagon-requester/sprites-6.png",
		"__LogisticsWagons__/resources/wagon-requester/sprites-7.png"
		},
		line_length = 4,
		lines_per_file = 8,
		shift = {0.00, -0.60}
	},
    rail_category = "regular",
    drive_over_tie_trigger = drive_over_tie(),
    tie_distance = 50,
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/train-wheels.ogg",
        volume = 0.5
      },
      match_volume_to_activity = true,
    },
    crash_trigger = crash_trigger(),
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    sound_minimum_speed = 0.5;
  },  
  {
    type = "cargo-wagon",
    name = "lw-cargo-wagon-storage",
		icon = "__LogisticsWagons__/resources/icons/wagon-storage.png",
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    inventory_size = 30,
    minable = {mining_time = 1, result = "lw-cargo-wagon-storage"},
    max_health = 600,
    corpse = "medium-remnants",
    mined_sound = {filename = "__core__/sound/deconstruct-medium.ogg"},
    dying_explosion = "huge-explosion",
    collision_box = {{-0.6, -2.4}, {0.6, 2.4}},
    selection_box = {{-0.7, -2.5}, {1, 2.5}},
    weight = 1000,
    max_speed = 1.5,
    braking_force = 3,
    friction_force = 0.0015,
    air_resistance = 0.002,
    connection_distance = 3.3,
    joint_distance = 4,
    energy_per_hit_point = 5,
    resistances =
    {
      {
        type = "fire",
        decrease = 15,
        percent = 50
      },
      {
        type = "physical",
        decrease = 15,
        percent = 30
      },
      {
        type = "impact",
        decrease = 50,
        percent = 60
      },
      {
        type = "explosion",
        decrease = 15,
        percent = 30
      },
      {
        type = "acid",
        decrease = 10,
        percent = 20
      }
    },
    back_light = logistics_stock_back_light(),
    stand_by_light = logistics_stock_stand_by_light(),
    pictures =
	{
		priority = "very-low",
		width = 285,
		height = 250,
		axially_symmetrical = false,
		direction_count = 256,
		filenames =
		{
		"__LogisticsWagons__/resources/wagon-storage/sprites-0.png",
		"__LogisticsWagons__/resources/wagon-storage/sprites-1.png",
		"__LogisticsWagons__/resources/wagon-storage/sprites-2.png",
		"__LogisticsWagons__/resources/wagon-storage/sprites-3.png",
		"__LogisticsWagons__/resources/wagon-storage/sprites-4.png",
		"__LogisticsWagons__/resources/wagon-storage/sprites-5.png",
		"__LogisticsWagons__/resources/wagon-storage/sprites-6.png",
		"__LogisticsWagons__/resources/wagon-storage/sprites-7.png"
		},
		line_length = 4,
		lines_per_file = 8,
		shift = {0.00, -0.60}
	},
    rail_category = "regular",
    drive_over_tie_trigger = drive_over_tie(),
    tie_distance = 50,
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/train-wheels.ogg",
        volume = 0.5
      },
      match_volume_to_activity = true,
    },
    crash_trigger = crash_trigger(),
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    sound_minimum_speed = 0.5;
  },  
  {
    type = "logistic-container",
    name = "lw-logistic-chest-passive-provider-trans",
    icon = "__LogisticsWagons__/resources/icons/trans-icon.png",
    flags = {"placeable-neutral", "placeable-off-grid"},
    --minable = {hardness = 1, mining_time = 1, result = "lw-logistic-chest-passive-provider"},
    max_health = 10000,
    --corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    --selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	collision_mask = { "ghost-layer"},
    fast_replaceable_group = "container",
    inventory_size = 30,
    logistic_mode = "passive-provider",
	order = "z",
    picture =
    {
      filename = "__LogisticsWagons__/resources/trans.png",
      priority = "very-low",
      width = 1,
      height = 1,
      shift = {0, 0}
    }
  }, 
  
  {
    type = "logistic-container",
    name = "lw-logistic-chest-storage-provider-trans",
    icon = "__LogisticsWagons__/resources/icons/trans-icon.png",
    flags = {"placeable-neutral", "placeable-off-grid"},
    --minable = {hardness = 1, mining_time = 1, result = "lw-logistic-chest-storage"},
    max_health = 10000,
    --corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    --selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	collision_mask = { "ghost-layer"},
    fast_replaceable_group = "container",
    inventory_size = 30,
    logistic_mode = "storage",
	order = "z",
    picture =
    {
      filename = "__LogisticsWagons__/resources/trans.png",
      priority = "very-low",
      width = 1,
      height = 1,
      shift = {0, 0}
    }
  }, 
 
   {
    type = "logistic-container",
    name = "lw-logistic-chest-active-provider-trans",
    icon = "__LogisticsWagons__/resources/icons/trans-icon.png",
    flags = {"placeable-neutral", "placeable-off-grid"},
    --minable = {hardness = 1, mining_time = 1, result = "lw-logistic-chest-active-provider"},
    max_health = 10000,
    --corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    --selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	collision_mask = { "ghost-layer"},
    fast_replaceable_group = "container",
    inventory_size = 30,
    logistic_mode = "active-provider",
	order = "z",
    picture =
    {
      filename = "__LogisticsWagons__/resources/trans.png",
      priority = "very-low",
      width = 1,
      height = 1,
      shift = {0, 0}
    }
  },
  {
    type = "logistic-container",
    name = "lw-logistic-chest-requester-trans",
    icon = "__LogisticsWagons__/resources/icons/trans-icon.png",
    flags = {"placeable-neutral", "placeable-off-grid"},
    --minable = {hardness = 0.2, mining_time = 0.5, result = "lw-logistic-chest-requester"},
    max_health = 10000,
    corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
	collision_mask = {"ghost-layer"},
    selection_box = {{-1, -1}, {1, 1}},
    fast_replaceable_group = "container",
    inventory_size = 30,
    logistic_mode = "requester",
	order = "z",
    picture =
    {
      filename = "__LogisticsWagons__/resources/trans.png",
      priority = "very-low",
      width = 1,
      height = 1,
      shift = {0, 0}
    }
  },
})