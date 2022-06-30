/**********************Light************************/

//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "Light emitter"
	anchored = TRUE
	invisibility = 101
	var/set_luminosity = 8
	var/set_cap = 0

/obj/effect/light_emitter/Initialize()
	. = ..()
	set_light(set_luminosity, set_cap)

/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	icon_state = "miningcar"
