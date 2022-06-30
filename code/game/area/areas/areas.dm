/area/space
	name = "Space"

/**
 * Update the icon of the area (overridden to always be null for space
 */
/area/space/update_icon_state()
	SHOULD_CALL_PARENT(FALSE)
	icon_state = null

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	has_gravity = STANDARD_GRAVITY

/area/testroom
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	name = "Test Room"
	icon_state = "purple"

/area/outdoors
	icon_state = "green"
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS
	main_ambience = AMBIENCE_JUNGLE
	outdoors = TRUE

/area/outdoors/jungle
	name = "Jungle"
	icon_state = "green"

/area/outdoors/coast
	name = "Coast"
	icon_state = "yellow"

/area/outdoors/caves
	name = "Caves"
	icon_state = "cave"
	underground = TRUE

/area/indoors
	icon_state = "mining"
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED | NO_ALERTS
	main_ambience = AMBIENCE_AWAY
	outdoors = FALSE

/area/indoors/house
	name = "House"

/area/centcom/supplypod/supplypod_temp_holding
	name = "Supplypod Shipping lane"

/area/centcom/supplypod
	name = "Supplypod Facility"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/centcom/supplypod/pod_storage
	name = "Supplypod Storage"

/area/centcom/supplypod/loading
	name = "Supplypod Loading Facility"
	var/loading_id = ""

/area/centcom/supplypod/loading/Initialize()
	. = ..()
	if(!loading_id)
		CRASH("[type] created without a loading_id")
	if(GLOB.supplypod_loading_bays[loading_id])
		CRASH("Duplicate loading bay area: [type] ([loading_id])")
	GLOB.supplypod_loading_bays[loading_id] = src

/area/centcom/supplypod/loading/one
	name = "Bay #1"
	loading_id = "1"

/area/centcom/supplypod/loading/two
	name = "Bay #2"
	loading_id = "2"

/area/centcom/supplypod/loading/three
	name = "Bay #3"
	loading_id = "3"

/area/centcom/supplypod/loading/four
	name = "Bay #4"
	loading_id = "4"

/area/centcom/supplypod/loading/ert
	name = "ERT Bay"
	loading_id = "5"
