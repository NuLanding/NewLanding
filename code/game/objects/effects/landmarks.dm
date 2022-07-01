/obj/effect/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

INITIALIZE_IMMEDIATE(/obj/effect/landmark)

/obj/effect/landmark/Initialize()
	. = ..()
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/jobspawn_override = FALSE
	var/delete_after_roundstart = TRUE
	var/used = FALSE

/obj/effect/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/obj/effect/landmark/start/Initialize()
	. = ..()
	SSjob.main_jobs.start_landmarks_list += src
	if(jobspawn_override)
		LAZYADDASSOCLIST(SSjob.main_jobs.jobspawn_overrides, name, src)
	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy()
	SSjob.main_jobs.start_landmarks_list -= src
	if(jobspawn_override)
		LAZYREMOVEASSOC(SSjob.main_jobs.jobspawn_overrides, name, src)
	return ..()

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/new_player)

/obj/effect/landmark/new_player
	name = "New Player"

/obj/effect/landmark/new_player/Initialize()
	..()
	GLOB.newplayer_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/Initialize(mapload)
	..()
	SSjob.main_jobs.latejoin_trackers += loc
	return INITIALIZE_HINT_QDEL

//space carps, magicarps, lone ops, slaughter demons, possibly revenants spawn here
/obj/effect/landmark/carpspawn
	name = "carpspawn"
	icon_state = "carp_spawn"

//observer start
/obj/effect/landmark/observer_start
	name = "Observer-Start"
	icon_state = "observer_start"

//xenos, morphs and nightmares spawn here
/obj/effect/landmark/xeno_spawn
	name = "xeno_spawn"
	icon_state = "xeno_spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload)
	..()
	GLOB.xeno_spawn += loc
	return INITIALIZE_HINT_QDEL

//objects with the stationloving component (nuke disk) respawn here.
//also blobs that have their spawn forcemoved (running out of time when picking their spawn spot) and santa
/obj/effect/landmark/blobstart
	name = "blobstart"
	icon_state = "blob_start"

/obj/effect/landmark/blobstart/Initialize(mapload)
	..()
	GLOB.blobstart += loc
	return INITIALIZE_HINT_QDEL

//spawns sec equipment lockers depending on the number of sec officers
/obj/effect/landmark/secequipment
	name = "secequipment"
	icon_state = "secequipment"

/obj/effect/landmark/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	return INITIALIZE_HINT_QDEL

//players that get put in admin jail show up here
/obj/effect/landmark/prisonwarp
	name = "prisonwarp"
	icon_state = "prisonwarp"

/obj/effect/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/ert_spawn
	name = "Emergencyresponseteam"
	icon_state = "ert_spawn"

/obj/effect/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	return INITIALIZE_HINT_QDEL

//ninja energy nets teleport victims here
/obj/effect/landmark/holding_facility
	name = "Holding Facility"
	icon_state = "holding_facility"

/obj/effect/landmark/holding_facility/Initialize(mapload)
	..()
	GLOB.holdingfacility += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/observe
	name = "tdomeobserve"
	icon_state = "tdome_observer"

/obj/effect/landmark/thunderdome/observe/Initialize(mapload)
	..()
	GLOB.tdomeobserve += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/one
	name = "tdome1"
	icon_state = "tdome_t1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload)
	..()
	GLOB.tdome1 += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/two
	name = "tdome2"
	icon_state = "tdome_t2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload)
	..()
	GLOB.tdome2 += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/admin
	name = "tdomeadmin"
	icon_state = "tdome_admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload)
	..()
	GLOB.tdomeadmin += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[GLOB.ruin_landmarks.len + 1]"
	..(loc)
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

// handled in portals.dm, id connected to one-way portal
/obj/effect/landmark/portal_exit
	name = "portal exit"
	icon_state = "portal_exit"
	var/id

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"


/obj/effect/landmark/start/hangover
	name = "hangover spawn"
	icon_state = "hangover_spawn"

/obj/effect/landmark/start/hangover/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/start/hangover/LateInitialize()
	. = ..()
	if(!HAS_TRAIT(SSstation, STATION_TRAIT_HANGOVER))
		return
	if(prob(60))
		new /obj/effect/decal/cleanable/vomit(get_turf(src))
	if(prob(70))
		var/bottle_count = rand(1, 3)
		for(var/index in 1 to bottle_count)
			var/turf/turf_to_spawn_on = get_step(src, pick(GLOB.alldirs))
			if(!isopenturf(turf_to_spawn_on))
				continue
			var/dense_object = FALSE
			for(var/atom/content in turf_to_spawn_on.contents)
				if(content.density)
					dense_object = TRUE
					break
			if(dense_object)
				continue
			new /obj/item/reagent_containers/food/drinks/beer/almost_empty(turf_to_spawn_on)

///Spawns the mob with some drugginess/drunkeness, and some disgust.
/obj/effect/landmark/start/hangover/proc/make_hungover(mob/hangover_mob)
	if(!iscarbon(hangover_mob))
		return
	var/mob/living/carbon/spawned_carbon = hangover_mob
	spawned_carbon.set_resting(TRUE, silent = TRUE)
	if(prob(50))
		spawned_carbon.adjust_drugginess(rand(15, 20))
	else
		spawned_carbon.drunkenness += rand(15, 25)
	spawned_carbon.adjust_disgust(rand(5, 55)) //How hungover are you?
	if(spawned_carbon.head)
		return

/obj/effect/landmark/start/hangover/JoinPlayerHere(mob/M, buckle)
	. = ..()
	make_hungover(M)

/obj/effect/landmark/start/hangover/closet
	name = "hangover spawn closet"
	icon_state = "hangover_spawn_closet"

/obj/effect/landmark/start/hangover/closet/JoinPlayerHere(mob/M, buckle)
	make_hungover(M)
	for(var/obj/structure/closet/closet in contents)
		if(closet.opened)
			continue
		M.forceMove(closet)
		return
	..() //Call parent as fallback

/obj/effect/landmark/error
	name = "error"
	icon_state = "error_room"
