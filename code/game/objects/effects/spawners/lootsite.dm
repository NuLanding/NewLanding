///this spawner usually spawns a boring crate, but has a chance to replace the crate with "loot crate" with a different loot table or a decorative site.
/obj/effect/loot_site_spawner
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "loot_site"
	///This is the loot table for the spawner. Try to make sure the weights add up to 1000, so it is easy to understand.
	var/list/loot_table = list()


/obj/effect/loot_site_spawner/Initialize()
	..()
	if(!length(loot_table))
		return INITIALIZE_HINT_QDEL

	var/spawned_object = pickweight(loot_table)
	new spawned_object(get_turf(src))

	return INITIALIZE_HINT_QDEL
