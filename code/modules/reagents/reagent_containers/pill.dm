/obj/item/reagent_containers/pill
	name = "pill"
	desc = "A tablet or capsule."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill"
	inhand_icon_state = "pill"
	worn_icon_state = "pen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	possible_transfer_amounts = list()
	volume = 50
	grind_results = list()
	var/apply_type = INGEST
	var/apply_method = "swallow"
	var/rename_with_volume = FALSE
	var/self_delay = 0 //pills are instant, this is because patches inheret their aplication from pills
	var/dissolvable = TRUE

/obj/item/reagent_containers/pill/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "pill[rand(1,20)]"
	if(reagents.total_volume && rename_with_volume)
		name += " ([reagents.total_volume]u)"

/obj/item/reagent_containers/pill/attack(mob/M, mob/user, def_zone)
	if(!canconsume(M, user))
		return FALSE

	if(M == user)
		M.visible_message(SPAN_NOTICE("[user] attempts to [apply_method] [src]."))
		if(self_delay)
			if(!do_mob(user, M, self_delay))
				return FALSE
		to_chat(M, SPAN_NOTICE("You [apply_method] [src]."))

	else
		M.visible_message(SPAN_DANGER("[user] attempts to force [M] to [apply_method] [src]."), \
							SPAN_USERDANGER("[user] attempts to force you to [apply_method] [src]."))
		if(!do_mob(user, M, CHEM_INTERACT_DELAY(3 SECONDS, user)))
			return FALSE
		M.visible_message(SPAN_DANGER("[user] forces [M] to [apply_method] [src]."), \
							SPAN_USERDANGER("[user] forces you to [apply_method] [src]."))

	return on_consumption(M, user)

///Runs the consumption code, can be overriden for special effects
/obj/item/reagent_containers/pill/proc/on_consumption(mob/M, mob/user)
	if(icon_state == "pill4" && prob(5)) //you take the red pill - you stay in Wonderland, and I show you how deep the rabbit hole goes
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, M, SPAN_NOTICE("[pick(strings(REDPILL_FILE, "redpill_questions"))]")), 50)

	if(reagents.total_volume)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = apply_type)
	qdel(src)
	return TRUE


/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!dissolvable || !target.is_refillable())
		return
	if(target.is_drainable() && !target.reagents.total_volume)
		to_chat(user, SPAN_WARNING("[target] is empty! There's nothing to dissolve [src] in."))
		return

	if(target.reagents.holder_full())
		to_chat(user, SPAN_WARNING("[target] is full."))
		return

	user.visible_message(SPAN_WARNING("[user] slips something into [target]!"), SPAN_NOTICE("You dissolve [src] in [target]."), null, 2)
	reagents.trans_to(target, reagents.total_volume, transfered_by = user)
	qdel(src)

/*
 * On accidental consumption, consume the pill
 */
/obj/item/reagent_containers/pill/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item, discover_after = FALSE)
	to_chat(victim, SPAN_WARNING("You swallow something small. [source_item ? "Was that in [source_item]?" : ""]"))
	reagents?.trans_to(victim, reagents.total_volume, transfered_by = user, methods = INGEST)
	qdel(src)
	return discover_after

/obj/item/reagent_containers/pill/iron
	name = "iron pill"
	desc = "Used to reduce bloodloss slowly."
	icon_state = "pill8"
	list_reagents = list(/datum/reagent/iron = 30)
	rename_with_volume = TRUE
