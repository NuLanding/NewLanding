/obj/item/organ/snout
	name = "snout"
	desc = "A severed snout. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_SNOUT
	/// Whether headwear on the organs' owner will try and use muzzled variants.
	var/use_muzzled_sprites = TRUE

/obj/item/organ/snout/is_visible_on_owner()
	if(owner.head && (owner.head.flags_inv & HIDESNOUT) || (owner.wear_mask && (owner.wear_mask.flags_inv & HIDESNOUT)))
		return FALSE
	return TRUE

/obj/item/organ/snout/beak
	name = "beak"

/obj/item/organ/snout/vox
	name = "large beak"

/obj/item/organ/snout/mammal
	name = "mammal snout"
	accessory_type = /datum/sprite_accessory/snout/lcanidstriped
	accessory_colors = "#FFAA00#FFDD44"

/obj/item/organ/snout/lizard
	name = "lizard snout"
	accessory_type = /datum/sprite_accessory/snout/sharp
	accessory_colors = "#047300"

/obj/item/organ/snout/vulpkanin
	name = "vulpkanin snout"
	accessory_type = /datum/sprite_accessory/snout/lcanidstriped
	accessory_colors = "#FFAA00#FFDD44"

/obj/item/organ/snout/tajaran
	name = "tajaran snout"
	accessory_type = /datum/sprite_accessory/snout/tajaran
	accessory_colors = "#BBAA88"

/obj/item/organ/snout/akula
	name = "akula snout"
	accessory_type = /datum/sprite_accessory/snout/hshark
	accessory_colors = "#668899#BBCCDD"

/obj/item/organ/snout/synth
	name = "synthetic snout"
