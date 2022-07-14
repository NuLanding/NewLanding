/obj/item/storage/quiver
	name = "quiver"
	desc = "A leather quiver. Useful for carrying arrows around."
	icon_state = "quiver"
	inhand_icon_state = "quiver"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	var/arrow_state = "quiver_arrow"

/obj/item/storage/quiver/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/storage/quiver/update_overlays()
	. = ..()
	if(arrow_state && length(contents))
		. += mutable_appearance(icon, arrow_state)

/obj/item/storage/quiver/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file, bodytype = BODYTYPE_HUMANOID, slot, worn_state, worn_prefix)
	. = ..()
	if(arrow_state && length(contents))
		. += mutable_appearance(icon_file, "[worn_prefix]_[arrow_state]")

/obj/item/storage/quiver/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 4 * WEIGHT_CLASS_NORMAL
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 4
	STR.set_holdable(list(/obj/item/stack/arrow))

/obj/item/storage/quiver/half_full/PopulateContents()
	new /obj/item/stack/arrow/five(src)
	new /obj/item/stack/arrow/five(src)

/obj/item/storage/quiver/full/PopulateContents()
	new /obj/item/stack/arrow/five(src)
	new /obj/item/stack/arrow/five(src)
	new /obj/item/stack/arrow/five(src)
	new /obj/item/stack/arrow/five(src)
