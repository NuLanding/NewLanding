/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 8
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("mops", "bashes", "bludgeons", "whacks")
	attack_verb_simple = list("mop", "bash", "bludgeon", "whack")
	resistance_flags = FLAMMABLE
	var/mopcount = 0
	var/mopcap = 15
	var/mopspeed = 15
	force_string = "robust... against germs"
	var/insertable = TRUE

/obj/item/mop/Initialize()
	. = ..()
	create_reagents(mopcap)


/obj/item/mop/proc/clean(turf/A, mob/living/cleaner)
	if(reagents.has_reagent(/datum/reagent/water, 1) || reagents.has_reagent(/datum/reagent/water/holywater, 1) || reagents.has_reagent(/datum/reagent/consumable/ethanol/vodka, 1) || reagents.has_reagent(/datum/reagent/space_cleaner, 1))
		// If there's a cleaner with a mind, let's gain some experience!
		A.wash(CLEAN_SCRUB)

	reagents.expose(A, TOUCH, 10) //Needed for proper floor wetting.
	reagents.remove_any(1) //reaction() doesn't use up the reagents


/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(reagents.total_volume < 0.1)
		to_chat(user, SPAN_WARNING("Your mop is dry!"))
		return

	var/turf/T = get_turf(A)

	if(istype(A, /obj/item/reagent_containers/glass/bucket))
		return

	if(T)
		user.visible_message(SPAN_NOTICE("[user] begins to clean \the [T] with [src]."), SPAN_NOTICE("You begin to clean \the [T] with [src]..."))
		if(do_after(user, mopspeed, target = T))
			to_chat(user, SPAN_NOTICE("You finish mopping."))
			clean(T, user)


/obj/effect/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	else
		return ..()
