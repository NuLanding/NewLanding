///This spawner scatters the spawned stuff around where it is placed.
/obj/effect/spawner/scatter
	///determines how many things to scatter
	var/max_spawns = 3
	///determines how big of a range we should scatter things in.
	var/radius = 2
	///This weighted list acts as the loot table for the spawner
	var/list/loot_table

/obj/effect/spawner/scatter/Initialize()
	..()
	if(!length(loot_table))
		return INITIALIZE_HINT_QDEL

	var/list/candidate_locations = list()

	for(var/turf/turf_in_view in oview(radius, get_turf(src)))
		if(!turf_in_view.density)

			candidate_locations += turf_in_view

	if(!candidate_locations.len)
		return INITIALIZE_HINT_QDEL

	var/loot_spawned = 0
	while((max_spawns-loot_spawned) && candidate_locations.len)
		var/spawned_thing = pickweight(loot_table)
		while(islist(spawned_thing))
			spawned_thing = pickweight(spawned_thing)
		new spawned_thing(pick_n_take(candidate_locations))
		loot_spawned++

	return INITIALIZE_HINT_QDEL
