/turf/open/space
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	name = "\proper space"
	intact = 0

	plane = PLANE_SPACE
	layer = SPACE_LAYER
	light_power = 0.25
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	bullet_bounce_sound = null
	vis_flags = VIS_INHERIT_ID //when this be added to vis_contents of something it be associated with something on clicking, important for visualisation of turf in openspace and interraction with openspace that show you turf.

/turf/open/space/basic/New() //Do not convert to Initialize
	//This is used to optimize the map loader
	return

/**
 * Space Initialize
 *
 * Doesn't call parent, see [/atom/proc/Initialize]
 */
/turf/open/space/Initialize(mapload, inherited_virtual_z)
	SHOULD_CALL_PARENT(FALSE)
	if(inherited_virtual_z)
		virtual_z = inherited_virtual_z
	icon_state = SPACE_ICON_STATE
	vis_contents.Cut() //removes inherited overlays
	visibilityChanged()

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	if (length(smoothing_groups))
		sortTim(smoothing_groups) //In case it's not properly ordered, let's avoid duplicate entries with the same values.
		SET_BITFLAG_LIST(smoothing_groups)
	if (length(canSmoothWith))
		sortTim(canSmoothWith)
		if(canSmoothWith[length(canSmoothWith)] > MAX_S_TURF) //If the last element is higher than the maximum turf-only value, then it must scan turf contents for smoothing targets.
			smoothing_flags |= SMOOTH_OBJ
		SET_BITFLAG_LIST(canSmoothWith)

	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	if (light_system == STATIC_LIGHT && light_power && light_range)
		update_light()

	if (opacity)
		directional_opacity = ALL_CARDINALS

	var/turf/T = above()
	if(T)
		T.multiz_turf_new(src, DOWN)
	T = below()
	if(T)
		T.multiz_turf_new(src, UP)

	ComponentInitialize()

	return INITIALIZE_HINT_NORMAL

/turf/open/space/proc/update_starlight()
	if(CONFIG_GET(flag/starlight))
		for(var/t in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
			if(isspaceturf(t))
				//let's NOT update this that much pls
				continue
			set_light(2)
			return
		set_light(0)

/turf/open/space/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/turf/open/space/proc/CanBuildHere()
	return TRUE

/turf/open/space/handle_slip()
	return

/turf/open/space/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/space/acid_act(acidpwr, acid_volume)
	return FALSE

/turf/open/space/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/space.dmi'
	underlay_appearance.icon_state = SPACE_ICON_STATE
	underlay_appearance.plane = PLANE_SPACE
	return TRUE

/turf/open/space/openspace
	icon = 'icons/turf/floors.dmi'
	icon_state = "invisible"

/turf/open/space/openspace/Initialize(mapload) // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	overlays += GLOB.openspace_backdrop_one_for_all //Special grey square for projecting backdrop darkness filter on it.
	icon_state = "invisible"
	return INITIALIZE_HINT_LATELOAD

/turf/open/space/openspace/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, FALSE)

/turf/open/space/openspace/zAirIn()
	return TRUE

/turf/open/space/openspace/zAirOut()
	return TRUE

/// CODE DUPLICATED IN `code\game\turfs\open\openspace.dm`!!
/turf/open/space/openspace/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_DOWN || O.obj_flags & FULL_BLOCK_Z_ABOVE)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_UP || O.obj_flags & FULL_BLOCK_Z_BELOW)
				return FALSE
		return TRUE
	return FALSE

/// CODE DUPLICATED IN `code\game\turfs\open\openspace.dm`!!
/turf/open/space/openspace/zPassOut(atom/movable/A, direction, turf/destination)
	if(A.anchored)
		return FALSE
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_DOWN || O.obj_flags & FULL_BLOCK_Z_BELOW)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_UP || O.obj_flags & FULL_BLOCK_Z_ABOVE)
				return FALSE
		return TRUE
	return FALSE
