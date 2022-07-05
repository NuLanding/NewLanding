/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

#define BEDSHEET_ABSTRACT "abstract"
#define BEDSHEET_SINGLE "single"
#define BEDSHEET_DOUBLE "double"

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	slot_flags = ITEM_SLOT_NECK
	layer = MOB_LAYER
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET

	dog_fashion = /datum/dog_fashion/head/ghost
	var/list/dream_messages = list("white")
	var/stack_amount = 3
	var/bedsheet_type = BEDSHEET_SINGLE

/obj/item/bedsheet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator, null)
	AddElement(/datum/element/bed_tuckable, 0, 0, 0)
	if(bedsheet_type == BEDSHEET_DOUBLE)
		stack_amount *= 2
		dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET

/obj/item/bedsheet/attack_self(mob/user)
	if(!user.CanReach(src)) //No telekenetic grabbing.
		return
	if(!user.dropItemToGround(src))
		return
	if(layer == initial(layer))
		layer = ABOVE_MOB_LAYER
		to_chat(user, SPAN_NOTICE("You cover yourself with [src]."))
		pixel_x = 0
		pixel_y = 0
	else
		layer = initial(layer)
		to_chat(user, SPAN_NOTICE("You smooth [src] out beneath you."))
	add_fingerprint(user)
	return

/obj/item/bedsheet/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if (!(flags_1 & HOLOGRAM_1))
			var/obj/item/stack/sheet/cloth/shreds = new (get_turf(src), stack_amount)
			if(!QDELETED(shreds)) //stacks merged
				transfer_fingerprints_to(shreds)
				shreds.add_fingerprint(user)
		qdel(src)
		to_chat(user, SPAN_NOTICE("You tear [src] up."))
	else
		return ..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	inhand_icon_state = "sheetblue"
	dream_messages = list("blue")

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	inhand_icon_state = "sheetgreen"
	dream_messages = list("green")

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	inhand_icon_state = "sheetgrey"
	dream_messages = list("grey")

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	inhand_icon_state = "sheetorange"
	dream_messages = list("orange")

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	inhand_icon_state = "sheetpurple"
	dream_messages = list("purple")

/obj/item/bedsheet/red
	icon_state = "sheetred"
	inhand_icon_state = "sheetred"
	dream_messages = list("red")

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	inhand_icon_state = "sheetyellow"
	dream_messages = list("yellow")

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	inhand_icon_state = "sheetbrown"
	dream_messages = list("brown")

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	inhand_icon_state = "sheetblack"
	dream_messages = list("black")

/obj/item/bedsheet/random
	icon_state = "random_bedsheet"
	name = "random bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	bedsheet_type = BEDSHEET_ABSTRACT
	var/static/list/bedsheet_list
	var/spawn_type = BEDSHEET_SINGLE

/obj/item/bedsheet/random/Initialize(mapload)
	..()
	var/saved_dir = dir
	if(!LAZYACCESS(bedsheet_list, spawn_type))
		var/list/spawn_list = list()
		var/list/possible_types = typesof(/obj/item/bedsheet)
		for(var/obj/item/bedsheet/sheet as anything in possible_types)
			if(initial(sheet.bedsheet_type) == spawn_type)
				spawn_list += sheet
		LAZYSET(bedsheet_list, spawn_type, spawn_list)
	var/chosen_type = pick(bedsheet_list[spawn_type])
	var/obj/item/bedsheet/new_sheet = new chosen_type(loc)
	new_sheet.setDir(saved_dir)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/random/double
	icon_state = "random_doublesheet"
	spawn_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/dorms
	icon_state = "random_bedsheet"
	name = "random dorms bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"
	bedsheet_type = BEDSHEET_ABSTRACT
	slot_flags = null

