// Populate the space level list and prepare space transitions
/datum/controller/subsystem/mapping/proc/InitializeDefaultZLevels()
	if (z_list)  // subsystem/Recover or badminnery, no need
		return

	z_list = list()
	var/list/default_map_traits = DEFAULT_MAP_TRAITS

	if (default_map_traits.len != world.maxz)
		WARNING("More or less map attributes pre-defined ([default_map_traits.len]) than existent z-levels ([world.maxz]). Ignoring the larger.")
		if (default_map_traits.len > world.maxz)
			default_map_traits.Cut(world.maxz + 1)

	// Load the "Start" zones
	LoadGroup(
		null,
		"Start",
		"map_files/generic",
		"start.dmm",
		default_map_traits,
		default_map_traits,
		silent = TRUE,
	)

/// Adds new physical space level. DO NOT USE THIS TO LOAD SOMETHING NEW. SSmapping.get_free_allocation() will create any levels nessecary and pass you coordinates to create a new virtual level
/datum/controller/subsystem/mapping/proc/add_new_zlevel(name, allocation_type)
	UNTIL(!adding_new_zlevel)
	adding_new_zlevel = TRUE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_Z, args)
	var/new_z = z_list.len + 1
	if (world.maxz < new_z)
		world.incrementMaxZ()
		CHECK_TICK
	// TODO: sleep here if the Z level needs to be cleared
	var/datum/space_level/S = new /datum/space_level(new_z, name, allocation_type)
	z_list += S

	/// Initialize the turfs on the new space level
	if(SSatoms.initialized != INITIALIZATION_INSSATOMS)
		SSatoms.InitializeAtoms(block(locate(1,1,world.maxz), locate(world.maxx,world.maxy,world.maxz)))

	adding_new_zlevel = FALSE
	return S

/datum/controller/subsystem/mapping/proc/get_level(z)
	if (z_list && z >= 1 && z <= z_list.len)
		return z_list[z]
	CRASH("Unmanaged z-level [z]! maxz = [world.maxz], z_list.len = [z_list ? z_list.len : "null"]")
