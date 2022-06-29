/atom/proc/CanAtmosPass(turf/T, vertical = FALSE)
	switch (CanAtmosPass)
		if (ATMOS_PASS_PROC)
			return ATMOS_PASS_YES
		if (ATMOS_PASS_DENSITY)
			return !density
		else
			return CanAtmosPass

///Do NOT use this to see if 2 turfs are connected, it mutates state, and we cache that info anyhow.
///Use TURFS_CAN_SHARE or TURF_SHARES depending on your usecase
/turf/open/CanAtmosPass(turf/target_turf, vertical = FALSE)
	var/can_pass = TRUE
	var/direction = vertical ? get_dir_multiz(src, target_turf) : get_dir(src, target_turf)
	//var/opposite_direction = REVERSE_DIR(direction)
	if(vertical && !(zAirOut(direction, target_turf) && target_turf.zAirIn(direction, src)))
		can_pass = FALSE
	if(blocks_air || target_turf.blocks_air)
		can_pass = FALSE
	//This path is a bit weird, if we're just checking with ourselves no sense asking objects on the turf
	if (target_turf == src)
		return can_pass

	//Can't just return if canpass is false here, we need to set superconductivity
	for(var/obj/checked_object in contents + target_turf.contents)
		var/turf/other = (checked_object.loc == src ? target_turf : src)
		if(CANATMOSPASS(checked_object, other, vertical))
			continue
		can_pass = FALSE

	return can_pass

/turf/proc/ImmediateCalculateAdjacentTurfs()
	//Basic optimization, if we can't share why bother asking other people ya feel?
	var/canpass = CANATMOSPASS(src, src, FALSE)
	for(var/direction in GLOB.cardinals_multiz)
		var/turf/current_turf = get_step_multiz(src, direction)
		if(!isopenturf(current_turf)) // not interested in you brother
			continue
		//Can you and me form a deeper relationship, or is this just a passing wind
		// (direction & (UP | DOWN)) is just "is this vertical" by the by
		if(canpass && CANATMOSPASS(current_turf, src, (direction & (UP|DOWN))) && !(blocks_air || current_turf.blocks_air))
			LAZYINITLIST(atmos_adjacent_turfs)
			LAZYINITLIST(current_turf.atmos_adjacent_turfs)
			atmos_adjacent_turfs[current_turf] = TRUE
			current_turf.atmos_adjacent_turfs[src] = TRUE
		else
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= current_turf
			if (current_turf.atmos_adjacent_turfs)
				current_turf.atmos_adjacent_turfs -= src
			UNSETEMPTY(current_turf.atmos_adjacent_turfs)
	UNSETEMPTY(atmos_adjacent_turfs)
	src.atmos_adjacent_turfs = atmos_adjacent_turfs
	update_adjacent_pollutants() //Atmos adjacency could unlock/block adjacent pollutants, this is dirty flags anyway so its fine having it here

//returns a list of adjacent turfs that can share air with this one.
//alldir includes adjacent diagonal tiles that can share
// air with both of the related adjacent cardinal tiles
/turf/proc/GetAtmosAdjacentTurfs(alldir = 0)
	var/adjacent_turfs
	if (atmos_adjacent_turfs)
		adjacent_turfs = atmos_adjacent_turfs.Copy()
	else
		adjacent_turfs = list()

	if (!alldir)
		return adjacent_turfs

	var/turf/curloc = src

	for (var/direction in GLOB.diagonals_multiz)
		var/matchingDirections = 0
		var/turf/S = get_step_multiz(curloc, direction)
		if(!S)
			continue

		for (var/checkDirection in GLOB.cardinals_multiz)
			var/turf/checkTurf = get_step(S, checkDirection)
			if(!S.atmos_adjacent_turfs || !S.atmos_adjacent_turfs[checkTurf])
				continue

			if (adjacent_turfs[checkTurf])
				matchingDirections++

			if (matchingDirections >= 2)
				adjacent_turfs += S
				break

	return adjacent_turfs

/atom/proc/air_update_turf(update = FALSE, remove = FALSE)
	var/turf/T = get_turf(loc)
	if(!T)
		return
	T.air_update_turf(update, remove)

/turf/air_update_turf(update = FALSE, remove = FALSE)
	ImmediateCalculateAdjacentTurfs()

/atom/proc/temperature_expose(exposed_temperature, exposed_volume)
	return null



/turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)
	return

