/obj/item/organ/tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TAIL
	var/can_wag = TRUE
	var/wagging = FALSE

/obj/item/organ/tail/is_visible_on_owner()
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.wear_suit)
		if(human_owner.try_hide_mutant_parts)
			return FALSE
		if(human_owner.wear_suit.flags_inv & HIDEJUMPSUIT)
			return FALSE
	return TRUE

/obj/item/organ/tail/cat
	name = "cat tail"
	desc = "A severed cat tail. Who's wagging now?"
	accessory_type = /datum/sprite_accessory/tail/cat

/obj/item/organ/tail/lizard
	name = "lizard tail"
	desc = "A severed lizard tail. Somewhere, no doubt, a lizard hater is very pleased with themselves."
	color = "#116611"
	accessory_type = /datum/sprite_accessory/tail/lizard/smooth
	accessory_colors = "#047300"

/obj/item/organ/tail/lizard/fake
	name = "fabricated lizard tail"
	desc = "A fabricated severed lizard tail. This one's made of synthflesh. Probably not usable for lizard wine."

/obj/item/organ/tail/monkey
	name = "monkey tail"
	desc = "A severed monkey tail. Does not look like a banana."
	icon_state = "severedmonkeytail"
	accessory_type = /datum/sprite_accessory/tail/monkey

/obj/item/organ/tail/mammal
	name = "mammal tail"
	accessory_type = /datum/sprite_accessory/tail/fox
	accessory_colors = "#fc8803#fff8f0"

/obj/item/organ/tail/avali
	name = "avali tail"

/obj/item/organ/tail/vulpkanin
	name = "vulpkanin tail"
	accessory_type = /datum/sprite_accessory/tail/fox
	accessory_colors = "#fc8803#fff8f0"

/obj/item/organ/tail/tajaran
	name = "tajaran tail"
	accessory_type = /datum/sprite_accessory/tail/catbig
	accessory_colors = "#BBAA88"

/obj/item/organ/tail/vox
	name = "vox tail"

/obj/item/organ/tail/synth
	name = "synthetic tail"

/obj/item/organ/tail/xeno
	name = "xeno tail"

/obj/item/organ/tail/akula
	name = "akula tail"
	accessory_type = /datum/sprite_accessory/tail/shark
	accessory_colors = "#668899"
