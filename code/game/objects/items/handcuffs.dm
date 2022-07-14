/**
 * # Generic restraints
 *
 * Parent class for handcuffs and handcuff accessories
 *
 * Functionality:
 * 1. A special suicide
 * 2. If a restraint is handcuffing/legcuffing a carbon while being deleted, it will remove the handcuff/legcuff status.
*/
/obj/item/restraints
	breakouttime = 1 MINUTES
	dye_color = DYE_PRISONER

/obj/item/restraints/suicide_act(mob/living/carbon/user)
	user.visible_message(SPAN_SUICIDE("[user] is strangling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return(OXYLOSS)

/obj/item/restraints/Destroy()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.handcuffed == src)
			M.set_handcuffed(null)
			M.update_handcuffed()
			if(M.buckled && M.buckled.buckle_requires_restraints)
				M.buckled.unbuckle_mob(M)
		if(M.legcuffed == src)
			M.legcuffed = null
			M.update_inv_legcuffed()
	return ..()

/**
 * # Handcuffs
 *
 * Stuff that makes humans unable to use hands
 *
 * Clicking people with those will cause an attempt at handcuffing them to occur
*/
/obj/item/restraints/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "handcuff"
	worn_icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron=500)
	breakouttime = 1 MINUTES
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	custom_price = PAYCHECK_HARD * 0.35
	///Sound that plays when starting to put handcuffs on someone
	var/cuffsound = 'sound/weapons/handcuffs.ogg'
	///If set, handcuffs will be destroyed on application and leave behind whatever this is set to.
	var/trashtype = null

/obj/item/restraints/handcuffs/attack(mob/living/carbon/C, mob/living/user)
	if(!istype(C))
		return

	SEND_SIGNAL(C, COMSIG_CARBON_CUFF_ATTEMPTED, user)

	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))) //Clumsy people have a 50% chance to handcuff themselves instead of their target.
		to_chat(user, SPAN_WARNING("Uh... how do those things work?!"))
		apply_cuffs(user,user)
		return

	if(!C.handcuffed)
		if(C.canBeHandcuffed())
			C.visible_message(SPAN_DANGER("[user] is trying to put [src.name] on [C]!"), \
								SPAN_USERDANGER("[user] is trying to put [src.name] on you!"))

			playsound(loc, cuffsound, 30, TRUE, -2)
			log_combat(user, C, "attempted to handcuff")
			if(do_mob(user, C, 30) && C.canBeHandcuffed())
				apply_cuffs(C, user)
				C.visible_message(SPAN_NOTICE("[user] handcuffs [C]."), \
									SPAN_USERDANGER("[user] handcuffs you."))
				SSblackbox.record_feedback("tally", "handcuffs", 1, type)

				log_combat(user, C, "handcuffed")
			else
				to_chat(user, SPAN_WARNING("You fail to handcuff [C]!"))
				log_combat(user, C, "failed to handcuff")
		else
			to_chat(user, SPAN_WARNING("[C] doesn't have two hands..."))

/**
 * This handles handcuffing people
 *
 * When called, this instantly puts handcuffs on someone (if possible)
 * Arguments:
 * * mob/living/carbon/target - Who is being handcuffed
 * * mob/user - Who or what is doing the handcuffing
 * * dispense - True if the cuffing should create a new item instead of using putting src on the mob, false otherwise. False by default.
*/
/obj/item/restraints/handcuffs/proc/apply_cuffs(mob/living/carbon/target, mob/user, dispense = FALSE)
	if(target.handcuffed)
		return

	if(!user.temporarilyRemoveItemFromInventory(src) && !dispense)
		return

	var/obj/item/restraints/handcuffs/cuffs = src
	if(trashtype)
		cuffs = new trashtype()
	else if(dispense)
		cuffs = new type()

	cuffs.forceMove(target)
	target.set_handcuffed(cuffs)

	target.update_handcuffed()
	if(trashtype && !dispense)
		qdel(src)
	return

/obj/item/restraints/handcuffs/rope
	name = "rope restraints"
	desc = "Rope tied together to make a restraint. Could tie someone up with this."
	gender = PLURAL
	icon = 'icons/obj/items/restraints.dmi'
	icon_state = "rope"
	worn_icon_state = "rope"
	cuffsound = 'sound/weapons/cablecuff.ogg'

/obj/item/restraints/handcuffs/sinew


/**
 * # Generic leg cuffs
 *
 * Parent class for everything that can legcuff carbons. Can't legcuff anything itself.
*/
/obj/item/restraints/legcuffs
	name = "leg cuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 7
	breakouttime = 30 SECONDS

/**
 * # Bear trap
 *
 * This opens, closes, and bites people's legs.
 */
/obj/item/restraints/legcuffs/beartrap
	name = "bear trap"
	throw_speed = 1
	throw_range = 1
	icon_state = "beartrap"
	desc = "A trap used to catch bears and other legged creatures."
	///If true, the trap is "open" and can trigger.
	var/armed = FALSE
	///How much damage the trap deals when triggered.
	var/trap_damage = 20