/obj/item/bedsheet/dorms/Initialize(mapload)
	..()
	var/type = pickweight(list("Colors" = 100))
	switch(type)
		if("Colors")
			type = pick(list(/obj/item/bedsheet,
				/obj/item/bedsheet/blue,
				/obj/item/bedsheet/green,
				/obj/item/bedsheet/grey,
				/obj/item/bedsheet/orange,
				/obj/item/bedsheet/purple,
				/obj/item/bedsheet/red,
				/obj/item/bedsheet/yellow,
				/obj/item/bedsheet/brown,
				/obj/item/bedsheet/black))
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/double
	icon_state = "double_sheetwhite"
	worn_icon_state = "sheetwhite"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/blue/double
	icon_state = "double_sheetblue"
	worn_icon_state = "sheetblue"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/green/double
	icon_state = "double_sheetgreen"
	worn_icon_state = "sheetgreen"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/grey/double
	icon_state = "double_sheetgrey"
	worn_icon_state = "sheetgrey"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/orange/double
	icon_state = "double_sheetorange"
	worn_icon_state = "sheetorange"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/purple/double
	icon_state = "double_sheetpurple"
	worn_icon_state = "sheetpurple"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/brown/double
	icon_state = "double_sheetbrown"
	worn_icon_state = "sheetbrown"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/black/double
	icon_state = "double_sheetblack"
	worn_icon_state = "sheetblack"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/red/double
	icon_state = "double_sheetred"
	worn_icon_state = "sheetred"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/yellow/double
	icon_state = "double_sheetyellow"
	worn_icon_state = "sheetyellow"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/dorms_double
	icon_state = "random_bedsheet"
	bedsheet_type = BEDSHEET_ABSTRACT

/obj/item/bedsheet/dorms_double/Initialize()
	..()
	var/type = pickweight(list("Colors" = 100))
	switch(type)
		if("Colors")
			type = pick(list(/obj/item/bedsheet,
				/obj/item/bedsheet/blue/double,
				/obj/item/bedsheet/green/double,
				/obj/item/bedsheet/grey/double,
				/obj/item/bedsheet/orange/double,
				/obj/item/bedsheet/purple/double,
				/obj/item/bedsheet/red/double,
				/obj/item/bedsheet/yellow/double,
				/obj/item/bedsheet/brown/double,
				/obj/item/bedsheet/black/double))
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 70
	var/amount = 10
	var/spawned_sheet = /obj/item/bedsheet
	var/list/allowed_sheets = list(/obj/item/bedsheet, /obj/item/reagent_containers/rag/towel)
	var/list/sheets = list()
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/empty
	amount = 0
	icon_state = "linenbin-empty"
	anchored = FALSE


/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()
	if(amount < 1)
		. += "There are no sheets in the bin."
	else if(amount == 1)
		. += "There is one sheet in the bin."
	else
		. += "There are [amount] sheets in the bin."


/obj/structure/bedsheetbin/update_icon_state()
	switch(amount)
		if(0)
			icon_state = "linenbin-empty"
		if(1 to 5)
			icon_state = "linenbin-half"
		else
			icon_state = "linenbin-full"
	return ..()

/obj/structure/bedsheetbin/fire_act(exposed_temperature, exposed_volume)
	if(amount)
		amount = 0
		update_appearance()
	..()

/obj/structure/bedsheetbin/attackby(obj/item/I, mob/user, params)
	if(is_type_in_list(I, allowed_sheets))
		if(!user.transferItemToLoc(I, src))
			return
		sheets.Add(I)
		amount++
		to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
		update_appearance()

	else if(default_unfasten_wrench(user, I, 5))
		return

	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(flags_1 & NODECONSTRUCT_1)
			return
		if(amount)
			to_chat(user, "<span clas='warn'>The [src] must be empty first!</span>")
			return
		if(I.use_tool(src, user, 5, volume=50))
			to_chat(user, "<span clas='notice'>You disassemble the [src].</span>")
			new /obj/item/stack/rods(loc, 2)
			qdel(src)

	else if(amount && !hidden && I.w_class < WEIGHT_CLASS_BULKY) //make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		if(!user.transferItemToLoc(I, src))
			to_chat(user, SPAN_WARNING("\The [I] is stuck to your hand, you cannot hide it among the sheets!"))
			return
		hidden = I
		to_chat(user, SPAN_NOTICE("You hide [I] among the sheets."))


/obj/structure/bedsheetbin/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/bedsheetbin/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	if(amount >= 1)
		amount--

		var/obj/item/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new spawned_sheet(loc)

		B.forceMove(drop_location())
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You take [B] out of [src]."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			to_chat(user, SPAN_NOTICE("[hidden] falls out of [B]!"))
			hidden = null

	add_fingerprint(user)


/obj/structure/bedsheetbin/attack_tk(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new spawned_sheet(loc)

		B.forceMove(drop_location())
		to_chat(user, SPAN_NOTICE("You telekinetically remove [B] from [src]."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			hidden = null

	add_fingerprint(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/structure/bedsheetbin/towel
	name = "linen bin"
	desc = "It looks rather cosy. This one is designed to hold towels."
	spawned_sheet = /obj/item/reagent_containers/rag/towel

#undef BEDSHEET_ABSTRACT
#undef BEDSHEET_SINGLE
#undef BEDSHEET_DOUBLE
