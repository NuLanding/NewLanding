/// Max number of unanchored items that will be moved from a tile when attempting to add a window to a grille.
#define CLEAR_TILE_MOVE_LIMIT 20

/obj/structure/grille
	desc = "A flimsy framework of iron rods."
	name = "grille"
	icon = 'icons/obj/smooth_structures/grille.dmi'
	icon_state = "grille-0"
	base_icon_state = "grille"
	color = "#545454"
	density = TRUE
	anchored = TRUE
	pass_flags_self = PASSGRILLE
	flags_1 = CONDUCT_1 | RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	armor = list(MELEE = 50, BULLET = 70, LASER = 70, ENERGY = 100, BOMB = 10, BIO = 100, RAD = 100, FIRE = 0, ACID = 0)
	max_integrity = 50
	integrity_failure = 0.4
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_GRILLE)
	canSmoothWith = list(SMOOTH_GROUP_GRILLE)
	var/rods_type = /obj/item/stack/rods
	var/rods_amount = 2
	var/rods_broken = TRUE

/obj/structure/grille/update_appearance(updates)
	if(QDELETED(src))
		return
	. = ..()

/obj/structure/grille/update_icon_state()
	. = ..()
	if(broken)
		icon_state = "brokengrille"

/obj/structure/grille/set_smoothed_icon_state(new_junction)
	if(broken)
		return
	return ..()

/obj/structure/grille/examine(mob/user)
	. = ..()
	if(anchored)
		. += SPAN_NOTICE("It's secured in place with <b>screws</b>. The rods look like they could be <b>cut</b> through.")
	if(!anchored)
		. += SPAN_NOTICE("The anchoring screws are <i>unscrewed</i>. The rods look like they could be <b>cut</b> through.")

/obj/structure/grille/Bumped(atom/movable/AM)
	if(!ismob(AM))
		return
	var/mob/M = AM
	shock(M, 70)

/obj/structure/grille/attack_animal(mob/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(!shock(user, 70) && !QDELETED(src)) //Last hit still shocks but shouldn't deal damage to the grille
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/grille/hulk_damage()
	return 60

/obj/structure/grille/attack_hulk(mob/living/carbon/human/user)
	if(shock(user, 70))
		return
	. = ..()

/obj/structure/grille/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src, ATTACK_EFFECT_KICK)
	user.visible_message(SPAN_WARNING("[user] hits [src]."), null, null, COMBAT_MESSAGE_RANGE)
	log_combat(user, src, "hit")
	if(!shock(user, 70))
		take_damage(rand(5,10), BRUTE, MELEE, 1)

/obj/structure/grille/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(!. && istype(mover, /obj/projectile))
		return prob(30)

/obj/structure/grille/CanAStarPass(obj/item/ID, to_dir, atom/movable/caller)
	. = !density
	if(istype(caller))
		. = . || (caller.pass_flags & PASSGRILLE)

/obj/structure/grille/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		if(!shock(user, 100))
			W.play_tool_sound(src, 100)
			deconstruct()
	else if((W.tool_behaviour == TOOL_SCREWDRIVER) && (isturf(loc) || anchored))
		if(!shock(user, 90))
			W.play_tool_sound(src, 100)
			set_anchored(!anchored)
			user.visible_message(SPAN_NOTICE("[user] [anchored ? "fastens" : "unfastens"] [src]."), \
				SPAN_NOTICE("You [anchored ? "fasten [src] to" : "unfasten [src] from"] the floor."))
			return
	else if(istype(W, /obj/item/stack/rods) && broken)
		var/obj/item/stack/rods/R = W
		if(!shock(user, 90))
			user.visible_message(SPAN_NOTICE("[user] rebuilds the broken grille."), \
				SPAN_NOTICE("You rebuild the broken grille."))
			repair_grille()
			R.use(1)
			return

	//Try place window on the grille if the sheet supports it
	else if(istype(W, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/my_sheet = W
		if(my_sheet.try_install_window(user, src.loc, src))
			return TRUE

	else if(istype(W, /obj/item/shard) || !shock(user, 70))
		return ..()

/obj/structure/grille/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'sound/effects/grillehit.ogg', 80, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 80, TRUE)


/obj/structure/grille/deconstruct(disassembled = TRUE)
	if(!loc) //if already qdel'd somehow, we do nothing
		return
	if(!(flags_1&NODECONSTRUCT_1))
		var/obj/R = new rods_type(drop_location(), rods_amount)
		transfer_fingerprints_to(R)
		qdel(src)
	..()

/obj/structure/grille/obj_break()
	. = ..()
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		set_density(FALSE)
		obj_integrity = 20
		broken = TRUE
		rods_amount = 1
		rods_broken = FALSE
		var/obj/R = new rods_type(drop_location(), rods_broken)
		transfer_fingerprints_to(R)
		smoothing_flags = NONE
		update_appearance()

/obj/structure/grille/proc/repair_grille()
	if(broken)
		set_density(TRUE)
		obj_integrity = max_integrity
		broken = FALSE
		rods_amount = 2
		rods_broken = TRUE
		smoothing_flags = SMOOTH_BITMASK
		QUEUE_SMOOTH(src)
		update_appearance()
		return TRUE
	return FALSE

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user, prb)
	if(!anchored || broken) // anchored/broken grilles are never connected
		return FALSE
	if(!prob(prb))
		return FALSE
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return FALSE
	return FALSE

/obj/structure/grille/get_dumping_location(datum/component/storage/source,mob/user)
	return null

/obj/structure/grille/broken // Pre-broken grilles for map placement
	density = FALSE
	broken = TRUE
	rods_amount = 1
	rods_broken = FALSE

/obj/structure/grille/broken/Initialize(mapload)
	. = ..()
	take_damage(max_integrity * 0.6)
