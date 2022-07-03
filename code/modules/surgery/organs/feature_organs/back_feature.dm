/obj/item/organ/back_feature
	name = "back fluff"
	desc = "A severed bunch of fluff. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BACK_FEATURE

/obj/item/organ/wings/is_visible_on_owner()
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.wear_suit)
		if(human_owner.try_hide_mutant_parts)
			return FALSE
		if(human_owner.wear_suit.flags_inv & HIDEJUMPSUIT)
			return FALSE
	return TRUE

/obj/item/organ/back_feature/xeno_dorsal
	name = "dorsal tubes"
