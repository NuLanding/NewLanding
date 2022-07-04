/obj/effect/spawner/lootdrop
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"
	layer = OBJ_LAYER
	var/lootcount = 1 //how many items will be spawned
	var/lootdoubles = TRUE //if the same item can be spawned twice
	var/list/loot //a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)
	var/fan_out_items = FALSE //Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself

/obj/effect/spawner/lootdrop/Initialize(mapload)
	..()
	if(loot?.len)
		var/loot_spawned = 0
		while((lootcount-loot_spawned) && loot.len)
			var/lootspawn = pickweight(fill_with_ones(loot))
			while(islist(lootspawn))
				lootspawn = pickweight(fill_with_ones(lootspawn))
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				var/atom/movable/spawned_loot = new lootspawn(loc)
				if (!fan_out_items)
					if (pixel_x != 0)
						spawned_loot.pixel_x = pixel_x
					if (pixel_y != 0)
						spawned_loot.pixel_y = pixel_y
				else
					if (loot_spawned)
						spawned_loot.pixel_x = spawned_loot.pixel_y = ((!(loot_spawned%2)*loot_spawned/2)*-1)+((loot_spawned%2)*(loot_spawned+1)/2*1)
			loot_spawned++
	return INITIALIZE_HINT_QDEL


// Lets loot tables be both list(a, b, c), as well as list(a = 3, b = 2, c = 2)
/proc/fill_with_ones(list/table)
	if (!islist(table))
		return table

	var/list/final_table = list()

	for (var/key in table)
		if (table[key])
			final_table[key] = table[key]
		else
			final_table[key] = 1

	return final_table
