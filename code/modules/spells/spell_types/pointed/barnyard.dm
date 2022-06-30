/obj/effect/proc_holder/spell/pointed/barnyardcurse
	name = "Curse of the Barnyard"
	desc = "This spell dooms an unlucky soul to possess the speech and facial attributes of a barnyard animal."
	school = SCHOOL_TRANSMUTATION
	charge_type = "recharge"
	charge_max = 150
	charge_counter = 0
	clothes_req = FALSE
	stat_allowed = FALSE
	invocation = "KN'A FTAGHU, PUCK 'BTHNK!"
	invocation_type = INVOCATION_SHOUT
	range = 7
	cooldown_min = 30
	ranged_mousepointer = 'icons/effects/mouse_pointers/barn_target.dmi'
	action_icon_state = "barn"
	active_msg = "You prepare to curse a target..."
	deactive_msg = "You dispel the curse..."
	/// List of mobs which are allowed to be a target of the spell
	var/static/list/compatible_mobs_typecache = typecacheof(list(/mob/living/carbon/human))

/obj/effect/proc_holder/spell/pointed/barnyardcurse/cast(list/targets, mob/user)
	return FALSE

/obj/effect/proc_holder/spell/pointed/barnyardcurse/can_target(atom/target, mob/user, silent)
	. = ..()
	if(!.)
		return FALSE
	if(!is_type_in_typecache(target, compatible_mobs_typecache))
		if(!silent)
			to_chat(user, SPAN_WARNING("You are unable to curse [target]!"))
		return FALSE
	return TRUE
