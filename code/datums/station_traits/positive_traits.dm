#define PARTY_COOLDOWN_LENGTH_MIN 6 MINUTES
#define PARTY_COOLDOWN_LENGTH_MAX 12 MINUTES


/datum/station_trait/lucky_winner
	name = "Lucky winner"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 1
	show_in_report = TRUE
	report_message = "Your station has won the grand prize of the annual station charity event. Free snacks will be delivered to the bar every now and then."
	trait_processes = TRUE
	COOLDOWN_DECLARE(party_cooldown)

/datum/station_trait/lucky_winner/on_round_start()
	. = ..()
	COOLDOWN_START(src, party_cooldown, rand(PARTY_COOLDOWN_LENGTH_MIN, PARTY_COOLDOWN_LENGTH_MAX))

/datum/station_trait/lucky_winner/process(delta_time)
	if(!COOLDOWN_FINISHED(src, party_cooldown))
		return

	COOLDOWN_START(src, party_cooldown, rand(PARTY_COOLDOWN_LENGTH_MIN, PARTY_COOLDOWN_LENGTH_MAX))

	var/area/area_to_spawn_in = pick(GLOB.bar_areas)
	var/turf/T = pick(area_to_spawn_in.contents)

	var/obj/structure/closet/supplypod/centcompod/toLaunch = new()
	var/obj/item/pizzabox/pizza_to_spawn = pick(list(/obj/item/pizzabox/margherita, /obj/item/pizzabox/mushroom, /obj/item/pizzabox/meat, /obj/item/pizzabox/vegetable, /obj/item/pizzabox/pineapple))
	new pizza_to_spawn(toLaunch)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/drinks/beer(toLaunch)
	new /obj/effect/pod_landingzone(T, toLaunch)

/datum/station_trait/premium_internals_box
	name = "Premium internals boxes"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 10
	show_in_report = TRUE
	report_message = "The internals boxes for your crew have been filled with bonus equipment."
	trait_to_give = STATION_TRAIT_PREMIUM_INTERNALS

/datum/station_trait/filled_maint
	name = "Filled up maintenance"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Our workers accidentaly forgot more of their personal belongings in the maintenace areas."
	blacklist = list(/datum/station_trait/empty_maint)
	trait_to_give = STATION_TRAIT_FILLED_MAINT

/datum/station_trait/deathrattle_department
	name = "deathrattled department"
	trait_type = STATION_TRAIT_POSITIVE
	show_in_report = TRUE
	trait_flags = STATION_TRAIT_ABSTRACT
	blacklist = list(/datum/station_trait/deathrattle_all)

	var/department_to_apply_to
	var/department_name = "department"
	var/datum/deathrattle_group/deathrattle_group

/datum/station_trait/deathrattle_department/New()
	. = ..()
	deathrattle_group = new("[department_name] group")
	blacklist += subtypesof(/datum/station_trait/deathrattle_department) - type //All but ourselves
	name = "deathrattled [department_name]"
	report_message = "All members of [department_name] have received an implant to notify each other if one of them dies. This should help improve job-safety!"
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/on_job_after_spawn)


/datum/station_trait/deathrattle_department/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	if(!(job.departments_bitflags & department_to_apply_to))
		return

	var/obj/item/implant/deathrattle/implant_to_give = new()
	deathrattle_group.register(implant_to_give)
	implant_to_give.implant(spawned, spawned, TRUE, TRUE)


/datum/station_trait/deathrattle_department/service
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_BITFLAG_SERVICE
	department_name = "Service"

/datum/station_trait/deathrattle_department/cargo
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_BITFLAG_CARGO
	department_name = "Cargo"

/datum/station_trait/deathrattle_department/engineering
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_BITFLAG_ENGINEERING
	department_name = "Engineering"

/datum/station_trait/deathrattle_department/command
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_BITFLAG_COMMAND
	department_name = "Command"

/datum/station_trait/deathrattle_department/science
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_BITFLAG_SCIENCE
	department_name = "Science"

/datum/station_trait/deathrattle_department/security
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_BITFLAG_SECURITY
	department_name = "Security"

/datum/station_trait/deathrattle_department/medical
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_BITFLAG_MEDICAL
	department_name = "Medical"

/datum/station_trait/deathrattle_all
	name = "deathrattled station"
	trait_type = STATION_TRAIT_POSITIVE
	show_in_report = TRUE
	weight = 1
	report_message = "All members of the station have received an implant to notify each other if one of them dies. This should help improve job-safety!"
	var/datum/deathrattle_group/deathrattle_group


/datum/station_trait/deathrattle_all/New()
	. = ..()
	deathrattle_group = new("station group")
	blacklist = subtypesof(/datum/station_trait/deathrattle_department)
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/on_job_after_spawn)


/datum/station_trait/deathrattle_all/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER

	var/obj/item/implant/deathrattle/implant_to_give = new()
	deathrattle_group.register(implant_to_give)
	implant_to_give.implant(spawned, spawned, TRUE, TRUE)
