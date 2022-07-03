/obj/item/organ/head_feature
	name = "head fluff"
	desc = "A severed bunch of fluff. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_HEAD_FEATURE

/obj/item/organ/head_feature/is_visible_on_owner()
	if(owner.head && (owner.head.flags_inv & HIDEHAIR) || (owner.wear_mask && (owner.wear_mask.flags_inv & HIDEHAIR)))
		return FALSE
	return TRUE

/obj/item/organ/head_feature/skrell_hair
	name = "skrell hair"

/obj/item/organ/head_feature/xeno_head
	name = "xenomorph head"
