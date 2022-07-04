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
