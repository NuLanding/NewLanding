/obj/item/wallframe
	icon = 'icons/obj/wallframe.dmi'
	custom_materials = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT*2)
	flags_1 = CONDUCT_1
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/result_path
	var/inverse = 0 // For inverse dir frames like light fixtures.
	var/pixel_shift //The amount of pixels

/obj/item/wallframe/proc/try_build(turf/on_wall, mob/user)
	if(get_dist(on_wall,user)>1)
		return
	var/ndir = get_dir(on_wall, user)
	if(!(ndir in GLOB.cardinals))
		return
	var/turf/T = get_turf(user)
	var/area/A = get_area(T)
	if(!isfloorturf(T))
		to_chat(user, SPAN_WARNING("You cannot place [src] on this spot!"))
		return
	if(A.always_unpowered)
		to_chat(user, SPAN_WARNING("You cannot place [src] in this area!"))
		return
	if(gotwallitem(T, ndir, inverse*2))
		to_chat(user, SPAN_WARNING("There's already an item on this wall!"))
		return

	return TRUE

/obj/item/wallframe/proc/attach(turf/on_wall, mob/user)
	if(result_path)
		playsound(src.loc, 'sound/machines/click.ogg', 75, TRUE)
		user.visible_message(SPAN_NOTICE("[user.name] attaches [src] to the wall."),
			SPAN_NOTICE("You attach [src] to the wall."),
			SPAN_HEAR("You hear clicking."))
		var/ndir = get_dir(on_wall,user)
		if(inverse)
			ndir = turn(ndir, 180)

		var/obj/O = new result_path(get_turf(user), ndir, TRUE)
		if(pixel_shift)
			switch(ndir)
				if(NORTH)
					O.pixel_y = pixel_shift
				if(SOUTH)
					O.pixel_y = -pixel_shift
				if(EAST)
					O.pixel_x = pixel_shift
				if(WEST)
					O.pixel_x = -pixel_shift
		after_attach(O)

	qdel(src)

/obj/item/wallframe/proc/after_attach(obj/O)
	transfer_fingerprints_to(O)

/obj/item/wallframe/attackby(obj/item/W, mob/user, params)
	..()
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		// For camera-building borgs
		var/turf/T = get_step(get_turf(user), user.dir)
		if(iswallturf(T))
			T.attackby(src, user, params)

	var/metal_amt = round(custom_materials[GET_MATERIAL_REF(/datum/material/iron)]/MINERAL_MATERIAL_AMOUNT) //Replace this shit later
	var/glass_amt = round(custom_materials[GET_MATERIAL_REF(/datum/material/glass)]/MINERAL_MATERIAL_AMOUNT) //Replace this shit later

	if(W.tool_behaviour == TOOL_WRENCH && (metal_amt || glass_amt))
		to_chat(user, SPAN_NOTICE("You dismantle [src]."))
		if(metal_amt)
			new /obj/item/stack/sheet/iron(get_turf(src), metal_amt)
		if(glass_amt)
			new /obj/item/stack/sheet/glass(get_turf(src), glass_amt)
		qdel(src)
