/obj/item/clothing/neck
	name = "necklace"
	icon = 'icons/obj/clothing/neck/neck.dmi'
	worn_icon = 'icons/mob/clothing/neck/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40
	fitted_bodytypes = NONE

/obj/item/clothing/neck/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(body_parts_covered & HEAD)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
		if(HAS_BLOOD_DNA(src))
			. += mutable_appearance('icons/effects/blood.dmi', "maskblood")
