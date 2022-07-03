/obj/item/organ/hair
	abstract_type = /obj/item/organ/hair
	desc = "A severed patch of skin with hair."
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	organ_dna_type = /datum/organ_dna/hair
	var/hair_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/hair_dye_gradient = /datum/hair_gradient/none
	var/hair_dye_color = "#FFFFFF"

/obj/item/organ/hair/randomize_appearance()
	hair_color = pick(HAIR_COLOR_LIST)
	update_accessory_colors()

/obj/item/organ/hair/is_visible_on_owner()
	if(owner.head && (owner.head.flags_inv & HIDEHAIR) || (owner.wear_mask && (owner.wear_mask.flags_inv & HIDEHAIR)))
		return FALSE
	return TRUE

/obj/item/organ/hair/bodypart_overlays(mutable_appearance/standing)
	add_gradient_overlay(standing, natural_gradient, natural_color)
	add_gradient_overlay(standing, hair_dye_gradient, hair_dye_color)

/obj/item/organ/hair/proc/add_gradient_overlay(mutable_appearance/standing, gradient_type, gradient_color)
	if(gradient_type == /datum/hair_gradient/none)
		return
	var/datum/hair_gradient/gradient = HAIR_GRADIENT(gradient_type)
	var/icon/temp = icon(gradient.icon, gradient.icon_state)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	var/icon/temp_hair = icon(accessory.icon, accessory.icon_state)
	temp.Blend(temp_hair, ICON_ADD)
	var/mutable_appearance/gradient_appearance = mutable_appearance(temp)
	gradient_appearance.color = gradient_color
	standing.overlays += gradient_appearance

/obj/item/organ/hair/update_accessory_colors()
	accessory_colors = hair_color

/obj/item/organ/hair/imprint_organ_dna(datum/organ_dna/organ_dna)
	. = ..()
	var/datum/organ_dna/hair/hair_dna = organ_dna
	hair_dna.hair_color = hair_color
	hair_dna.natural_gradient = natural_gradient
	hair_dna.natural_color = natural_color

/obj/item/organ/hair/head
	name = "hair"
	accessory_type = /datum/sprite_accessory/hair/head/bob
	slot = ORGAN_SLOT_HAIR

/obj/item/organ/hair/head/randomize_appearance()
	accessory_type = pick(RANDOM_HAIR_STYLES)
	..()

/obj/item/organ/hair/facial
	name = "facial hair"
	accessory_type = /datum/sprite_accessory/hair/facial/gt
	slot = ORGAN_SLOT_FACIAL_HAIR

/obj/item/organ/hair/facial/randomize_appearance()
	accessory_type = pick(RANDOM_FACEHAIR_STYLES)
	..()
