#define GIRDER_PASSCHANCE_NORMAL 20
#define GIRDER_PASSCHANCE_UNANCHORED 25
#define GIRDER_PASSCHANCE_REINFORCED 0

/obj/structure/girder
	name = "girder"
	icon_state = "girder"
	desc = "A large structural assembly made out of metal; It requires a layer of iron before it can be considered a wall."
	anchored = TRUE
	density = TRUE
	max_integrity = 200
	flags_1 = RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1
	rad_insulation = RAD_VERY_LIGHT_INSULATION
	var/state = GIRDER_NORMAL
	var/girderpasschance = GIRDER_PASSCHANCE_NORMAL // percentage chance that a projectile passes through the girder.
	var/can_displace = TRUE //If the girder can be moved around by wrenching it
	var/next_beep = 0 //Prevents spamming of the construction sound
	/// What material is this girder reinforced by
	var/reinforced_material
	/// Paint to apply to the wall built. Matters for deconstructed and reconstructed walls
	var/wall_paint
	/// Stripe paint to apply to the wall built. Matters for deconstructed and reconstructed walls
	var/stripe_paint

/obj/structure/girder/Initialize(mapload, reinforced_mat, new_paint, new_stripe_paint, unanchored)
	. = ..()
	wall_paint = new_paint
	stripe_paint = new_stripe_paint
	if(unanchored)
		set_anchored(FALSE)
		girderpasschance = GIRDER_PASSCHANCE_UNANCHORED
	if(reinforced_mat)
		reinforced_material = reinforced_mat
		state = GIRDER_REINF
		update_appearance()

/obj/structure/girder/update_name()
	. = ..()
	if(!anchored)
		name = "displaced girder"
	else if (state == GIRDER_NORMAL)
		name = "girder"
	else
		name = "reinforced girder"

/obj/structure/girder/update_icon_state()
	. = ..()
	if(!anchored)
		icon_state = "displaced"
	else if (state == GIRDER_NORMAL)
		icon_state = "girder"
	else
		icon_state = "reinforced"

/obj/structure/girder/examine(mob/user)
	. = ..()
	switch(state)
		if(GIRDER_REINF)
			. += SPAN_NOTICE("It's reinforcement can be <b>screwed</b> off.")
		if(GIRDER_REINF_STRUTS)
			. += SPAN_NOTICE("The reinforcement struts can be <b>reinforced</b> with a material or <b>cut</b> off.")
		if(GIRDER_NORMAL)
			. += SPAN_NOTICE("The girder can be prepared for reinforcement with <b>rods</b>.")
	if(anchored)
		if(can_displace)
			. += SPAN_NOTICE("The bolts are <b>wrenched</b> in place.")
	else
		. += SPAN_NOTICE("The bolts are <i>loosened</i>, but the <b>screws</b> are holding [src] together.")

/obj/structure/girder/attackby(obj/item/W, mob/user, params)
	var/platingmodifier = 1
	if(HAS_TRAIT(user, TRAIT_QUICK_BUILD))
		platingmodifier = 0.7
		if(next_beep <= world.time)
			next_beep = world.time + 10
			playsound(src, 'sound/machines/clockcult/integration_cog_install.ogg', 50, TRUE)
	add_fingerprint(user)

	if(istype(W, /obj/item/stack))
		if(iswallturf(loc))
			to_chat(user, SPAN_WARNING("There is already a wall present!"))
			return
		if(!isfloorturf(src.loc))
			to_chat(user, SPAN_WARNING("A floor must be present to build a false wall!"))
			return
		if (locate(/obj/structure/falsewall) in src.loc.contents)
			to_chat(user, SPAN_WARNING("There is already a false wall present!"))
			return

		if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/S = W
			if(state != GIRDER_NORMAL)
				return
			if(S.get_amount() < 2)
				to_chat(user, SPAN_WARNING("You need two rods to place reinforcement struts!"))
				return
			to_chat(user, SPAN_NOTICE("You start placing reinforcement struts..."))
			if(do_after(user, 20*platingmodifier, target = src))
				if(S.get_amount() < 2)
					return
				if(state != GIRDER_NORMAL)
					return
				to_chat(user, SPAN_NOTICE("You place reinforcement struts."))
				S.use(2)
				state = GIRDER_REINF_STRUTS
				update_appearance()

		if(!istype(W, /obj/item/stack/sheet))
			return

		var/obj/item/stack/sheet/S = W
		if(S.get_amount() < 2)
			to_chat(user, SPAN_WARNING("You need two sheets of [S]!"))
			return
		if(state == GIRDER_REINF_STRUTS)
			to_chat(user, SPAN_NOTICE("You start reinforcing the girder..."))
			if(do_after(user, 20*platingmodifier, target = src))
				if(state != GIRDER_REINF_STRUTS)
					return
				if(S.get_amount() < 2)
					return
				S.use(2)
				state = GIRDER_REINF
				reinforced_material = S.material_type
				update_appearance()
			return
		else
			var/datum/material/plating_mat_ref = GET_MATERIAL_REF(S.material_type)
			var/wall_type = plating_mat_ref.wall_type
			if(!wall_type)
				to_chat(user, SPAN_WARNING("You can't figure out how to make a wall out of this!"))
				return
			if(anchored)
				to_chat(user, SPAN_NOTICE("You start adding plating..."))
			else
				to_chat(user, SPAN_NOTICE("You start adding plating, creating a false wall..."))
			if (do_after(user, 40*platingmodifier, target = src))
				if(S.get_amount() < 2)
					return
				S.use(2)
				if(anchored)
					to_chat(user, SPAN_NOTICE("You add the plating."))
				else
					to_chat(user, SPAN_NOTICE("You create the false wall."))
				var/turf/T = get_turf(src)
				if(anchored)
					//Build a normal wall
					T.PlaceOnTop(wall_type)
					var/turf/closed/wall/placed_wall = T
					transfer_fingerprints_to(placed_wall)
				else
					//Build a false wall
					var/false_wall_type = plating_mat_ref.false_wall_type
					var/obj/structure/falsewall/false_wall = new false_wall_type(T)
					transfer_fingerprints_to(false_wall)
				qdel(src)

		add_hiddenprint(user)

	else
		return ..()

