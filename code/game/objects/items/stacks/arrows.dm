/obj/item/stack/arrow
	name = "arrows"
	icon = 'icons/obj/items/stack/arrow.dmi'
	icon_state = "arrow"
	merge_type = /obj/item/stack/arrow
	full_w_class = WEIGHT_CLASS_NORMAL
	max_amount = 5
	singular_name = "arrow"
	novariants = TRUE

/obj/item/stack/arrow/update_icon_state()
	. = ..()
	icon_state = "arrow_[amount]"

/obj/item/stack/arrow/two
	amount = 2

/obj/item/stack/arrow/three
	amount = 3

/obj/item/stack/arrow/four
	amount = 4

/obj/item/stack/arrow/five
	amount = 5
