/datum/station_trait/carp_infestation
	name = "Carp infestation"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Dangerous fauna is present in the area of this station."
	trait_to_give = STATION_TRAIT_CARP_INFESTATION

/datum/station_trait/late_arrivals
	name = "Late Arrivals"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 2
	show_in_report = TRUE
	report_message = "Sorry for that, we didn't expect to fly into that vomiting goose while bringing you to your new station."
	trait_to_give = STATION_TRAIT_LATE_ARRIVALS
	blacklist = list(/datum/station_trait/random_spawns)

/datum/station_trait/random_spawns
	name = "Drive-by landing"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 2
	show_in_report = TRUE
	report_message = "Sorry for that, we missed your station by a few miles, so we just launched you towards your station in pods. Hope you don't mind!"
	trait_to_give = STATION_TRAIT_RANDOM_ARRIVALS
	blacklist = list(/datum/station_trait/late_arrivals)

/datum/station_trait/blackout
	name = "Blackout"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 3
	show_in_report = TRUE
	report_message = "Station lights seem to be damaged, be safe when starting your shift today."

/datum/station_trait/blackout/on_round_start()
	return

/datum/station_trait/empty_maint
	name = "Cleaned out maintenance"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Our workers cleaned out most of the junk in the maintenace areas."
	blacklist = list(/datum/station_trait/filled_maint)
	trait_to_give = STATION_TRAIT_EMPTY_MAINT

/datum/station_trait/revenge_of_pun_pun
	name = "Revenge of Pun Pun"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 2
	var/static/list/weapon_types

/datum/station_trait/revenge_of_pun_pun/New()
	if(!weapon_types)
		weapon_types = list(
			/obj/item/chair = 20,
			/obj/item/tailclub = 10,
			/obj/item/melee/baseball_bat = 10,
			/obj/item/melee/chainofcommand/tailwhip = 10,
			/obj/item/melee/chainofcommand/tailwhip/kitty = 10,
			/obj/item/reagent_containers/food/drinks/bottle = 20,
			/obj/item/reagent_containers/food/drinks/bottle/kong = 5,
			/obj/item/switchblade/extended = 10,
			/obj/item/sign/random = 10,
			/obj/item/gun/ballistic/automatic/pistol = 1,
		)

	RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, .proc/arm_monke)

/datum/station_trait/revenge_of_pun_pun/proc/arm_monke()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/species/monkey/punpun/punpun = locate()
	if(!punpun)
		return
	var/weapon_type = pickweight(weapon_types)
	var/obj/item/weapon = new weapon_type
	if(!punpun.put_in_l_hand(weapon) && !punpun.put_in_r_hand(weapon))
		// Guess they did all this with whatever they have in their hands already
		qdel(weapon)
		weapon = punpun.get_active_held_item() || punpun.get_inactive_held_item()

	weapon?.add_mob_blood(punpun)
	punpun.add_mob_blood(punpun)

	new /datum/ai_controller/monkey/angry(punpun)

	var/area/place = get_area(punpun)

	var/list/area_open_turfs = list()
	for(var/turf/location in place)
		if(location.density)
			continue
		area_open_turfs += location

	punpun.forceMove(pick(area_open_turfs))

	for(var/i in 1 to rand(10, 40))
		new /obj/effect/decal/cleanable/blood(pick(area_open_turfs))

	var/list/blood_path = list()
	for(var/i in 1 to 10) // Only 10 attempts
		var/turf/destination = pick(area_open_turfs)
		var/turf/next_step = get_step_to(punpun, destination)
		for(var/k in 1 to 30) // Max 30 steps
			if(!next_step)
				break
			blood_path += next_step
			next_step = get_step_to(next_step, destination)
		if(length(blood_path))
			break
	if(!length(blood_path))
		CRASH("Unable to make a path from punpun")

	var/turf/last_location
	for(var/turf/location as anything in blood_path)
		last_location = location

		if(prob(80))
			new /obj/effect/decal/cleanable/blood(location)

		if(prob(50))
			var/static/blood_types = list(
				/obj/effect/decal/cleanable/blood/splatter,
				/obj/effect/decal/cleanable/blood/gibs,
			)
			var/blood_type = pick(blood_types)
			new blood_type(get_turf(pick(orange(location, 2))))

	new /obj/effect/decal/cleanable/blood/gibs/torso(last_location)
