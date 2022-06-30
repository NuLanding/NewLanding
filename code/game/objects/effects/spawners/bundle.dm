/obj/effect/spawner/bundle
	name = "bundle spawner"
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"

	var/list/items

/obj/effect/spawner/bundle/Initialize(mapload)
	..()
	if(items?.len)
		for(var/path in items)
			new path(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/bundle/hobo_squat
	name = "hobo squat spawner"
	items = list(/obj/structure/bed/maint,
				/obj/effect/spawner/scatter/grime,
				/obj/effect/spawner/lootdrop/maint_drugs)

/obj/effect/spawner/bundle/moisture_trap
	name = "moisture trap spawner"
	items = list(/obj/effect/spawner/scatter/moisture,
				/obj/structure/moisture_trap)
