/obj/structure/door
	name = "door"
	desc = "It opens and closes - nothing out of the ordinary."
	icon = 'icons/obj/structures/doors.dmi'
	icon_state = "wood"
	base_icon_state = "wood"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	layer = CLOSED_DOOR_LAYER
	smoothing_groups = list(SMOOTH_GROUP_DOORS)
	var/open = FALSE
	var/target_open_state = FALSE
	var/switching_states = FALSE
	var/open_time = 0 SECONDS
	var/auto_close_by_bump = TRUE
	var/can_have_lock = TRUE
	var/opacity_when_closed = TRUE
	var/open_sound = 'sound/structure/door/door_open.ogg'
	var/close_sound = 'sound/structure/door/door_close.ogg'
	var/locked_sound = 'sound/structure/door/door_locked.ogg'
	var/obj/item/lock/lock
	var/lock_overlay = "door_lock"

/obj/structure/door/examine(mob/user)
	. = ..()
	if(lock)
		. += SPAN_NOTICE("There is a lock installed.")

/obj/structure/door/handle_atom_del(atom/A)
	if(A == lock)
		lock = null
		update_appearance()
	return ..()

/obj/structure/door/proc/install_lock(obj/item/lock/lock_item)
	if(lock)
		qdel(lock)
	lock = lock_item
	lock.moveToNullspace()
	lock.installed = src
	update_appearance()

/obj/structure/door/Destroy()
	if(lock)
		qdel(lock)
	return ..()

/obj/structure/door/update_icon_state()
	. = ..()
	if(switching_states)
		if(target_open_state)
			icon_state = "[base_icon_state]_opening"
		else
			icon_state = "[base_icon_state]_closing"
	else
		if(open)
			icon_state = "[base_icon_state]_open"
		else
			icon_state = base_icon_state

/obj/structure/door/update_overlays()
	. = ..()
	if(lock)
		. += lock_overlay

/obj/structure/door/Initialize()
	. = ..()
	set_state(open, TRUE)
	air_update_turf(TRUE, TRUE)

/obj/structure/door/Destroy()
	if(!open)
		air_update_turf(TRUE, FALSE)
	return ..()

/obj/structure/door/Bumped(atom/movable/AM)
	. = ..()
	if(!open && isliving(AM))
		user_switch_state(AM, TRUE)
		return TRUE

/obj/structure/door/attack_hand(mob/user, list/modifiers)
	. = ..()
	user_switch_state(user, FALSE)
	return TRUE

/obj/structure/door/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/lockpick))
		var/obj/item/lockpick/lockpick_item = W
		if(!lock)
			to_chat(user, SPAN_WARNING("\The [src] does not have a lock!"))
			return TRUE
		lock.attempt_lockpick(user, lockpick_item)
		return TRUE
	if(istype(W, /obj/item/lock))
		var/obj/item/lock/lock_item = W
		if(!can_have_lock)
			to_chat(user, SPAN_WARNING("You can't figure out how to install a lock on \the [src]."))
			return TRUE
		if(lock)
			to_chat(user, SPAN_WARNING("\The [src] already has a lock!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You install \the [lock_item] on \the [src]."))
		install_lock(lock_item)
		return TRUE
	if(istype(W, /obj/item/key))
		var/obj/item/key/key_item = W
		if(!lock)
			to_chat(user, SPAN_WARNING("\The [src] does not have a lock!"))
			return TRUE
		if(open)
			to_chat(user, SPAN_WARNING("Close \the [src] first!"))
			return TRUE
		lock.attempt_key_toggle(user, key_item)
		return TRUE
	return ..()

/obj/structure/door/proc/user_switch_state(mob/living/user, bump)
	if(try_switch_state())
		if(auto_close_by_bump && bump)
			var/try_time = open_time + rand(0.8 SECONDS, 1.2 SECONDS)
			addtimer(CALLBACK(src, /obj/structure/door/.proc/auto_close_loop), try_time)
	user.changeNext_move(CLICK_CD_MELEE)

/obj/structure/door/proc/try_switch_state(mob/living/user)
	if(switching_states)
		return FALSE
	if(open)
		var/turf/my_turf = get_turf(src)
		if(my_turf.is_blocked_turf())
			return FALSE
	if(lock && lock.locked)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		playsound(src, 'sound/structure/door/door_locked.ogg', 30, FALSE, FALSE)
		return FALSE
	if(!open && open_sound)
		playsound(src, open_sound, 30, FALSE, FALSE)
	if(open_time > 0)
		timed_set_state_start(!open)
	else
		set_state(!open)
	return TRUE

/obj/structure/door/proc/timed_set_state_start(target_state)
	if(switching_states)
		return
	switching_states = TRUE
	target_open_state = target_state
	if(target_open_state)
		set_opacity_state(target_open_state)
	set_density_state(target_open_state)
	update_appearance()
	addtimer(CALLBACK(src, /obj/structure/door/.proc/timed_set_state_finish), open_time)

/obj/structure/door/proc/timed_set_state_finish()
	if(!switching_states)
		return
	switching_states = FALSE
	set_state(target_open_state)

/obj/structure/door/proc/set_state(target_state, silent)
	open = target_state
	set_opacity_state(open)
	set_density_state(open)
	if(open)
		layer = OPEN_DOOR_LAYER
	else
		layer = CLOSED_DOOR_LAYER
	if(!silent && close_sound && !open)
		playsound(src, close_sound, 30, FALSE, FALSE)
	update_appearance()

/obj/structure/door/proc/set_opacity_state(target_state)
	if(target_state)
		opacity = FALSE
	else
		opacity = opacity_when_closed

/obj/structure/door/proc/set_density_state(target_state)
	density = !target_state

/obj/structure/door/proc/auto_close_loop(tries_remaining = 3)
	if(!open)
		return
	if(!try_switch_state())
		tries_remaining--
		if(tries_remaining <= 0)
			return
		addtimer(CALLBACK(src, /obj/structure/door/.proc/auto_close_loop, tries_remaining), 1 SECONDS)

/obj/structure/door/wood
	name = "wooden door"
	desc = "It opens and closes - nothing out of the ordinary."
	icon_state = "wood"
	base_icon_state = "wood"

/obj/structure/door/wood/sturdy
	name = "sturdy wooden door"
	desc = "It opens and closes - nothing out of the ordinary."
	icon_state = "sturdywood"
	base_icon_state = "sturdywood"

/obj/structure/door/iron
	name = "iron door"
	desc = "It opens and closes - nothing out of the ordinary."
	icon_state = "iron"
	base_icon_state = "iron"
	lock_overlay = "irondoor_lock"

/obj/structure/door/cell
	name = "cell door"
	desc = "It opens and closes - nothing out of the ordinary."
	icon_state = "cell"
	base_icon_state = "cell"
	opacity_when_closed = FALSE