/**
 * Handles the creation of hotspots and initial activation of turfs.
 * Setting the conditions for the reaction to actually happen for gasmixtures
 * is handled by the hotspot itself, specifically perform_exposure().
 */
/turf/open/hotspot_expose(exposed_temperature, exposed_volume, soh)
	return


/**
 * Hotspot objects interfaces with the temperature of turf gasmixtures while also providing visual effects.
 * One important thing to note about hotspots are that they can roughly be divided into two categories based on the bypassing variable.
 */
/obj/effect/hotspot
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	layer = GASFIRE_LAYER
	blend_mode = BLEND_ADD
	light_system = MOVABLE_LIGHT
	light_range = LIGHT_RANGE_FIRE
	light_power = 1
	light_color = LIGHT_COLOR_FIRE
	ambience = AMBIENCE_FIRE

	/**
	 * Volume is the representation of how big and healthy a fire is.
	 * Hotspot volume will be divided by turf volume to get the ratio for temperature setting on non bypassing mode.
	 * Also some visual stuffs for fainter fires.
	 */
	var/volume = 125
	/// Temperature handles the initial ignition and the colouring.
	var/temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	/// Whether the hotspot is new or not. Used for bypass logic.
	var/just_spawned = TRUE
	/// Whether the hotspot becomes passive and follows the gasmix temp instead of changing it.
	var/bypassing = FALSE
	var/visual_update_tick = 0

#define IGNITE_TURF_CHANCE 30
#define IGNITE_TURF_LOW_POWER 8
#define IGNITE_TURF_HIGH_POWER 22

/obj/effect/hotspot/Initialize(mapload, starting_volume, starting_temperature)
	. = ..()
	if(!isnull(starting_volume))
		volume = starting_volume
	if(!isnull(starting_temperature))
		temperature = starting_temperature
	perform_exposure()
	setDir(pick(GLOB.cardinals))
	air_update_turf(FALSE, FALSE)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, src, loc_connections)

	if(prob(IGNITE_TURF_CHANCE))
		var/turf/my_turf = loc
		my_turf.IgniteTurf(rand(IGNITE_TURF_LOW_POWER,IGNITE_TURF_HIGH_POWER))

#undef IGNITE_TURF_CHANCE
#undef IGNITE_TURF_LOW_POWER
#undef IGNITE_TURF_HIGH_POWER

/**
 * Perform interactions between the hotspot and the gasmixture.
 *
 * For the first tick, hotspots will take a sample of the air in the turf,
 * set the temperature equal to a certain amount, and then reacts it.
 * In some implementations the ratio comes out to around 1, so all of the air in the turf.
 *
 * Afterwards if the reaction is big enough it mostly just tags along the fire,
 * copying the temperature and handling the colouring.
 * If the reaction is too small it will perform like the first tick.
 *
 * Also calls fire_act() which handles burning.
 */
/obj/effect/hotspot/proc/perform_exposure()
	var/turf/open/location = loc
	if(!istype(location))
		return
	// Handles the burning of atoms.
	for(var/A in location)
		var/atom/AT = A
		if(!QDELETED(AT) && AT != src)
			AT.fire_act(temperature, volume)

/// Mathematics to be used for color calculation.
/obj/effect/hotspot/proc/gauss_lerp(x, x1, x2)
	var/b = (x1 + x2) * 0.5
	var/c = (x2 - x1) / 6
	return NUM_E ** -((x - b) ** 2 / (2 * c) ** 2)

