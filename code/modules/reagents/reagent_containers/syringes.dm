/obj/item/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe that can hold up to 15 units."
	icon = 'icons/obj/syringe.dmi'
	base_icon_state = "syringe"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "syringe_0"
	worn_icon_state = "pen"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10, 15)
	volume = 15
	var/busy = FALSE // needed for delayed drawing of blood
	var/proj_piercing = 0 //does it pierce through thick clothes when shot with syringe gun
	custom_materials = list(/datum/material/iron=10, /datum/material/glass=20)
	reagent_flags = TRANSPARENT
	custom_price = PAYCHECK_EASY * 0.5
	sharpness = SHARP_POINTY

/obj/item/reagent_containers/syringe/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/reagent_containers/syringe/attackby(obj/item/I, mob/user, params)
	return

/obj/item/reagent_containers/syringe/proc/try_syringe(atom/target, mob/user, proximity)
	if(busy)
		return FALSE
	if(!proximity)
		return FALSE
	if(!target.reagents)
		return FALSE

	if(isliving(target))
		var/mob/living/living_target = target
		if(!living_target.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
			return FALSE

	// chance of monkey retaliation
	SEND_SIGNAL(target, COMSIG_LIVING_TRY_SYRINGE, user)
	return TRUE

/obj/item/reagent_containers/syringe/afterattack(atom/target, mob/user, proximity)
	. = ..()

	if (!try_syringe(target, user, proximity))
		return

	var/contained = reagents.log_list()
	log_combat(user, target, "attempted to inject", src, addition="which had [contained]")

	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("[src] is empty! Right-click to draw."))
		return

	if(!isliving(target) && !target.is_injectable(user))
		to_chat(user, SPAN_WARNING("You cannot directly fill [target]!"))
		return

	if(target.reagents.total_volume >= target.reagents.maximum_volume)
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return

	if(isliving(target))
		var/mob/living/living_target = target
		if(!living_target.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
			return
		if(living_target != user)
			living_target.visible_message(SPAN_DANGER("[user] is trying to inject [living_target]!"), \
									SPAN_USERDANGER("[user] is trying to inject you!"))
			if(!do_mob(user, living_target, CHEM_INTERACT_DELAY(3 SECONDS, user), extra_checks = CALLBACK(living_target, /mob/living/proc/try_inject, user, null, INJECT_TRY_SHOW_ERROR_MESSAGE)))
				return
			if(!reagents.total_volume)
				return
			if(living_target.reagents.total_volume >= living_target.reagents.maximum_volume)
				return
			living_target.visible_message(SPAN_DANGER("[user] injects [living_target] with the syringe!"), \
							SPAN_USERDANGER("[user] injects you with the syringe!"))

		if (living_target == user)
			living_target.log_message("injected themselves ([contained]) with [name]", LOG_ATTACK, color="orange")
		else
			log_combat(user, living_target, "injected", src, addition="which had [contained]")
	reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
	to_chat(user, SPAN_NOTICE("You inject [amount_per_transfer_from_this] units of the solution. The syringe now contains [reagents.total_volume] units."))

/obj/item/reagent_containers/syringe/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	if (!try_syringe(target, user, proximity_flag))
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	if(reagents.total_volume >= reagents.maximum_volume)
		to_chat(user, SPAN_NOTICE("[src] is full."))
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	if(isliving(target))
		var/mob/living/living_target = target
		var/drawn_amount = reagents.maximum_volume - reagents.total_volume
		if(target != user)
			target.visible_message(SPAN_DANGER("[user] is trying to take a blood sample from [target]!"), \
							SPAN_USERDANGER("[user] is trying to take a blood sample from you!"))
			busy = TRUE
			if(!do_mob(user, target, CHEM_INTERACT_DELAY(3 SECONDS, user), extra_checks = CALLBACK(living_target, /mob/living/proc/try_inject, user, null, INJECT_TRY_SHOW_ERROR_MESSAGE)))
				busy = FALSE
				return SECONDARY_ATTACK_CONTINUE_CHAIN
			if(reagents.total_volume >= reagents.maximum_volume)
				return SECONDARY_ATTACK_CONTINUE_CHAIN
		busy = FALSE
		if(living_target.transfer_blood_to(src, drawn_amount))
			user.visible_message(SPAN_NOTICE("[user] takes a blood sample from [living_target]."))
		else
			to_chat(user, SPAN_WARNING("You are unable to draw any blood from [living_target]!"))
	else
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_WARNING("[target] is empty!"))
			return SECONDARY_ATTACK_CONTINUE_CHAIN

		if(!target.is_drawable(user))
			to_chat(user, SPAN_WARNING("You cannot directly remove reagents from [target]!"))
			return SECONDARY_ATTACK_CONTINUE_CHAIN

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user) // transfer from, transfer to - who cares?

		to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the solution. It now contains [reagents.total_volume] units."))

	return SECONDARY_ATTACK_CONTINUE_CHAIN

/*
 * On accidental consumption, inject the eater with 2/3rd of the syringe and reveal it
 */
/obj/item/reagent_containers/syringe/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item,  discover_after = TRUE)
	if(source_item)
		to_chat(victim, SPAN_BOLDWARNING("There's a [src] in [source_item]!!"))
	else
		to_chat(victim, SPAN_BOLDWARNING("[src] injects you!"))

	victim.apply_damage(5, BRUTE, BODY_ZONE_HEAD)
	reagents?.trans_to(victim, round(reagents.total_volume*(2/3)), transfered_by = user, methods = INJECT)

	return discover_after

/obj/item/reagent_containers/syringe/update_icon_state()
	var/rounded_vol = get_rounded_vol()
	icon_state = "[base_icon_state]_[rounded_vol]"
	return ..()

/obj/item/reagent_containers/syringe/update_overlays()
	. = ..()
	if(reagents?.total_volume)
		var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/reagentfillings.dmi', "syringe[get_rounded_vol()]")
		filling_overlay.color = mix_color_from_reagents(reagents.reagent_list)
		. += filling_overlay

///Used by update_appearance() and update_overlays()
/obj/item/reagent_containers/syringe/proc/get_rounded_vol()
	if(!reagents?.total_volume)
		return 0
	return clamp(round((reagents.total_volume / volume * 15), 5), 1, 15)