// Screwdriver behavior for girders
/obj/structure/girder/screwdriver_act(mob/user, obj/item/tool)
	if(..())
		return TRUE

	. = FALSE
	if(state == GIRDER_REINF)
		to_chat(user, SPAN_NOTICE("You start removing the reinforcement..."))
		if(tool.use_tool(src, user, 40, volume=100))
			if(state != GIRDER_REINF)
				return
			to_chat(user, SPAN_NOTICE("You remove the reinforcement."))
			state = GIRDER_REINF_STRUTS
			var/datum/material/reinf_mat_ref = GET_MATERIAL_REF(reinforced_material)
			new reinf_mat_ref.sheet_type(loc, 2)
			reinforced_material = null
			update_appearance()
		return TRUE

	else if(!anchored && state != GIRDER_REINF_STRUTS)
		user.visible_message(SPAN_WARNING("[user] disassembles the girder."),
			SPAN_NOTICE("You start to disassemble the girder..."),
			SPAN_HEAR("You hear clanking and banging noises."))
		if(tool.use_tool(src, user, 40, volume=100))
			if(anchored)
				return
			to_chat(user, SPAN_NOTICE("You disassemble the girder."))
			var/obj/item/stack/sheet/iron/M = new (loc, 2)
			M.add_fingerprint(user)
			qdel(src)
		return TRUE

// Wirecutter behavior for girders
/obj/structure/girder/wirecutter_act(mob/user, obj/item/tool)
	. = ..()
	if(state == GIRDER_REINF_STRUTS)
		to_chat(user, SPAN_NOTICE("You start removing the reinforcement struts..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, SPAN_NOTICE("You remove the reinforcement struts."))
			new /obj/item/stack/rods(get_turf(src), 2)
			state = GIRDER_NORMAL
			update_appearance()
		return TRUE

/obj/structure/girder/wrench_act(mob/user, obj/item/tool)
	. = ..()
	if(!anchored)
		if(!isfloorturf(loc))
			to_chat(user, SPAN_WARNING("A floor must be present to secure the girder!"))

		to_chat(user, SPAN_NOTICE("You start securing the girder..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, SPAN_NOTICE("You secure the girder."))
			set_anchored(TRUE)
			girderpasschance = GIRDER_PASSCHANCE_NORMAL
			update_appearance()
		return TRUE
	else if(state == GIRDER_NORMAL && can_displace)
		to_chat(user, SPAN_NOTICE("You start unsecuring the girder..."))
		if(tool.use_tool(src, user, 40, volume=100))
			to_chat(user, SPAN_NOTICE("You unsecure the girder."))
			set_anchored(FALSE)
			girderpasschance = GIRDER_PASSCHANCE_UNANCHORED
			update_appearance()
		return TRUE

/obj/structure/girder/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if((mover.pass_flags & PASSGRILLE) || istype(mover, /obj/projectile))
		return prob(girderpasschance)

/obj/structure/girder/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	. = !density
	if(istype(caller))
		. = . || (caller.pass_flags & PASSGRILLE)

/obj/structure/girder/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		var/remains = pick(/obj/item/stack/rods, /obj/item/stack/sheet/iron)
		new remains(loc)
	qdel(src)

/obj/structure/girder/displaced
	name = "displaced girder"
	anchored = FALSE
	girderpasschance = GIRDER_PASSCHANCE_UNANCHORED

/obj/structure/girder/reinforced
	name = "reinforced girder"
	state = GIRDER_REINF
	reinforced_material = /datum/material/iron
	girderpasschance = GIRDER_PASSCHANCE_REINFORCED
