#define MAX_OIL_AMT 50
#define MINIMUM_OIL_TO_RUN 5
#define SECONDS_PER_OIL 40

/obj/item/lantern
	name = "lantern"
	desc = "A brass lantern with some ignition mechanism. It seems to run off of oil."
	icon = 'icons/obj/items/lantern.dmi'
	icon_state = "lantern"
	base_icon_state = "lantern"
	w_class = WEIGHT_CLASS_NORMAL
	light_color = LIGHT_COLOR_ORANGE
	slot_flags = ITEM_SLOT_BELT
	var/lit = FALSE
	var/oil_remaining = 0
	var/obj/structure/lantern_post/post

/obj/item/lantern/update_icon_state()
	. = ..()
	if(lit)
		icon_state = "[base_icon_state]_on"
	else
		icon_state = base_icon_state

/obj/item/lantern/Moved(atom/OldLoc, Dir)
	. = ..()
	if(post && loc != post)
		post.remove_lantern()

/obj/item/lantern/attack_self(mob/user)
	user_toggle(user)
	return TRUE

/obj/item/lantern/proc/user_toggle(mob/user)
	if(!lit)
		if(can_ignite())
			playsound(user, 'sound/weapons/magin.ogg', 40, TRUE)
			to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
			set_lit_state(TRUE)
		else
			to_chat(user, SPAN_WARNING("\The [src] has insufficient oil!"))
	else
		playsound(user, 'sound/weapons/magout.ogg', 40, TRUE)
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
		set_lit_state(FALSE)

/obj/item/lantern/Destroy()
	set_lit_state(FALSE)
	return ..()

/obj/item/lantern/process(delta_time)
	oil_remaining -= delta_time / SECONDS_PER_OIL
	if(!can_ignite())
		set_lit_state(FALSE)

/obj/item/lantern/proc/can_ignite()
	if(oil_remaining >= MINIMUM_OIL_TO_RUN)
		return TRUE
	return FALSE

/obj/item/lantern/proc/set_lit_state(new_state)
	if(lit == new_state)
		return
	lit = new_state
	if(lit)
		set_light(5, 1.5)
		START_PROCESSING(SSobj, src)
	else
		set_light(0)
		STOP_PROCESSING(SSobj, src)
	update_appearance()
	if(post)
		post.update_lantern()

/obj/item/lantern/full
	oil_remaining = MAX_OIL_AMT

#undef MAX_OIL_AMT
#undef MINIMUM_OIL_TO_RUN
#undef SECONDS_PER_OIL
