/obj/structure/cache/forage
	abstract_type = /obj/structure/cache/forage
	icon = 'icons/obj/structures/forage.dmi'
	anchored = TRUE
	density = TRUE
	pass_flags_self = PASSTABLE | LETPASSTHROW
	layer = TABLE_LAYER
	can_hide_items = FALSE
	search_time = 10 SECONDS
	hidden_items = null

	/// Forage Code

	/// Icon state to be used when the structure is foraged.
	var/foraged_icon_state
	/// Whether it is possible to forage by hand
	var/forage_by_hand = FALSE

	/// Whether it is possible to forage by tool.
	var/forage_by_tool = FALSE
	/// What tool is required to do a forage.
	var/required_tool

	/// How much time the user needs to spend to forage.
	var/forage_time = 3 SECONDS

	/// Lower bound of how much time until we regrow.
	var/regrow_time_low = 10 MINUTES
	/// Upper bound of how much time until we regrow.
	var/regrow_time_high = 20 MINUTES
	/// Whether we delete ourselves after we are foraged.
	var/one_time_forage = FALSE

	/// What type of item is foraged.
	var/result_type = /obj/item/grown/log
	/// How many of the item is foraged.
	var/result_amount = 1
	/// Internal state of whether the plant is foraged.
	var/foraged = FALSE

	/// Tree Code

	/// What stump will this tree turn into after being chopped down.
	var/stump_type = null
	/// What log will drop from the tree when its chopped down.
	var/log_type = null
	/// Progress towards chopping this down.
	var/chop_progress = null
	var/logs_to_drop = null
/*
	var/age
	var/health = 100
	var/harvest
	var/dead
	var/lastcycle
	var/cycledelay = 1200
	var/obj/item/seeds/myseed
	var/lastproduce
	var/growing_icon = 'icons/obj/hydroponics/growing.dmi'
	///The status of the plant
	var/plant_status = NO_PLANT

/obj/structure/cache/forage/proc/set_plant_status(new_plant_status)
	if(plant_status == new_plant_status)
		return
	SEND_SIGNAL(src, COMSIG_SET_PLANT_STATUS, new_plant_status)
	plant_status = new_plant_status

/obj/structure/cache/forage/process(delta_time)
	if(age > plant_status == PLANT_GROWING)
		if(myseed) // Unharvestable shouldn't be harvested
			set_plant_status(PLANT_HARVESTABLE)
		else
			lastproduce = age

/obj/structure/cache/forage/proc/update_icon_plant()
	var/mutable_appearance/plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	if(dead)
		plant_overlay.icon_state = myseed.icon_dead
	else if(harvest)
		if(!myseed.icon_harvest)
			plant_overlay.icon_state = "[myseed.icon_grow][myseed.growthstages]"
		else
			plant_overlay.icon_state = myseed.icon_harvest
	else
		var/t_growthstate = min(round((age / myseed.maturation) * myseed.growthstages), myseed.growthstages)
		plant_overlay.icon_state = "[myseed.icon_grow][t_growthstate]"
	add_overlay(plant_overlay)

/obj/structure/cache/forage/New(var/turf/turf,var/seed)
	if(!seed)
		return
	..(turf)
	myseed = new seed()
	if(!istype(myseed, /obj/item/seeds))
		qdel(myseed)
		return
	myseed.forceMove(src)
	name = myseed.plantname
	icon = myseed.growing_icon
	START_PROCESSING(SSobj, src)
	update_icon()
*/

// Foraged By Tool

/obj/structure/cache/forage/attackby(obj/item/tool, mob/user, params)
	if(foraged)
		return ..()
	if(forage_by_tool && tool.tool_behaviour == required_tool)
		user.visible_message(
			SPAN_NOTICE("[user] begins foraging from \the [src] with \the [tool]."),
			SPAN_NOTICE("You begin foraging \the [src] with \the [tool].")
			)
		if(tool.use_tool(src, user, forage_time, volume = 30))
			if(QDELETED(src) || foraged)
				return
			user.visible_message(
				SPAN_NOTICE("[user] forages from \the [src] with \the [tool]."),
				SPAN_NOTICE("You forage \the [src] with \the [tool].")
				)
			do_forage()
		return TRUE
	. = ..()

