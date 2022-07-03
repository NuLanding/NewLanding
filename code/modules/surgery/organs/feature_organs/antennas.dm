/obj/item/organ/antennas
	name = "antennas"
	desc = "A severed pair of antennas. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_ANTENNAS

/obj/item/organ/antennas/is_visible_on_owner()
	if(owner.head && (owner.head.flags_inv & HIDEHAIR) || (owner.wear_mask && (owner.wear_mask.flags_inv & HIDEHAIR)))
		return FALSE
	return TRUE

/obj/item/organ/antennas/moth
	name = "moth antennas"

/obj/item/organ/antennas/ipc
	name = "I.P.C. antennas"

/obj/item/organ/antennas/synth
	name = "synthetic antennas"
