//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/mob/living/carbon/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/final_pixel_y = pixel_y
	var/final_dir = dir
	var/changed = 0
	if(lying_angle != lying_prev && rotate_on_lying)
		changed++
		ntransform.TurnTo(lying_prev , lying_angle)
		if(!lying_angle) //Lying to standing
			final_pixel_y = base_pixel_y
		else //if(lying != 0)
			if(lying_prev == 0) //Standing to lying
				pixel_y = base_pixel_y
				final_pixel_y = base_pixel_y + PIXEL_Y_OFFSET_LYING
				if(dir & (EAST|WEST)) //Facing east or west
					final_dir = pick(NORTH, SOUTH) //So you fall on your side rather than your face or ass
	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		SEND_SIGNAL(src, COMSIG_PAUSE_FLOATING_ANIM, 0.3 SECONDS)
		animate(src, transform = ntransform, time = (lying_prev == 0 || lying_angle == 0) ? 2 : 0, pixel_y = final_pixel_y, dir = final_dir, easing = (EASE_IN|EASE_OUT))

/mob/living/carbon
	var/list/overlays_standing[TOTAL_LAYERS]

/mob/living/carbon/proc/apply_overlay(cache_index)
	if((. = overlays_standing[cache_index]))
		add_overlay(.)

/mob/living/carbon/proc/remove_overlay(cache_index)
	var/I = overlays_standing[cache_index]
	if(I)
		cut_overlay(I)
		overlays_standing[cache_index] = null

/mob/living/carbon/regenerate_icons()
	if(notransform)
		return 1
	update_inv_hands()
	update_inv_handcuffed()
	update_inv_legcuffed()
	update_fire()


/mob/living/carbon/update_inv_hands()
	remove_overlay(HANDS_LAYER)
	if (handcuffed)
		drop_all_held_items()
		return

	var/list/hands = list()
	for(var/obj/item/I in held_items)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			I.screen_loc = ui_hand_position(get_held_index_of_item(I))
			client.screen += I
			if(observers?.len)
				for(var/M in observers)
					var/mob/dead/observe = M
					if(observe.client && observe.client.eye == src)
						observe.client.screen += I
					else
						observers -= observe
						if(!observers.len)
							observers = null
							break

		var/icon_file = I.lefthand_file
		if(get_held_index_of_item(I) % 2 == 0)
			icon_file = I.righthand_file

		hands += I.build_worn_icon(default_layer = HANDS_LAYER, default_icon_file = icon_file, isinhands = TRUE, wearer = src)

	overlays_standing[HANDS_LAYER] = hands
	apply_overlay(HANDS_LAYER)


/mob/living/carbon/update_fire(fire_icon = "Generic_mob_burning")
	remove_overlay(FIRE_LAYER)
	if(on_fire || HAS_TRAIT(src, TRAIT_PERMANENTLY_ONFIRE))
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
		new_fire_overlay.appearance_flags = RESET_COLOR
		overlays_standing[FIRE_LAYER] = new_fire_overlay

	apply_overlay(FIRE_LAYER)

/mob/living/carbon/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)

	var/mutable_appearance/damage_overlay = mutable_appearance('icons/mob/dam_mob.dmi', "blank", -DAMAGE_LAYER)
	overlays_standing[DAMAGE_LAYER] = damage_overlay

	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.dmg_overlay_type)
			if(BP.brutestate)
				damage_overlay.add_overlay("[BP.dmg_overlay_type]_[BP.body_zone]_[BP.brutestate]0") //we're adding icon_states of the base image as overlays
			if(BP.burnstate)
				damage_overlay.add_overlay("[BP.dmg_overlay_type]_[BP.body_zone]_0[BP.burnstate]")

	apply_overlay(DAMAGE_LAYER)


/mob/living/carbon/update_inv_wear_mask()
	remove_overlay(FACEMASK_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1]
		inv.update_appearance()

	if(wear_mask)
		if(!(ITEM_SLOT_MASK in check_obscured_slots()))
			overlays_standing[FACEMASK_LAYER] = wear_mask.build_worn_icon(default_layer = FACEMASK_LAYER, default_icon_file = 'icons/mob/clothing/mask/mask.dmi', wearer = src, slot = ITEM_SLOT_MASK)
		update_hud_wear_mask(wear_mask)

	apply_overlay(FACEMASK_LAYER)

/mob/living/carbon/update_inv_neck()
	remove_overlay(NECK_LAYER)

	if(client && hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1]
		inv.update_appearance()

	if(wear_neck)
		if(!(check_obscured_slots() & ITEM_SLOT_NECK))
			overlays_standing[NECK_LAYER] = wear_neck.build_worn_icon(default_layer = NECK_LAYER, default_icon_file = 'icons/mob/clothing/neck/neck.dmi', wearer = src, slot = ITEM_SLOT_NECK)
		update_hud_neck(wear_neck)

	apply_overlay(NECK_LAYER)

/mob/living/carbon/update_inv_back()
	remove_overlay(BACK_LAYER)

	if(client && hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1]
		inv.update_appearance()

	if(back)
		overlays_standing[BACK_LAYER] = back.build_worn_icon(default_layer = BACK_LAYER, default_icon_file = 'icons/mob/clothing/back/back.dmi', wearer = src, slot = ITEM_SLOT_BACK)
		update_hud_back(back)

	apply_overlay(BACK_LAYER)