// Foraged By Hand

/obj/structure/cache/forage/attack_hand(mob/user, list/modifiers)
	if(foraged)
		return ..()
	if(forage_by_hand)
		user.visible_message(
			SPAN_NOTICE("[user] begins foraging from \the [src]."),
			SPAN_NOTICE("You begin foraging \the [src].")
			)
		if(do_after(user, forage_time, target = src))
			if(QDELETED(src) || foraged)
				return
			user.visible_message(
				SPAN_NOTICE("[user] forages from \the [src]."),
				SPAN_NOTICE("You forage \the [src].")
				)
			do_forage()
		return TRUE
	return ..()

/obj/structure/cache/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	return user_do_search(user)

// Do Forage Code

/obj/structure/cache/forage/proc/do_forage()
	if(foraged)
		return
	foraged = TRUE
	for(var/i in 1 to result_amount)
		new result_type(loc)
	if(one_time_forage)
		qdel(src)
	else
		addtimer(CALLBACK(src, .proc/regrow), rand(regrow_time_low, regrow_time_high))
		update_appearance()

// Change Icon when Foraged

/obj/structure/cache/forage/update_icon_state()
	. = ..()
	if(foraged)
		icon_state = foraged_icon_state
	else
		icon_state = base_icon_state

// Regrow Code

/obj/structure/cache/forage/proc/regrow()
	if(QDELETED(src))
		return
	foraged = FALSE
	update_appearance()
/*
/obj/structure/cache/forage/update_overlays()
	. = ..()
	if(myseed)
		. += update_plant_overlay()

/obj/structure/cache/forage/proc/update_plant_overlay()
	var/mutable_appearance/plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	switch(plant_status)
		if(PLANT_DEAD)
			plant_overlay.icon_state = myseed.icon_dead
		if(PLANT_HARVESTABLE)
			if(!myseed.icon_harvest)
				plant_overlay.icon_state = "[myseed.icon_grow][myseed.growthstages]"
			else
				plant_overlay.icon_state = myseed.icon_harvest
		else
			var/t_growthstate = clamp(round((age / myseed.maturation) * myseed.growthstages), 1, myseed.growthstages)
			plant_overlay.icon_state = "[myseed.icon_grow][t_growthstate]"
	return plant_overlay
*/

// Destroy Foragable

/obj/structure/cache/forage/proc/destroy()
	if(QDELETED(src))
		return
	foraged = FALSE
	update_appearance()

// Tree Code

// Chop Tree Down Code

/obj/structure/cache/forage/tree/attackby(obj/item/tool, mob/user, params)
	if(tool.tool_behaviour == TOOL_AXE)
		var/chopping_loop = TRUE
		to_chat(user, SPAN_NOTICE("You start chopping \the [src] down."))
		while(TRUE)
			if(tool.use_tool(src, user, 2 SECONDS, volume = 30))
				user.do_attack_animation(src)
				user.visible_message(
					SPAN_NOTICE("[user] chops \the [src] with \the [tool]."),
					SPAN_NOTICE("You chops \the [src] with \the [tool].")
					)
				add_chop_progress(rand(7,12))
				if(QDELETED(src))
					chopping_loop = FALSE
			else
				chopping_loop = FALSE
			if(!chopping_loop)
				to_chat(user, SPAN_NOTICE("You finish woodcutting."))
				break
		return TRUE
	return ..()

// Chop Progress Code

/obj/structure/cache/forage/tree/proc/add_chop_progress(progress)
	chop_progress += progress
	if(chop_progress >= 100)
		chop_down()

// Chop Final Result Code

/obj/structure/cache/forage/tree/proc/chop_down()
	visible_message(SPAN_WARNING("\The [src] falls down!"))
	var/fall_direction = pick(GLOB.cardinals_diagonals)
	var/turf/drop_turf = loc
	for(var/i in 1 to 2)
		var/turf/evaluate_turf = get_step(drop_turf, fall_direction)
		if(evaluate_turf && !evaluate_turf.density)
			drop_turf = evaluate_turf
		new log_type(drop_turf)
	new stump_type(loc)
	qdel(src)
