/datum/ore_node
	var/list/ores_to_mine
	var/range
	var/scanner_range
	var/x_coord
	var/y_coord
	var/z_coord
	var/has_attracted_fauna = FALSE

/datum/ore_node/New(x, y, z, list/ores, _range)
	x_coord = x
	y_coord = y
	z_coord = z
	ores_to_mine = ores
	range = _range
	scanner_range = range * 3
	//Add to the level list
	var/turf/located = locate(x,y,z)
	var/datum/virtual_level/vlevel = located.get_virtual_level()
	vlevel.ore_nodes += src

/datum/ore_node/Destroy()
	//Remove from the level list
	var/turf/located = locate(x_coord,y_coord,z_coord)
	var/datum/virtual_level/vlevel = located.get_virtual_level()
	vlevel.ore_nodes -= src
	return ..()

/datum/ore_node/proc/GetRemainingOreAmount()
	var/amount = 0
	for(var/path in ores_to_mine)
		amount += ores_to_mine[path]
	return amount

/datum/ore_node/proc/GetScannerReadout(turf/scanner_turf)
	//We read out ores based on the distance
	return ""

/datum/ore_node/proc/GetScannerDensity(turf/scanner_turf)
	var/turf/my_turf = locate(x_coord, y_coord, z_coord)
	var/dist = get_dist(my_turf,scanner_turf)
	if(dist <= 0)
		dist = 1
	var/percent = 1-(dist/scanner_range)
	var/total_density = 0
	for(var/i in ores_to_mine)
		total_density += ores_to_mine[i]
	total_density *= percent
	switch(total_density)
		if(-INFINITY to 10)
			. = METAL_DENSITY_NONE
		if(10 to 70)
			. = METAL_DENSITY_LOW
		if(70 to 150)
			. = METAL_DENSITY_MEDIUM
		if(150 to INFINITY)
			. = METAL_DENSITY_HIGH

/datum/ore_node/proc/AttractFauna()
	has_attracted_fauna = TRUE
	//TODO: do this
	return

/datum/ore_node/proc/TakeRandomOre()
	if(!length(ores_to_mine))
		return
	if(!has_attracted_fauna)
		AttractFauna()
	var/obj/item/ore_to_return
	var/type = pickweight(ores_to_mine)
	ores_to_mine[type] = ores_to_mine[type] - 1
	if(ores_to_mine[type] == 0)
		ores_to_mine -= type
	ore_to_return = new type()

	if(!length(ores_to_mine))
		qdel(src)
	return ore_to_return

/proc/GetNearbyOreNode(turf/T)
	var/datum/virtual_level/vlevel = T.get_virtual_level()
	if(!length(vlevel.ore_nodes))
		return
	var/list/iterated = vlevel.ore_nodes
	for(var/i in iterated)
		var/datum/ore_node/ON = i
		if(T.x < (ON.x_coord + ON.range) && T.x > (ON.x_coord - ON.range) && T.y < (ON.y_coord + ON.range) && T.y > (ON.y_coord - ON.range))
			return ON

/proc/GetOreNodeInScanRange(turf/T)
	var/datum/virtual_level/vlevel = T.get_virtual_level()
	if(!length(vlevel.ore_nodes))
		return
	var/list/iterated = vlevel.ore_nodes
	for(var/i in iterated)
		var/datum/ore_node/ON = i
		if(T.x < (ON.x_coord + ON.scanner_range) && T.x > (ON.x_coord - ON.scanner_range) && T.y < (ON.y_coord + ON.scanner_range) && T.y > (ON.y_coord - ON.scanner_range))
			return ON

/obj/effect/ore_node_spawner
	var/list/possible_ore_weight = list()
	var/ore_density = 4
	var/ore_variety = 5

/obj/effect/ore_node_spawner/generous
	ore_density = 6

/obj/effect/ore_node_spawner/scarce
	ore_density = 3

/obj/effect/ore_node_spawner/varied
	ore_variety = 8

/obj/effect/ore_node_spawner/proc/SeedVariables()
	return

/obj/effect/ore_node_spawner/proc/SeedDeviation()
	if(prob(50))
		ore_variety--
	else
		ore_variety++
	ore_variety = max(1, ore_variety)
	var/deviation = (rand(1,5)/10)
	if(prob(50))
		ore_density += deviation
	else
		ore_density -= deviation
	ore_density = max(1, ore_density)

/obj/effect/ore_node_spawner/Initialize()
	. = ..()
	SeedVariables()
	SeedDeviation()
	if(!length(possible_ore_weight))
		return INITIALIZE_HINT_QDEL
	var/compiled_list = list()
	for(var/i in 1 to ore_variety)
		if(!possible_ore_weight.len)
			break
		var/ore_type = pick(possible_ore_weight)
		var/ore_amount = possible_ore_weight[ore_type]
		possible_ore_weight -= ore_type
		compiled_list[ore_type] = round(ore_amount * ore_density)
	new /datum/ore_node(x, y, z, compiled_list, rand(5,8))
	return INITIALIZE_HINT_QDEL

/datum/ore_node_seeder
	var/list/spawners_weight = list(/obj/effect/ore_node_spawner = 100)
	var/spawners_amount = 6

/datum/ore_node_seeder/proc/SeedToLevel(datum/virtual_level/vlevel)
	for(var/i in 1 to spawners_amount)
		var/picked_type = pickweight(spawners_weight)
		var/turf/loc_to_spawn = locate(rand(vlevel.low_x,vlevel.high_x), rand(vlevel.low_y,vlevel.high_y), vlevel.z_value)
		new picked_type(loc_to_spawn)
