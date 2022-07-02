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
	/// Whether this landmark is a fallback spawn spot.
	var/fallback = FALSE
	/// Whether the landmark is a roundstart spawn spot.
	var/roundstart = FALSE
	/// Whether the landmark is a latejoin spawn spot. A landmark can be both roundstart and latejoin
	var/latejoin = FALSE
	/// Whether someone spawned from this landmark on roundstart.
	var/spawned_roundstart = FALSE
	/// The next time someone can spawn from this landmark on latejoin.
	var/next_latejoin_spawn = 0
	/// The job listing this landmark belongs to. This is required with the exception of the fallback spawner.
	var/job_listing_type
	/// The job type this landmark belongs to. A listing is required to make job specific spawns
	var/job_type

/obj/effect/landmark/start/Initialize()
	. = ..()
	if(name != "start")
		tag = "start*[name]"
	
	if(fallback)
		SSjob.fallback_landmarks += src
	if(job_listing_type)
		var/datum/job_listing/listing = SSjob.type_job_listings[job_listing_type]
		if(!listing)
			stack_trace("Missing job listing for a landmark. Listing: [job_listing_type]")
			return
		if(job_type)
			if(roundstart)
				if(!listing.job_start_landmarks[job_type])
					listing.job_start_landmarks[job_type] = list()
				listing.job_start_landmarks[job_type] += src
			if(latejoin)
				if(!listing.job_latejoin_landmarks[job_type])
					listing.job_latejoin_landmarks[job_type] = list()
				listing.job_latejoin_landmarks[job_type] += src
		else
			if(roundstart)
				listing.start_landmarks += src
			if(latejoin)
				listing.latejoin_landmarks += src


/obj/effect/landmark/start/Destroy()
	if(fallback)
		SSjob.fallback_landmarks -= src
	if(job_listing_type)
		var/datum/job_listing/listing = SSjob.type_job_listings[job_listing_type]
		if(!listing)
			stack_trace("Missing job listing for a landmark. Listing: [job_listing_type]")
			return ..()
		if(job_type)
			if(roundstart)
				listing.job_start_landmarks[job_type] -= src
				if(!length(listing.job_start_landmarks[job_type]))
					listing.job_start_landmarks -= job_type
			if(latejoin)
				listing.job_latejoin_landmarks[job_type] -= src
				if(!length(listing.job_latejoin_landmarks[job_type]))
					listing.job_latejoin_landmarks -= job_type
		else
			if(roundstart)
				listing.start_landmarks -= src
			if(latejoin)
				listing.latejoin_landmarks -= src
	return ..()

/obj/effect/landmark/start/fallback
	fallback = TRUE

/obj/effect/landmark/start/settlers
	job_listing_type = /datum/job_listing/settlers
	roundstart = TRUE
	latejoin = TRUE

/obj/effect/landmark/start/port
	job_listing_type = /datum/job_listing/port
	roundstart = TRUE
	latejoin = TRUE

/obj/effect/landmark/start/pirate
	job_listing_type = /datum/job_listing/pirate
	roundstart = TRUE
	latejoin = TRUE

/obj/effect/landmark/start/native
	job_listing_type = /datum/job_listing/native
	roundstart = TRUE
	latejoin = TRUE

/obj/effect/landmark/start/undefined
	job_listing_type = /datum/job_listing/undefined
	roundstart = TRUE
	latejoin = TRUE


// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/new_player)

/obj/effect/landmark/new_player
	name = "New Player"

/obj/effect/landmark/new_player/Initialize()
	..()
	GLOB.newplayer_start += src

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

/obj/effect/landmark/error
	name = "error"
	icon_state = "error_room"
