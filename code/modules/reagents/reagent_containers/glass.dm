
/obj/item/reagent_containers/glass
	name = "glass"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 50
	reagent_flags = OPENCONTAINER | DUNKABLE
	spillable = TRUE
	resistance_flags = ACID_PROOF


/obj/item/reagent_containers/glass/attack(mob/M, mob/living/user, obj/target)
	if(!canconsume(M, user))
		return

	if(!spillable)
		return

	if(!reagents || !reagents.total_volume)
		to_chat(user, SPAN_WARNING("[src] is empty!"))
		return

	if(istype(M))
		if(M != user)
			M.visible_message(SPAN_DANGER("[user] attempts to feed [M] something from [src]."), \
						SPAN_USERDANGER("[user] attempts to feed you something from [src]."))
			if(!do_mob(user, M))
				return
			if(!reagents || !reagents.total_volume)
				return // The drink might be empty after the delay, such as by spam-feeding
			M.visible_message(SPAN_DANGER("[user] feeds [M] something from [src]."), \
						SPAN_USERDANGER("[user] feeds you something from [src]."))
			log_combat(user, M, "fed", reagents.log_list())
		else
			to_chat(user, SPAN_NOTICE("You swallow a gulp of [src]."))
		SEND_SIGNAL(src, COMSIG_GLASS_DRANK, M, user)
		addtimer(CALLBACK(reagents, /datum/reagents.proc/trans_to, M, 5, TRUE, TRUE, FALSE, user, FALSE, INGEST), 5)
		playsound(M.loc,'sound/items/drink.ogg', rand(10,50), TRUE)

/obj/item/reagent_containers/glass/afterattack(obj/target, mob/living/user, proximity)
	. = ..()
	if((!proximity) || !check_allowed_items(target,target_self=1))
		return

	if(!spillable)
		return

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("[src] is empty!"))
			return

		if(target.reagents.holder_full())
			to_chat(user, SPAN_WARNING("[target] is full."))
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, SPAN_NOTICE("You transfer [trans] unit\s of the solution to [target]."))

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_WARNING("[target] is empty and can't be refilled!"))
			return

		if(reagents.holder_full())
			to_chat(user, SPAN_WARNING("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, SPAN_NOTICE("You fill [src] with [trans] unit\s of the contents of [target]."))

/obj/item/reagent_containers/glass/attackby(obj/item/I, mob/user, params)
	var/hotness = I.get_temperature()
	if(hotness && reagents)
		reagents.expose_temperature(hotness)
		to_chat(user, SPAN_NOTICE("You heat [name] with [I]!"))

	if(istype(I, /obj/item/food/egg)) //breaking eggs
		var/obj/item/food/egg/E = I
		if(reagents)
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_NOTICE("[src] is full."))
			else
				to_chat(user, SPAN_NOTICE("You break [E] in [src]."))
				E.reagents.trans_to(src, E.reagents.total_volume, transfered_by = user)
				qdel(E)
			return
	..()

/*
 * On accidental consumption, make sure the container is partially glass, and continue to the reagent_container proc
 */
/obj/item/reagent_containers/glass/on_accidental_consumption(mob/living/carbon/M, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	if(!custom_materials)
		set_custom_materials(list(GET_MATERIAL_REF(/datum/material/glass) = 5))//sets it to glass so, later on, it gets picked up by the glass catch (hope it doesn't 'break' things lol)
	return ..()

/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker. It can hold up to 50 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	inhand_icon_state = "beaker"
	worn_icon_state = "beaker"
	custom_materials = list(/datum/material/glass=500)
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/glass/beaker/Initialize()
	. = ..()
	update_appearance()

/obj/item/reagent_containers/glass/beaker/get_part_rating()
	return reagents.maximum_volume

/obj/item/reagent_containers/glass/beaker/jar
	name = "honey jar"
	desc = "A jar for honey. It can hold up to 50 units of sweet delight."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "vapour"

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker. Can hold up to 100 units."
	icon_state = "beakerlarge"
	custom_materials = list(/datum/material/glass=2500)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	fill_icon_thresholds = list(0, 1, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/glass/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	inhand_icon_state = "bucket"
	inhand_icon = 'icons/mob/inhands/equipment/custodial_inhand.dmi'
	custom_materials = list(/datum/material/iron=200)
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(5,10,15,20,25,30,50,70)
	volume = 70
	flags_inv = HIDEHAIR
	slot_flags = ITEM_SLOT_HEAD
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 75, ACID = 50) //Weak melee protection, because you can wear it on your head
	slot_equipment_priority = list( \
		ITEM_SLOT_BACK, ITEM_SLOT_ID,\
		ITEM_SLOT_ICLOTHING, ITEM_SLOT_OCLOTHING,\
		ITEM_SLOT_MASK, ITEM_SLOT_HEAD, ITEM_SLOT_NECK,\
		ITEM_SLOT_FEET, ITEM_SLOT_GLOVES,\
		ITEM_SLOT_EARS, ITEM_SLOT_EYES,\
		ITEM_SLOT_BELT, ITEM_SLOT_SUITSTORE,\
		ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET,\
		ITEM_SLOT_DEX_STORAGE
	)

/obj/item/reagent_containers/glass/bucket/wooden
	name = "wooden bucket"
	icon_state = "woodbucket"
	inhand_icon_state = "woodbucket"
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 2)
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 50)
	resistance_flags = FLAMMABLE

