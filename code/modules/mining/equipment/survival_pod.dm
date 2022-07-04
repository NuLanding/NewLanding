/*****************************Survival Pod********************************/
/area/survivalpod
	name = "\improper Emergency Shelter"
	icon_state = "away"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
	flags_1 = CAN_BE_DIRTY_1

//Survival Capsule
/obj/item/survivalcapsule
	name = "bluespace shelter capsule"
	desc = "An emergency shelter stored within a pocket of bluespace."
	icon_state = "capsule"
	icon = 'icons/obj/mining.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/template_id = "shelter_alpha"
	var/datum/map_template/shelter/template
	var/used = FALSE

/obj/item/survivalcapsule/proc/get_template()
	if(template)
		return
	template = SSmapping.shelter_templates[template_id]
	if(!template)
		WARNING("Shelter template ([template_id]) not found!")
		qdel(src)

/obj/item/survivalcapsule/Destroy()
	template = null // without this, capsules would be one use. per round.
	. = ..()

/obj/item/survivalcapsule/examine(mob/user)
	. = ..()
	get_template()
	. += "This capsule has the [template.name] stored."
	. += template.description

/obj/item/survivalcapsule/attack_self()
	//Can't grab when capsule is New() because templates aren't loaded then
	get_template()
	if(!used)
		loc.visible_message(SPAN_WARNING("\The [src] begins to shake. Stand back!"))
		used = TRUE
		sleep(50)
		var/turf/deploy_location = get_turf(src)
		var/status = template.check_deploy(deploy_location)
		switch(status)
			if(SHELTER_DEPLOY_BAD_AREA)
				src.loc.visible_message(SPAN_WARNING("\The [src] will not function in this area."))
			if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS, SHELTER_DEPLOY_OUTSIDE_MAP)
				var/width = template.width
				var/height = template.height
				src.loc.visible_message(SPAN_WARNING("\The [src] doesn't have room to deploy! You need to clear a [width]x[height] area!"))
		if(status != SHELTER_DEPLOY_ALLOWED)
			used = FALSE
			return

		template.load(deploy_location, centered = TRUE)
		var/turf/T = deploy_location
		if(!is_mining_level(T)) //only report capsules away from the mining/lavaland level
			message_admins("[ADMIN_LOOKUPFLW(usr)] activated a bluespace capsule away from the mining level! [ADMIN_VERBOSEJMP(T)]")
			log_admin("[key_name(usr)] activated a bluespace capsule away from the mining level at [AREACOORD(T)]")

		playsound(src, 'sound/effects/phasein.ogg', 100, TRUE)
		new /obj/effect/particle_effect/smoke(get_turf(src))
		qdel(src)

//Non-default pods

/obj/item/survivalcapsule/luxury
	name = "luxury bluespace shelter capsule"
	desc = "An exorbitantly expensive luxury suite stored within a pocket of bluespace."
	template_id = "shelter_beta"

/obj/item/survivalcapsule/luxuryelite
	name = "luxury elite bar capsule"
	desc = "A luxury bar in a capsule. Bartender required and not included."
	template_id = "shelter_charlie"

//Pod objects

//Window
/obj/structure/window/shuttle/survival_pod
	name = "pod window"
	icon = 'icons/obj/smooth_structures/window_reinforced.dmi'
	icon_state = "window-0"
	base_icon_state = "window"
	color = "#363636"
	alpha = 180
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTERS_BLASTDOORS)

/obj/structure/window/shuttle/survival_pod/spawner/north
	dir = NORTH

/obj/structure/window/shuttle/survival_pod/spawner/east
	dir = EAST

/obj/structure/window/shuttle/survival_pod/spawner/west
	dir = WEST

/obj/structure/window/reinforced/survival_pod
	name = "pod window"
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "pwindow"

//Table
/obj/structure/table/survival_pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "table"
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null

//Computer
/obj/item/gps/computer
	name = "pod computer"
	icon_state = "pod_computer"
	icon = 'icons/obj/lavaland/pod_computer.dmi'
	anchored = TRUE
	density = TRUE
	pixel_y = -32

/obj/item/gps/computer/wrench_act(mob/living/user, obj/item/I)
	..()
	if(flags_1 & NODECONSTRUCT_1)
		return TRUE

	user.visible_message(SPAN_WARNING("[user] disassembles [src]."),
		SPAN_NOTICE("You start to disassemble [src]..."), SPAN_HEAR("You hear clanking and banging noises."))
	if(I.use_tool(src, user, 20, volume=50))
		new /obj/item/gps(loc)
		qdel(src)
	return TRUE

/obj/item/gps/computer/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	attack_self(user)

//Bed
/obj/structure/bed/pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "bed"

/obj/structure/bed/double/pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "bed_double"

/obj/item/fakeartefact
	name = "expensive forgery"
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "x2"
	var/possible = list(/obj/item/ship_in_a_bottle,
						/obj/item/book/granter/martial/carp,
						/obj/item/his_grace,
						/obj/item/gun/ballistic/automatic/l6_saw,
						/obj/item/nuke_core,
						/obj/item/phylactery,
						/obj/item/banhammer)

/obj/item/fakeartefact/Initialize()
	. = ..()
	var/obj/item/I = pick(possible)
	name = initial(I.name)
	icon = initial(I.icon)
	desc = initial(I.desc)
	icon_state = initial(I.icon_state)
	inhand_icon_state = initial(I.inhand_icon_state)
