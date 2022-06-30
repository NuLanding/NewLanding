/*
 * Rings and Ring Boxes
 */

/obj/item/storage/fancy/ringbox
	name = "ring box"
	desc = "A tiny box covered in soft red felt made for holding rings."
	icon = 'icons/horizon/obj/ring.dmi'
	icon_state = "gold ringbox"
	base_icon_state = "gold ringbox"
	w_class = WEIGHT_CLASS_TINY

/obj/item/storage/fancy/ringbox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1

/obj/item/storage/fancy/ringbox/diamond
	icon_state = "diamond ringbox"
	base_icon_state = "diamond ringbox"

/obj/item/storage/fancy/ringbox/silver
	icon_state = "silver ringbox"
	base_icon_state = "silver ringbox"
