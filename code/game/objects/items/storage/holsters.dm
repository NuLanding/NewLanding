
/obj/item/storage/belt/holster
	name = "shoulder holster"
	desc = "A rather plain but still cool looking holster that can hold a handgun."
	icon_state = "holster"
	inhand_icon_state = "holster"
	worn_icon_state = "holster"
	alternate_worn_layer = UNDER_SUIT_LAYER

/obj/item/storage/belt/holster/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_BELT)
		ADD_TRAIT(user, TRAIT_GUNFLIP, CLOTHING_TRAIT)

/obj/item/storage/belt/holster/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_GUNFLIP, CLOTHING_TRAIT)

/obj/item/storage/belt/holster/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.set_holdable(list())