/obj/effect/hotspot/proc/update_color()
	cut_overlays()

	var/heat_r = heat2colour_r(temperature)
	var/heat_g = heat2colour_g(temperature)
	var/heat_b = heat2colour_b(temperature)
	var/heat_a = 255
	var/greyscale_fire = 1 //This determines how greyscaled the fire is.

	if(temperature < 5000) //This is where fire is very orange, we turn it into the normal fire texture here.
		var/normal_amt = gauss_lerp(temperature, 1000, 3000)
		heat_r = LERP(heat_r,255,normal_amt)
		heat_g = LERP(heat_g,255,normal_amt)
		heat_b = LERP(heat_b,255,normal_amt)
		heat_a -= gauss_lerp(temperature, -5000, 5000) * 128
		greyscale_fire -= normal_amt
	if(temperature > 40000) //Past this temperature the fire will gradually turn a bright purple
		var/purple_amt = temperature < LERP(40000,200000,0.5) ? gauss_lerp(temperature, 40000, 200000) : 1
		heat_r = LERP(heat_r,255,purple_amt)
	if(temperature > 200000 && temperature < 500000) //Somewhere at this temperature nitryl happens.
		var/sparkle_amt = gauss_lerp(temperature, 200000, 500000)
		var/mutable_appearance/sparkle_overlay = mutable_appearance('icons/effects/effects.dmi', "shieldsparkles")
		sparkle_overlay.blend_mode = BLEND_ADD
		sparkle_overlay.alpha = sparkle_amt * 255
		add_overlay(sparkle_overlay)
	if(temperature > 400000 && temperature < 1500000) //Lightning because very anime.
		var/mutable_appearance/lightning_overlay = mutable_appearance(icon, "overcharged")
		lightning_overlay.blend_mode = BLEND_ADD
		add_overlay(lightning_overlay)
	if(temperature > 4500000) //This is where noblium happens. Some fusion-y effects.
		var/fusion_amt = temperature < LERP(4500000,12000000,0.5) ? gauss_lerp(temperature, 4500000, 12000000) : 1
		var/mutable_appearance/fusion_overlay = mutable_appearance('icons/effects/atmospherics.dmi', "fusion_gas")
		fusion_overlay.blend_mode = BLEND_ADD
		fusion_overlay.alpha = fusion_amt * 255
		var/mutable_appearance/rainbow_overlay = mutable_appearance('icons/hud/screen_gen.dmi', "druggy")
		rainbow_overlay.blend_mode = BLEND_ADD
		rainbow_overlay.alpha = fusion_amt * 255
		rainbow_overlay.appearance_flags = RESET_COLOR
		heat_r = LERP(heat_r,150,fusion_amt)
		heat_g = LERP(heat_g,150,fusion_amt)
		heat_b = LERP(heat_b,150,fusion_amt)
		add_overlay(fusion_overlay)
		add_overlay(rainbow_overlay)

	set_light_color(rgb(LERP(250, heat_r, greyscale_fire), LERP(160, heat_g, greyscale_fire), LERP(25, heat_b, greyscale_fire)))

	heat_r /= 255
	heat_g /= 255
	heat_b /= 255

	color = list(LERP(0.3, 1, 1-greyscale_fire) * heat_r,0.3 * heat_g * greyscale_fire,0.3 * heat_b * greyscale_fire, 0.59 * heat_r * greyscale_fire,LERP(0.59, 1, 1-greyscale_fire) * heat_g,0.59 * heat_b * greyscale_fire, 0.11 * heat_r * greyscale_fire,0.11 * heat_g * greyscale_fire,LERP(0.11, 1, 1-greyscale_fire) * heat_b, 0,0,0)
	alpha = heat_a
/**
 * Regular process proc for hotspots governed by the controller.
 * Handles the calling of perform_exposure() which handles the bulk of temperature processing.
 * Burning or fire_act() are also called by perform_exposure().
 * Also handles the dying and qdeletion of the hotspot and hotspot creations on adjacent cardinal turfs.
 * And some visual stuffs too! Colors and fainter icons for specific conditions.
 */
/obj/effect/hotspot/process()
	if(just_spawned)
		just_spawned = FALSE
		return

	var/turf/open/location = loc
	if(!istype(location))
		qdel(src)
		return

	if((temperature < FIRE_MINIMUM_TEMPERATURE_TO_EXIST) || (volume <= 1))
		qdel(src)
		return

	//Not enough / nothing to burn
	if(prob(30))
		qdel(src)
		return

	perform_exposure()

	if(bypassing)
		icon_state = "3"
		location.burn_tile()

	else
		if(volume > CELL_VOLUME*0.4)
			icon_state = "2"
		else
			icon_state = "1"

	if((visual_update_tick++ % 7) == 0)
		update_color()

	return TRUE

/obj/effect/hotspot/Destroy()
	var/turf/open/T = loc
	if(istype(T) && T.active_hotspot == src)
		T.active_hotspot = null
	return ..()

/obj/effect/hotspot/proc/on_entered(datum/source, atom/movable/arrived, direction)
	SIGNAL_HANDLER
	if(isliving(arrived))
		var/mob/living/immolated = arrived
		immolated.fire_act(temperature, volume)

/obj/effect/dummy/lighting_obj/moblight/fire
	name = "fire"
	light_color = LIGHT_COLOR_FIRE
	light_range = LIGHT_RANGE_FIRE

