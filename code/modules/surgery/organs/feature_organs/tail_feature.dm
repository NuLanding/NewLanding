/obj/item/organ/tail_feature
	name = "tail fluff"
	desc = "A severed bunch of fluff. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_TAIL_FEATURE

/obj/item/organ/tail_feature/is_visible_on_owner()
	var/obj/item/organ/tail/tail = owner.getorganslot(ORGAN_SLOT_TAIL)
	if(!tail || !tail.is_visible())
		return FALSE
	return TRUE

/obj/item/organ/tail_feature/lizard_spines
	name = "spines"
	accessory_type = /datum/sprite_accessory/tail_feature/spines/shortmeme
	accessory_colors = "#047300"

/obj/item/organ/tail_feature/vox_marking
	name = "vox marking"
