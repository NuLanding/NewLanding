/obj/item/organ/frills
	name = "frills"
	desc = "A severed pair of frills. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_FRILLS

/obj/item/organ/frills/is_visible_on_owner()
	if(owner.head && (owner.head.flags_inv & HIDEEARS) || (owner.wear_mask && (owner.wear_mask.flags_inv & HIDEEARS)))
		return FALSE
	return TRUE

/obj/item/organ/frills/humanoid
	accessory_type = /datum/sprite_accessory/frills/simple
	accessory_colors = "#047300"
