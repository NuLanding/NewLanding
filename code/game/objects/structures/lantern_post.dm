/obj/structure/lantern_post
	name = "lantern post"
	desc = "A lantern post."
	icon = 'icons/obj/structures/lantern_post.dmi'
	icon_state = "lantern_post"
	base_icon_state = "lantern_post"
	density = FALSE
	anchored = TRUE
	var/obj/item/lantern/lantern = null
	var/start_with_lantern = FALSE
	var/started_lantern_on = FALSE

/obj/structure/lantern_post/examine(mob/user)
	. = ..()
	if(lantern)
		. += SPAN_NOTICE("There is a lantern hanging from the post.")
		. += SPAN_NOTICE("Remove the lantern with left click.")
		. += SPAN_NOTICE("Toggle the lantern on/off with right click.")
	else
		. += SPAN_NOTICE("A lantern could be hanged from it.")

/obj/structure/lantern_post/update_overlays()
	. = ..()
	if(lantern)
		if(lantern.lit)
			. += mutable_appearance(icon, "[base_icon_state]_lamp_lit")
		else
			. += mutable_appearance(icon, "[base_icon_state]_lamp")

/obj/structure/lantern_post/Exited(atom/movable/gone, direction)
	if(gone == lantern)
		remove_lantern()
	return ..()

/obj/structure/lantern_post/Initialize(mapload)
	. = ..()
	if(start_with_lantern)
		var/obj/item/lantern/lamp = new /obj/item/lantern/full()
		add_lantern(lamp)
	if(started_lantern_on && lantern)
		lantern.set_lit_state(TRUE)

/obj/structure/lantern_post/Destroy()
	if(lantern)
		qdel(lantern)
	return ..()

/obj/structure/lantern_post/attackby(obj/item/item, mob/living/user, params)
	if(!lantern && istype(item, /obj/item/lantern))
		var/obj/item/lantern/lamp = item
		user.visible_message(
			SPAN_NOTICE("[user] hangs \the [lamp] on \the [src]."),
			SPAN_NOTICE("You hang \the [lamp] on \the [src].")
			)
		add_lantern(lamp)
		return TRUE
	return ..()

/obj/structure/lantern_post/attack_hand(mob/user, list/modifiers)
	if(lantern)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			lantern.user_toggle(user)
		else
			var/obj/item/lantern/lamp = lantern
			user.visible_message(
				SPAN_NOTICE("[user] removes \the [lamp] from \the [src]."),
				SPAN_NOTICE("You remove \the [lamp] from \the [src].")
				)
			remove_lantern()
			lamp.forceMove(loc)
			user.put_in_hands(lamp)
		return TRUE
	return ..()

/obj/structure/lantern_post/proc/add_lantern(obj/item/lantern/lamp)
	if(lantern != null)
		return
	lantern = lamp
	lantern.forceMove(src)
	lantern.post = src
	update_lantern()

/obj/structure/lantern_post/proc/remove_lantern()
	lantern.post = null
	lantern = null
	update_lantern()

/obj/structure/lantern_post/proc/update_lantern()
	update_appearance()

/obj/structure/lantern_post/lantern
	start_with_lantern = TRUE

/obj/structure/lantern_post/lantern_on
	start_with_lantern = TRUE
	started_lantern_on = TRUE

/obj/structure/lantern_post/directional
	icon_state = "lantern_post_dir"
	base_icon_state = "lantern_post_dir"

/obj/structure/lantern_post/directional/south
	dir = SOUTH

/obj/structure/lantern_post/directional/south/lantern
	start_with_lantern = TRUE

/obj/structure/lantern_post/directional/south/lantern_on
	start_with_lantern = TRUE
	started_lantern_on = TRUE

/obj/structure/lantern_post/directional/north
	dir = NORTH

/obj/structure/lantern_post/directional/north/lantern
	start_with_lantern = TRUE

/obj/structure/lantern_post/directional/north/lantern_on
	start_with_lantern = TRUE
	started_lantern_on = TRUE

/obj/structure/lantern_post/directional/west
	dir = WEST

/obj/structure/lantern_post/directional/west/lantern
	start_with_lantern = TRUE

/obj/structure/lantern_post/directional/west/lantern_on
	start_with_lantern = TRUE
	started_lantern_on = TRUE

/obj/structure/lantern_post/directional/east
	dir = EAST

/obj/structure/lantern_post/directional/east/lantern
	start_with_lantern = TRUE

/obj/structure/lantern_post/directional/east/lantern_on
	start_with_lantern = TRUE
	started_lantern_on = TRUE
