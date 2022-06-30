// dir determines the direction of travel to go upwards
// slope require /turf/open/openspace as the tile above them to work, unless your slope have 'force_open_above' set to TRUE
// multiple stair objects can be chained together; the Z level transition will happen on the final stair object in the chain

/obj/structure/slope
	name = "slope"
	icon = 'icons/obj/structures/slopes.dmi'
	icon_state = "stairs"
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE

/obj/structure/slope/Initialize(mapload)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = .proc/on_exit,
	)
	AddElement(/datum/element/connect_loc, src, loc_connections)
	update_appearance()
	return ..()

/obj/structure/slope/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(!isobserver(leaving) && direction == dir)
		INVOKE_ASYNC(src, .proc/stair_ascend, leaving)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/slope/proc/get_openspace_above_turf()
	var/turf/my_turf = get_turf(src)
	var/turf/checking = get_step_multiz(my_turf, UP)
	if(!checking)
		return
	if(!checking.zPassIn(src, UP, my_turf))
		return
	return checking

/obj/structure/slope/proc/get_slope_destination()
	var/turf/checking = get_openspace_above_turf()
	if(!checking)
		return
	var/turf/target = get_step(checking, dir)
	return target

/obj/structure/slope/proc/stair_ascend(atom/movable/AM)
	var/turf/checking = get_openspace_above_turf()
	if(!checking)
		return
	if(!checking.zPassIn(AM, UP, get_turf(src)))
		return
	var/turf/target = get_slope_destination()
	if(!target)
		return
	if(isliving(AM))
		var/mob/living/L = AM
		if(!L.buckled)
			L.forceMove(target, TRUE)
	else
		AM.forceMove(target, TRUE)

/obj/structure/slope/intercept_zImpact(atom/movable/AM, levels = 1)
	. = ..()
	if(levels <= 1)
		. |= FALL_GRACEFUL

/obj/structure/slope/stone
	name = "stone slope"
	icon_state = "stairs"
	anchored = TRUE

/obj/structure/slope/stone/directional/north
	dir = NORTH

/obj/structure/slope/stone/directional/south
	dir = SOUTH

/obj/structure/slope/stone/directional/east
	dir = EAST

/obj/structure/slope/stone/directional/west
	dir = WEST

/obj/structure/slope/stone_brick
	name = "stone stairs"
	icon_state = "stairs"
	anchored = TRUE

/obj/structure/slope/stone_brick/directional/north
	dir = NORTH

/obj/structure/slope/stone_brick/directional/south
	dir = SOUTH

/obj/structure/slope/stone_brick/directional/east
	dir = EAST

/obj/structure/slope/stone_brick/directional/west
	dir = WEST

/obj/structure/slope/sandstone
	name = "sandstone stairs"
	icon_state = "stairs"
	anchored = TRUE

/obj/structure/slope/sandstone/directional/north
	dir = NORTH

/obj/structure/slope/sandstone/directional/south
	dir = SOUTH

/obj/structure/slope/sandstone/directional/east
	dir = EAST

/obj/structure/slope/sandstone/directional/west
	dir = WEST

/obj/structure/slope/grass
	name = "grass slope"
	icon_state = "stairs"
	anchored = TRUE

/obj/structure/slope/grass/directional/north
	dir = NORTH

/obj/structure/slope/grass/directional/south
	dir = SOUTH

/obj/structure/slope/grass/directional/east
	dir = EAST

/obj/structure/slope/grass/directional/west
	dir = WEST

/obj/structure/slope/sand
	name = "sand slope"
	icon_state = "stairs"
	anchored = TRUE

/obj/structure/slope/sand/directional/north
	dir = NORTH

/obj/structure/slope/sand/directional/south
	dir = SOUTH

/obj/structure/slope/sand/directional/east
	dir = EAST

/obj/structure/slope/sand/directional/west
	dir = WEST

/obj/structure/slope/dirt
	name = "dirt slope"
	icon_state = "stairs"
	anchored = TRUE

/obj/structure/slope/dirt/directional/north
	dir = NORTH

/obj/structure/slope/dirt/directional/south
	dir = SOUTH

/obj/structure/slope/dirt/directional/east
	dir = EAST

/obj/structure/slope/dirt/directional/west
	dir = WEST
