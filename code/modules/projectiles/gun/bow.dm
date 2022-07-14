/obj/item/gun/bow
	name = "bow"
	desc = "A wooden bow with a fine string."
	icon = 'icons/obj/items/gun/bow.dmi'
	icon_state = "bow"
	base_icon_state = "bow"
	worn_icon_state = "bow"
	projectile_type = /obj/projectile/arrow
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	firing_effect_type = null
	fire_sound = null
	var/drawn_state = "bow_drawn"
	var/arrow_state = "arrow"
	var/arrow_drawn_state = "arrow_drawn"
	var/arrow_loaded = FALSE
	var/drawn = FALSE

/obj/item/gun/bow/update_overlays()
	. = ..()
	if(arrow_loaded)
		if(drawn)
			. += mutable_appearance(icon, arrow_drawn_state)
		else
			. += mutable_appearance(icon, arrow_state)

/obj/item/gun/bow/update_icon_state()
	. = ..()
	if(drawn)
		icon_state = drawn_state
	else
		icon_state = base_icon_state

/obj/item/gun/bow/can_shoot()
	if(!drawn)
		return FALSE
	return ..()

/obj/item/gun/bow/after_projectile_fire()
	arrow_loaded = FALSE
	drawn = FALSE
	update_appearance()

/obj/item/gun/bow/attack_self(mob/living/user)
	if(drawn)
		user.visible_message(
			SPAN_NOTICE("[user] eases the string on \the [src]."),
			SPAN_NOTICE("You ease the string on \the [src].")
			)
		set_drawn_state(FALSE)
	else
		if(!arrow_loaded)
			to_chat(user, SPAN_WARNING("First load an arrow!"))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("[user] begins drawing an arrow on \the [src]."),
			SPAN_NOTICE("You begin to draw an arrow on \the [src].")
			)
		if(do_after(user, 3 SECONDS, target = user))
			if(QDELETED(src) || drawn || !arrow_loaded)
				return FALSE
			user.visible_message(
				SPAN_NOTICE("[user] draws an arrow on \the [src]."),
				SPAN_NOTICE("You draws an arrow on \the [src].")
				)
			set_drawn_state(TRUE)
	return TRUE

/obj/item/gun/bow/attackby(obj/item/item, mob/living/user, params)
	if(istype(item, /obj/item/stack/arrow))
		var/obj/item/stack/arrow/arrow = item
		/// Somewhat of a hacky check, but the equipment system is bad
		if(user.get_item_by_slot(ITEM_SLOT_BACK) == src)
			to_chat(user, SPAN_WARNING("Draw the bow first!"))
			return TRUE
		if(arrow_loaded)
			to_chat(user, SPAN_WARNING("There's already an arrow ready!"))
			return TRUE
		arrow.use(1)
		load_arrow()
		return TRUE
	return ..()

/obj/item/gun/bow/dropped(mob/user, silent = FALSE)
	. = ..()
	set_drawn_state(FALSE)
	drop_arrow()

/obj/item/gun/bow/equipped(mob/user, slot)
	. = ..()
	set_drawn_state(FALSE)
	drop_arrow()

/obj/item/gun/bow/proc/load_arrow()
	arrow_loaded = TRUE
	update_appearance()

/obj/item/gun/bow/proc/drop_arrow()
	if(!arrow_loaded)
		return
	arrow_loaded = FALSE
	new /obj/item/stack/arrow(get_turf(src), 1)
	update_appearance()

/obj/item/gun/bow/proc/set_drawn_state(new_state)
	if(drawn == new_state)
		return
	drawn = new_state
	update_appearance()
