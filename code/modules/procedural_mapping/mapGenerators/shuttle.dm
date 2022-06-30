/datum/map_generator_module/bottom_layer/shuttle_floor
	spawnableTurfs = list(/turf/open/floor/grass = 100)

/datum/map_generator_module/border/shuttle_walls
	spawnableTurfs = list(/turf/closed/wall = 100)
// Generators

/datum/map_generator/shuttle/full
	modules = list(/datum/map_generator_module/bottom_layer/shuttle_floor, \
		/datum/map_generator_module/border/shuttle_walls)
	buildmode_name = "Pattern: Shuttle Room"

/datum/map_generator/shuttle/floor
	modules = list(/datum/map_generator_module/bottom_layer/shuttle_floor)
	buildmode_name = "Block: Shuttle Floor"
