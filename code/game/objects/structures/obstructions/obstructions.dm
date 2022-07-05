/obj/structure/obstruction/cobweb
	abstract_type = /obj/structure/obstruction/cobweb
	name = "cobwebs"
	desc = "Sticky spider web. Makes it difficult to traverse through it."
	icon_state = "cobweb1"
	base_icon_state = "cobweb1"
	clear_by_attack = TRUE
	obstruction_slowdown = 2

/obj/structure/obstruction/cobweb/get_base_icon_state()
	return pick(list("cobweb1", "cobweb2"))

/obj/structure/obstruction/cobweb/normal

/obj/structure/obstruction/cobweb/thick
	name = "thick cobwebs"
	desc = "Sticky spider web. Makes it difficult to traverse through it. \nThis one is so thick it's hard to see through it."
	icon_state = "cobweb2"
	base_icon_state = "cobweb2"
	obstruction_opaque = TRUE

/obj/structure/obstruction/rock
	abstract_type = /obj/structure/obstruction/rock
	name = "rock"
	desc = "Chunks of rock blocking your way."
	obstruction_dense = TRUE
	explosion_clear_severity = EXPLODE_HEAVY
	regrows = FALSE

/obj/structure/obstruction/rock/hole
	icon_state = "rock_medium"
	base_icon_state = "rock_medium"
	floor_overlay = "cobble"
	clear_floor_overlay = "cobble_hole"
	obstruction_climbable = TRUE
	obstruction_multiz = TRUE

/obj/structure/obstruction/rock/normal
	icon_state = "rock_medium"
	base_icon_state = "rock_medium"
	obstruction_climbable = TRUE

/obj/structure/obstruction/rock/large
	name = "large rock"
	icon_state = "rock_large"
	base_icon_state = "rock_large"

/obj/structure/obstruction/rock/massive
	name = "massive rock"
	desc = "Massive chunks of rock blocking your way."
	icon_state = "rock_massive"
	base_icon_state = "rock_massive"
	obstruction_opaque = TRUE

/obj/structure/obstruction/overgrowth
	abstract_type = /obj/structure/obstruction/overgrowth
	name = "overgrowth"
	desc = "Various vines and plants making it difficult to traverse."
	icon_state = "growth1"
	clear_by_attack = TRUE
	required_sharpness = TRUE
	obstruction_slowdown = 2

/obj/structure/obstruction/overgrowth/normal

/obj/structure/obstruction/overgrowth/normal/get_base_icon_state()
	return pick(list("growth1", "growth2", "growth3"))

/obj/structure/obstruction/overgrowth/dense
	name = "dense overgrowth"
	obstruction_opaque = TRUE

/obj/structure/obstruction/overgrowth/dense/get_base_icon_state()
	return pick(list("growth_big1", "growth_big2", "growth_big3"))

/obj/structure/obstruction/overgrowth/massive
	name = "massive overgrowth"
	obstruction_opaque = TRUE
	obstruction_dense = TRUE

/obj/structure/obstruction/overgrowth/massive/get_base_icon_state()
	return pick(list("growth_massive1", "growth_massive2", "growth_massive3"))

/obj/structure/obstruction/branches
	name = "branches"
	desc = "Thick branches obstrucing the way."
	icon_state = "tall_branches"
	base_icon_state = "tall_branches"
	clear_by_attack = TRUE
	required_sharpness = TRUE
	obstruction_dense = TRUE
	obstruction_opaque = TRUE

/obj/structure/obstruction/dirt_mound
	abstract_type = /obj/structure/obstruction/dirt_mound
	name = "dirt mound"
	desc = "A mound of dirt. \nYou could shovel it away."
	clear_by_action = TRUE
	required_tool = TOOL_SHOVEL
	obstruction_dense = TRUE
	obstruction_climbable = TRUE

/obj/structure/obstruction/dirt_mound/normal
	icon_state = "dirt_mound"
	base_icon_state = "dirt_mound"

/obj/structure/obstruction/dirt_mound/rocky
	name = "rocky dirt mound"
	desc = "A mound of dirt. This one has a bunch of rocks in it. \nYou could shovel it away."
	icon_state = "dirt_mound_rocky"
	base_icon_state = "dirt_mound_rocky"

/obj/structure/obstruction/dirt_mound/hole
	icon_state = "dirt_mound"
	base_icon_state = "dirt_mound"
	floor_overlay = "cobble"
	clear_floor_overlay = "cobble_hole"
	obstruction_multiz = TRUE

/obj/structure/obstruction/dirt_mound/hole_rocky
	icon_state = "dirt_mound_rocky"
	base_icon_state = "dirt_mound_rocky"
	floor_overlay = "cobble"
	clear_floor_overlay = "cobble_hole"
	obstruction_multiz = TRUE