/obj/item/reagent_containers/glass/bucket/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("[src] is out of water!"))
		else
			reagents.trans_to(O, 5, transfered_by = user)
			to_chat(user, SPAN_NOTICE("You wet [O] in [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
	else
		..()

/obj/item/reagent_containers/glass/bucket/equipped(mob/user, slot)
	..()
	if (slot == ITEM_SLOT_HEAD)
		if(reagents.total_volume)
			to_chat(user, SPAN_USERDANGER("[src]'s contents spill all over you!"))
			reagents.expose(user, TOUCH)
			reagents.clear_reagents()
		reagents.flags = NONE

/obj/item/reagent_containers/glass/bucket/dropped(mob/user)
	. = ..()
	reagents.flags = initial(reagent_flags)

/obj/item/reagent_containers/glass/bucket/equip_to_best_slot(mob/M)
	if(reagents.total_volume) //If there is water in a bucket, don't quick equip it to the head
		var/index = slot_equipment_priority.Find(ITEM_SLOT_HEAD)
		slot_equipment_priority.Remove(ITEM_SLOT_HEAD)
		. = ..()
		slot_equipment_priority.Insert(index, ITEM_SLOT_HEAD)
		return
	return ..()

/obj/item/pestle
	name = "pestle"
	desc = "An ancient, simple tool used in conjunction with a mortar to grind or juice items."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pestle"
	force = 7

/obj/item/reagent_containers/glass/mortar
	name = "mortar"
	desc = "A specially formed bowl of ancient design. It is possible to crush or juice items placed in it using a pestle; however the process, unlike modern methods, is slow and physically exhausting. Alt click to eject the item."
	icon_state = "mortar"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50, 100)
	volume = 100
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT)
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	var/obj/item/grinded

/obj/item/reagent_containers/glass/mortar/AltClick(mob/user)
	if(grinded)
		grinded.forceMove(drop_location())
		grinded = null
		to_chat(user, SPAN_NOTICE("You eject the item inside."))

/obj/item/reagent_containers/glass/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	..()
	if(istype(I,/obj/item/pestle))
		if(grinded)
			if(user.getStaminaLoss() > 50)
				to_chat(user, SPAN_WARNING("You are too tired to work!"))
				return
			to_chat(user, SPAN_NOTICE("You start grinding..."))
			if((do_after(user, 25, target = src)) && grinded)
				user.adjustStaminaLoss(40)
				if(grinded.juice_results) //prioritize juicing
					grinded.on_juice()
					reagents.add_reagent_list(grinded.juice_results)
					to_chat(user, SPAN_NOTICE("You juice [grinded] into a fine liquid."))
					QDEL_NULL(grinded)
					return
				grinded.on_grind()
				reagents.add_reagent_list(grinded.grind_results)
				if(grinded.reagents) //food and pills
					grinded.reagents.trans_to(src, grinded.reagents.total_volume, transfered_by = user)
				to_chat(user, SPAN_NOTICE("You break [grinded] into powder."))
				QDEL_NULL(grinded)
				return
			return
		else
			to_chat(user, SPAN_WARNING("There is nothing to grind!"))
			return
	if(grinded)
		to_chat(user, SPAN_WARNING("There is something inside already!"))
		return
	if(I.juice_results || I.grind_results)
		I.forceMove(src)
		grinded = I
		return
	to_chat(user, SPAN_WARNING("You can't grind this!"))
