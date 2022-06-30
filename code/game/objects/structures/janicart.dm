/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "This is the alpha and omega of sanitation."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag
	var/obj/item/mop/mymop
	var/obj/item/pushbroom/mybroom
	var/obj/item/reagent_containers/spray/cleaner/myspray
	var/signs = 0
	var/max_signs = 4


/obj/structure/janitorialcart/Initialize()
	. = ..()
	create_reagents(100, OPENCONTAINER)

/obj/structure/janitorialcart/proc/wet_mop(obj/item/mop, mob/user)
	if(reagents.total_volume < 1)
		to_chat(user, SPAN_WARNING("[src] is out of water!"))
		return FALSE
	else
		var/obj/item/mop/M = mop
		reagents.trans_to(mop, M.mopcap, transfered_by = user)
		to_chat(user, SPAN_NOTICE("You wet [mop] in [src]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return TRUE

/obj/structure/janitorialcart/proc/put_in_cart(obj/item/I, mob/user)
	if(!user.transferItemToLoc(I, src))
		return
	to_chat(user, SPAN_NOTICE("You put [I] into [src]."))
	return


/obj/structure/janitorialcart/attackby(obj/item/I, mob/user, params)
	var/fail_msg = SPAN_WARNING("There is already one of those in [src]!")

	if(istype(I, /obj/item/mop))
		var/obj/item/mop/m=I
		if(m.reagents.total_volume < m.reagents.maximum_volume)
			if (wet_mop(m, user))
				return
		if(!mymop)
			m.janicart_insert(user, src)
		else
			to_chat(user, fail_msg)
	else if(istype(I, /obj/item/pushbroom))
		if(!mybroom)
			var/obj/item/pushbroom/b=I
			b.janicart_insert(user,src)
		else
			to_chat(user, fail_msg)
	else if(istype(I, /obj/item/storage/bag/trash))
		if(!mybag)
			var/obj/item/storage/bag/trash/t=I
			t.janicart_insert(user, src)
		else
			to_chat(user,  fail_msg)
	else if(istype(I, /obj/item/reagent_containers/spray/cleaner))
		if(!myspray)
			put_in_cart(I, user)
			myspray=I
			update_appearance()
		else
			to_chat(user, fail_msg)
	else if(mybag)
		mybag.attackby(I, user)
	else if(I.tool_behaviour == TOOL_CROWBAR)
		user.visible_message(SPAN_NOTICE("[user] begins to empty the contents of [src]."), SPAN_NOTICE("You begin to empty the contents of [src]..."))
		if(I.use_tool(src, user, 30))
			to_chat(usr, SPAN_NOTICE("You empty the contents of [src]'s bucket onto the floor."))
			reagents.expose(src.loc)
			src.reagents.clear_reagents()
	else
		return ..()

/obj/structure/janitorialcart/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	var/list/items = list()
	if(mybag)
		items += list("Trash bag" = image(icon = mybag.icon, icon_state = mybag.icon_state))
	if(mymop)
		items += list("Mop" = image(icon = mymop.icon, icon_state = mymop.icon_state))
	if(mybroom)
		items += list("Broom" = image(icon = mybroom.icon, icon_state = mybroom.icon_state))
	if(myspray)
		items += list("Spray bottle" = image(icon = myspray.icon, icon_state = myspray.icon_state))

	if(!length(items))
		return
	items = sortList(items)
	var/pick = show_radial_menu(user, src, items, custom_check = CALLBACK(src, .proc/check_menu, user), radius = 38, require_near = TRUE)
	if(!pick)
		return
	switch(pick)
		if("Trash bag")
			if(!mybag)
				return
			user.put_in_hands(mybag)
			to_chat(user, SPAN_NOTICE("You take [mybag] from [src]."))
			mybag = null
		if("Mop")
			if(!mymop)
				return
			user.put_in_hands(mymop)
			to_chat(user, SPAN_NOTICE("You take [mymop] from [src]."))
			mymop = null
		if("Broom")
			if(!mybroom)
				return
			user.put_in_hands(mybroom)
			to_chat(user, SPAN_NOTICE("You take [mybroom] from [src]."))
			mybroom = null
		if("Spray bottle")
			if(!myspray)
				return
			user.put_in_hands(myspray)
			to_chat(user, SPAN_NOTICE("You take [myspray] from [src]."))
			myspray = null
		else
			return

	update_appearance()

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/structure/janitorialcart/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/structure/janitorialcart/update_overlays()
	. = ..()
	if(mybag)
		. += "cart_garbage"
	if(mymop)
		. += "cart_mop"
	if(mybroom)
		. += "cart_broom"
	if(myspray)
		. += "cart_spray"
	if(signs)
		. += "cart_sign[signs]"
	if(reagents.total_volume > 0)
		. += "cart_water"
