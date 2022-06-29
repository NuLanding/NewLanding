/turf/open/floor/grass
	name = "grass"
	desc = "A patch of grass."
	icon = 'icons/turf/floors/grass.dmi'
	icon_state = "grass0"
	base_icon_state = "grass"
	baseturfs = /turf/open/floor/rock
	bullet_bounce_sound = null
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_GRASS)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_GRASS)
	layer = HIGH_TURF_LAYER
	var/smooth_icon = 'icons/turf/floors/grass.dmi'

/turf/open/floor/grass/setup_broken_states()
	return list("damaged")

/turf/open/floor/grass/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-9, -9)
		transform = translation
		icon = smooth_icon

/turf/open/floor/dirt
	gender = PLURAL
	name = "dirt"
	desc = "Upon closer examination, it's still dirt."
	icon = 'icons/turf/floors/common.dmi'
	icon_state = "cracked_dirt"
	base_icon_state = "cracked_dirt"
	baseturfs = /turf/open/floor/rock
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/rock
	name = "rock"
	icon = 'icons/turf/floors/common.dmi'
	icon_state = "rock_floor"
	base_icon_state = "rock_floor"
	baseturfs = /turf/open/floor/rock
	color = "#707070"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/mud
	gender = PLURAL
	name = "mud"
	desc = "Thick, claggy and waterlogged."
	icon = 'icons/turf/floors/common.dmi'
	icon_state = "dark_mud"
	base_icon_state = "dark_mud"
	baseturfs = /turf/open/floor/rock
	bullet_bounce_sound = null
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/sand
	gender = PLURAL
	name = "sand"
	desc = "It's coarse and gets everywhere."
	baseturfs = /turf/open/floor/rock
	icon = 'icons/turf/floors/common.dmi'
	icon_state = "sand"
	base_icon_state = "sand"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/sand/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(prob(10))
		icon_state = "[base_icon_state][rand(1,5)]"

/turf/open/floor/dry_seafloor
	gender = PLURAL
	name = "dry seafloor"
	desc = "Should have stayed hydrated."
	baseturfs = /turf/open/floor/rock
	icon = 'icons/turf/floors/common.dmi'
	icon_state = "dry"
	base_icon_state = "dry"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/wasteland
	name = "cracked earth"
	desc = "Looks a bit dry."
	icon = 'icons/turf/floors/wasteland.dmi'
	icon_state = "wasteland"
	base_icon_state = "wasteland"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