/obj/item/restraints/legcuffs/beartrap/Initialize()
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/spring_trap,
	)
	AddElement(/datum/element/connect_loc, src, loc_connections)

/obj/item/restraints/legcuffs/beartrap/update_icon_state()
	icon_state = "[initial(icon_state)][armed]"
	return ..()

/obj/item/restraints/legcuffs/beartrap/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] is sticking [user.p_their()] head in the [src.name]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/restraints/legcuffs/beartrap/attack_self(mob/user)
	. = ..()
	if(!ishuman(user) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	armed = !armed
	update_appearance()
	to_chat(user, SPAN_NOTICE("[src] is now [armed ? "armed" : "disarmed"]"))

/**
 * Closes a bear trap
 *
 * Closes a bear trap.
 * Arguments:
 */
/obj/item/restraints/legcuffs/beartrap/proc/close_trap()
	armed = FALSE
	update_appearance()
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/obj/item/restraints/legcuffs/beartrap/proc/spring_trap(datum/source, AM as mob|obj)
	SIGNAL_HANDLER
	if(armed && isturf(loc))
		if(isliving(AM))
			var/mob/living/L = AM
			var/snap = TRUE
			if(istype(L.buckled, /obj/vehicle))
				var/obj/vehicle/ridden_vehicle = L.buckled
				if(!ridden_vehicle.are_legs_exposed) //close the trap without injuring/trapping the rider if their legs are inside the vehicle at all times.
					close_trap()
					ridden_vehicle.visible_message(SPAN_DANGER("[ridden_vehicle] triggers \the [src]."))

			if(L.movement_type & (FLYING|FLOATING)) //don't close the trap if they're flying/floating over it.
				snap = FALSE

			var/def_zone = BODY_ZONE_CHEST
			if(snap && iscarbon(L))
				var/mob/living/carbon/C = L
				if(C.body_position == STANDING_UP)
					def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
					if(!C.legcuffed && C.num_legs >= 2) //beartrap can't cuff your leg if there's already a beartrap or legcuffs, or you don't have two legs.
						C.legcuffed = src
						forceMove(C)
						C.update_equipment_speed_mods()
						C.update_inv_legcuffed()
						SSblackbox.record_feedback("tally", "handcuffs", 1, type)
			else if(snap && isanimal(L))
				var/mob/living/simple_animal/SA = L
				if(SA.mob_size <= MOB_SIZE_TINY) //don't close the trap if they're as small as a mouse.
					snap = FALSE
			if(snap)
				close_trap()
				L.visible_message(SPAN_DANGER("[L] triggers \the [src]."), \
						SPAN_USERDANGER("You trigger \the [src]!"))
				L.apply_damage(trap_damage, BRUTE, def_zone)

/obj/item/restraints/legcuffs/bola
	name = "bola"
	desc = "A restraining device designed to be thrown at the target. Upon connecting with said target, it will wrap around their legs, making it difficult for them to move quickly."
	icon_state = "bola"
	inhand_icon_state = "bola"
	lefthand_file = 'icons/mob/inhands/weapons/thrown_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/thrown_righthand.dmi'
	breakouttime = 3.5 SECONDS//easy to apply, easy to break out of
	gender = NEUTER
	///Amount of time to knock the target down for once it's hit in deciseconds.
	var/knockdown = 0

/obj/item/restraints/legcuffs/bola/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, gentle = FALSE, quickstart = TRUE)
	if(!..())
		return
	playsound(src.loc,'sound/weapons/bolathrow.ogg', 75, TRUE)

/obj/item/restraints/legcuffs/bola/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !iscarbon(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	ensnare(hit_atom)

/**
 * Attempts to legcuff someone with the bola
 *
 * Arguments:
 * * C - the carbon that we will try to ensnare
 */
/obj/item/restraints/legcuffs/bola/proc/ensnare(mob/living/carbon/C)
	if(!C.legcuffed && C.num_legs >= 2)
		visible_message(SPAN_DANGER("\The [src] ensnares [C]!"))
		C.legcuffed = src
		forceMove(C)
		C.update_equipment_speed_mods()
		C.update_inv_legcuffed()
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		to_chat(C, SPAN_USERDANGER("\The [src] ensnares you!"))
		C.Knockdown(knockdown)
		playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/**
 * A traitor variant of the bola.
 *
 * It knocks people down and is harder to remove.
 */
/obj/item/restraints/legcuffs/bola/steel
	name = "reinforced bola"
	desc = "A strong bola, made with a long steel chain. It looks heavy, enough so that it could trip somebody."
	icon_state = "bola_r"
	inhand_icon_state = "bola_r"
	breakouttime = 7 SECONDS
	knockdown = 3.5 SECONDS