/mob/living/carbon/update_inv_head()
	remove_overlay(HEAD_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used && hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_HEAD) + 1]
		inv.update_appearance()

	if(head)
		overlays_standing[HEAD_LAYER] = head.build_worn_icon(default_layer = HEAD_LAYER, default_icon_file = 'icons/mob/clothing/head/head.dmi', wearer = src, slot = ITEM_SLOT_HEAD)
		update_hud_head(head)

	apply_overlay(HEAD_LAYER)


/mob/living/carbon/update_inv_handcuffed()
	remove_overlay(HANDCUFF_LAYER)
	if(handcuffed)
		var/mutable_appearance/handcuff_overlay = mutable_appearance('icons/mob/mob.dmi', "handcuff1", -HANDCUFF_LAYER)
		if(handcuffed.blocks_emissive)
			handcuff_overlay.overlays += emissive_blocker(handcuff_overlay.icon, handcuff_overlay.icon_state, alpha = handcuff_overlay.alpha)

		overlays_standing[HANDCUFF_LAYER] = handcuff_overlay
		apply_overlay(HANDCUFF_LAYER)


//mob HUD updates for items in our inventory

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(hud_used)
		for(var/hand in hud_used.hand_slots)
			var/atom/movable/screen/inventory/hand/H = hud_used.hand_slots[hand]
			if(H)
				H.update_appearance()

//update whether our head item appears on our hud.
/mob/living/carbon/proc/update_hud_head(obj/item/I)
	return

//update whether our mask item appears on our hud.
/mob/living/carbon/proc/update_hud_wear_mask(obj/item/I)
	return

//update whether our neck item appears on our hud.
/mob/living/carbon/proc/update_hud_neck(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_back(obj/item/I)
	return



//Overlays for the worn overlay so you can overlay while you overlay
//eg: ammo counters, primed grenade flashing, etc.
//"icon_file" is used automatically for inhands etc. to make sure it gets the right inhand file
/obj/item/proc/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file, bodytype = BODYTYPE_HUMANOID, slot, worn_state, worn_prefix, list/accessory_offsets)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	. = list()
	if(!blocks_emissive)
		return

	. += emissive_blocker(standing.icon, standing.icon_state, alpha = standing.alpha)

/mob/living/carbon/update_body()
	update_body_parts()

/mob/living/carbon/proc/assign_bodypart_ownership()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		BP.original_owner = WEAKREF(src)

/mob/living/carbon/proc/update_body_parts()
	//CHECK FOR UPDATE
	//var/oldkey = icon_render_key
	//icon_render_key = generate_icon_render_key()
	//if(oldkey == icon_render_key)
	//	return

	remove_overlay(BODYPARTS_LAYER)

	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		BP.update_limb()

	//LOAD ICONS
	if(limb_icon_cache[icon_render_key])
		load_limb_from_cache()
		return

	var/is_taur = FALSE

	//GENERATE NEW LIMBS
	var/list/new_limbs = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(is_taur && (BP.body_part == LEG_LEFT || BP.body_part == LEG_RIGHT))
			continue

		new_limbs += BP.get_limb_icon()
	if(new_limbs.len)
		overlays_standing[BODYPARTS_LAYER] = new_limbs
		limb_icon_cache[icon_render_key] = new_limbs

	apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()



/////////////////////
// Limb Icon Cache //
/////////////////////
/*
	Called from update_body_parts() these procs handle the limb icon cache.
	the limb icon cache adds an icon_render_key to a human mob, it represents:
	- skin_tone (if applicable)
	- gender
	- limbs (stores as the limb name and whether it is removed/fine, organic/robotic)
	These procs only store limbs as to increase the number of matching icon_render_keys
	This cache exists because drawing 6/7 icons for humans constantly is quite a waste
	See RemieRichards on irc.rizon.net #coderbus (RIP remie :sob:)
*/

//produces a key based on the mob's limbs

/mob/living/carbon/proc/generate_icon_render_key()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		. += "-[BP.body_zone]"
		if(BP.use_digitigrade)
			. += "-digitigrade[BP.use_digitigrade]"
		if(BP.animal_origin)
			. += "-[BP.animal_origin]"
		if(BP.organic_render)
			. += "-OR"

	if(HAS_TRAIT(src, TRAIT_HUSK))
		. += "-husk"

//change the mob's icon to the one matching its key
/mob/living/carbon/proc/load_limb_from_cache()
	if(limb_icon_cache[icon_render_key])
		remove_overlay(BODYPARTS_LAYER)
		overlays_standing[BODYPARTS_LAYER] = limb_icon_cache[icon_render_key]
		apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()

//Updating overlays related to on bodypart bandages
/mob/living/carbon/proc/update_bandage_overlays()
	remove_overlay(BANDAGE_LAYER)

	var/mutable_appearance/overlays = mutable_appearance('icons/horizon/mob/bandage_overlays.dmi', "", -BANDAGE_LAYER)
	overlays_standing[BANDAGE_LAYER] = overlays

	for(var/b in bodyparts)
		var/obj/item/bodypart/BP = b
		if(BP.current_gauze && BP.current_gauze.overlay_prefix)
			var/bp_suffix = BP.body_zone
			if(BP.use_digitigrade)
				bp_suffix += "_digitigrade"
			overlays.add_overlay("[BP.current_gauze.overlay_prefix]_[bp_suffix]")
		if(BP.current_splint && BP.current_splint.overlay_prefix)
			var/bp_suffix = BP.body_zone
			if(BP.use_digitigrade)
				bp_suffix += "_digitigrade"
			overlays.add_overlay("[BP.current_splint.overlay_prefix]_[bp_suffix]")

	apply_overlay(BANDAGE_LAYER)
