/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * Contains:
 * Donut Box
 * Egg Box
 * Candle Box
 * Cigarette Box
 * Cigar Case
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox"
	base_icon_state = "donutbox"
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/cardboard = 2000)
	/// Used by examine to report what this thing is holding.
	var/contents_tag = "errors"
	/// What type of thing to fill this storage with.
	var/spawn_type = null
	/// Whether the container is open or not
	var/is_open = FALSE
	/// What this container folds up into when it's empty.
	var/obj/fold_result = /obj/item/stack/sheet/cardboard

/obj/item/storage/fancy/PopulateContents()
	if(!spawn_type)
		return
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	for(var/i = 1 to STR.max_items)
		new spawn_type(src)

/obj/item/storage/fancy/update_icon_state()
	icon_state = "[base_icon_state][is_open ? contents.len : null]"
	return ..()

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(!is_open)
		return
	if(length(contents) == 1)
		. += "There is one [contents_tag] left."
	else
		. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] [contents_tag]s left."

/obj/item/storage/fancy/attack_self(mob/user)
	is_open = !is_open
	update_appearance()
	. = ..()
	if(contents.len)
		return
	new fold_result(user.drop_location())
	to_chat(user, SPAN_NOTICE("You fold the [src] into [initial(fold_result.name)]."))
	user.put_in_active_hand(fold_result)
	qdel(src)

/obj/item/storage/fancy/Exited(atom/movable/gone, direction)
	. = ..()
	is_open = TRUE
	update_appearance()

/obj/item/storage/fancy/Entered(atom/movable/arrived, direction)
	. = ..()
	is_open = TRUE
	update_appearance()

#define DONUT_INBOX_SPRITE_WIDTH 3

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	name = "donut box"
	desc = "Mmm. Donuts."
	icon = 'icons/obj/food/donuts.dmi'
	icon_state = "donutbox_inner"
	base_icon_state = "donutbox"
	spawn_type = /obj/item/food/donut
	is_open = TRUE
	appearance_flags = KEEP_TOGETHER
	custom_premium_price = PAYCHECK_HARD * 1.75
	contents_tag = "donut"

/obj/item/storage/fancy/donut_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/food/donut))

/obj/item/storage/fancy/donut_box/PopulateContents()
	. = ..()
	update_appearance()

/obj/item/storage/fancy/donut_box/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][is_open ? "_inner" : null]"

/obj/item/storage/fancy/donut_box/update_overlays()
	. = ..()
	if(!is_open)
		return

	var/donuts = 0
	for(var/_donut in contents)
		var/obj/item/food/donut/donut = _donut
		if (!istype(donut))
			continue

		. += image(icon = initial(icon), icon_state = donut.in_box_sprite(), pixel_x = donuts * DONUT_INBOX_SPRITE_WIDTH)
		donuts += 1

	. += image(icon = initial(icon), icon_state = "[base_icon_state]_top")

#undef DONUT_INBOX_SPRITE_WIDTH

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "eggbox"
	icon_state = "eggbox"
	base_icon_state = "eggbox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	name = "egg box"
	desc = "A carton for containing eggs."
	spawn_type = /obj/item/food/egg
	contents_tag = "egg"

/obj/item/storage/fancy/egg_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 12
	STR.set_holdable(list(/obj/item/food/egg))

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	base_icon_state = "candlebox"
	inhand_icon_state = "candlebox5"
	worn_icon_state = "cigpack"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/candle
	is_open = TRUE
	contents_tag = "candle"

/obj/item/storage/fancy/candle_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5

/obj/item/storage/fancy/candle_box/attack_self(mob/user)
	if(!contents.len)
		new fold_result(user.drop_location())
		to_chat(user, SPAN_NOTICE("You fold the [src] into [initial(fold_result.name)]."))
		user.put_in_active_hand(fold_result)
		qdel(src)

/obj/item/storage/fancy/candle_box/vanilla
	name = "vanilla candle pack"
	spawn_type = /obj/item/candle/vanilla

/obj/item/storage/fancy/candle_box/pear
	name = "pear candle pack"
	spawn_type = /obj/item/candle/pear

/obj/item/storage/fancy/candle_box/amber
	name = "amber candle pack"
	spawn_type = /obj/item/candle/amber

/obj/item/storage/fancy/candle_box/jasmine
	name = "jasmine candle pack"
	spawn_type = /obj/item/candle/jasmine

/obj/item/storage/fancy/candle_box/mint
	name = "mint candle pack"
	spawn_type = /obj/item/candle/mint

/*
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy/heart_box
	name = "heart-shaped box"
	desc = "A heart-shaped box for holding tiny chocolates."
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "chocolatebox"
	icon_state = "chocolatebox"
	base_icon_state = "chocolatebox"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	contents_tag = "chocolate"
	spawn_type = /obj/item/food/tinychocolate

/obj/item/storage/fancy/heart_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 8
	STR.set_holdable(list(/obj/item/food/tinychocolate))


/obj/item/storage/fancy/nugget_box
	name = "nugget box"
	desc = "A cardboard box used for holding chicken nuggies."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	base_icon_state = "nuggetbox"
	contents_tag = "nugget"
	spawn_type = /obj/item/food/nugget

/obj/item/storage/fancy/nugget_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/food/nugget))
