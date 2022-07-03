/obj/item/organ/horns
	name = "horns"
	desc = "A severed pair of horns. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_HORNS

/obj/item/organ/horns/is_visible_on_owner()
	if(owner.head && (owner.head.flags_inv & HIDEHAIR) || (owner.wear_mask && (owner.wear_mask.flags_inv & HIDEHAIR)))
		return FALSE
	return TRUE

/obj/item/organ/horns/humanoid
	accessory_type = /datum/sprite_accessory/horns/simple
	accessory_colors = "#555555"
