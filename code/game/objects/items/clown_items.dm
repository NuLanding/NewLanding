/* Clown Items
 * Contains:
 * Soap
 * Bike Horns
 * Air Horns
 * Canned Laughter
 */

/*
 * Soap
 */

/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "soap"
	inhand_icon = 'icons/mob/inhands/equipment/custodial_inhand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	grind_results = list(/datum/reagent/lye = 10)
	var/cleanspeed = 35 //slower than mop
	force_string = "robust... against germs"
	var/uses = 100

/obj/item/soap/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 80)

/obj/item/soap/examine(mob/user)
	. = ..()
	var/max_uses = initial(uses)
	var/msg = "It looks like it just came out of the package."
	if(uses != max_uses)
		var/percentage_left = uses / max_uses
		switch(percentage_left)
			if(0 to 0.15)
				msg = "There's just a tiny bit left of what it used to be, you're not sure it'll last much longer."
			if(0.15 to 0.30)
				msg = "It's dissolved quite a bit, but there's still some life to it."
			if(0.30 to 0.50)
				msg = "It's past its prime, but it's definitely still good."
			if(0.50 to 0.75)
				msg = "It's started to get a little smaller than it used to be, but it'll definitely still last for a while."
			else
				msg = "It's seen some light use, but it's still pretty fresh."
	. += SPAN_NOTICE("[msg]")

/obj/item/soap/suicide_act(mob/user)
	user.say(";FFFFFFFFFFFFFFFFUUUUUUUDGE!!", forced="soap suicide")
	user.visible_message(SPAN_SUICIDE("[user] lifts [src] to [user.p_their()] mouth and gnaws on it furiously, producing a thick froth! [user.p_they(TRUE)]'ll never get that BB gun now!"))
	new /obj/effect/particle_effect/foam(loc)
	return (TOXLOSS)

/**
 * Decrease the number of uses the bar of soap has.
 *
 * The higher the cleaning skill, the less likely the soap will lose a use.
 * Arguments
 * * user - The mob that is using the soap to clean.
 */
/obj/item/soap/proc/decreaseUses(mob/user)
	uses--
	if(uses <= 0)
		to_chat(user, SPAN_WARNING("[src] crumbles into tiny bits!"))
		qdel(src)

/obj/item/soap/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !check_allowed_items(target))
		return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && ((target in user.client.screen) && !user.is_holding(target)))
		to_chat(user, SPAN_WARNING("You need to take that [target.name] off before cleaning it!"))
	else if(istype(target, /obj/effect/decal/cleanable))
		user.visible_message(SPAN_NOTICE("[user] begins to scrub \the [target.name] out with [src]."), SPAN_WARNING("You begin to scrub \the [target.name] out with [src]..."))
		if(do_after(user, cleanspeed, target = target))
			to_chat(user, SPAN_NOTICE("You scrub \the [target.name] out."))
			qdel(target)
			decreaseUses(user)

	else if(ishuman(target) && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/mob/living/carbon/human/human_user = user
		user.visible_message(SPAN_WARNING("\the [user] washes \the [target]'s mouth out with [src.name]!"), SPAN_NOTICE("You wash \the [target]'s mouth out with [src.name]!")) //washes mouth out with soap sounds better than 'the soap' here if(user.zone_selected == "mouth")
		if(human_user.lip_style)
			human_user.update_lips(null)
		decreaseUses(user)
		return
	else if(istype(target, /obj/structure/window))
		user.visible_message(SPAN_NOTICE("[user] begins to clean \the [target.name] with [src]..."), SPAN_NOTICE("You begin to clean \the [target.name] with [src]..."))
		if(do_after(user, cleanspeed, target = target))
			to_chat(user, SPAN_NOTICE("You clean \the [target.name]."))
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.set_opacity(initial(target.opacity))
			decreaseUses(user)
	else
		user.visible_message(SPAN_NOTICE("[user] begins to clean \the [target.name] with [src]..."), SPAN_NOTICE("You begin to clean \the [target.name] with [src]..."))
		if(do_after(user, cleanspeed, target = target))
			to_chat(user, SPAN_NOTICE("You clean \the [target.name]."))
			target.wash(CLEAN_SCRUB)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			decreaseUses(user)
	return

