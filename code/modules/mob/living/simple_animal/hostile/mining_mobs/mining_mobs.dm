//the base mining mob
/mob/living/simple_animal/hostile/asteroid
	vision_range = 2
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("mining")
	weather_immunities = list("lava","ash")
	obj_damage = 30
	environment_smash = ENVIRONMENT_SMASH_WALLS
	minbodytemp = 0
	maxbodytemp = INFINITY
	unsuitable_heat_damage = 20
	response_harm_continuous = "strikes"
	response_harm_simple = "strike"
	status_flags = 0
	combat_mode = TRUE
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	mob_size = MOB_SIZE_LARGE
	var/throw_message = "bounces off of"
	var/fromtendril = FALSE
	var/icon_aggro = null

/mob/living/simple_animal/hostile/asteroid/Aggro()
	..()
	if(vision_range == aggro_vision_range && icon_aggro)
		icon_state = icon_aggro

/mob/living/simple_animal/hostile/asteroid/LoseAggro()
	..()
	if(stat == DEAD)
		return
	icon_state = icon_living

/mob/living/simple_animal/hostile/asteroid/bullet_act(obj/projectile/P)//Reduces damage from most projectiles to curb off-screen kills
	if(!stat)
		Aggro()
	if(P.damage < 30 && P.damage_type != BRUTE)
		P.damage = (P.damage / 3)
		visible_message(SPAN_DANGER("[P] has a reduced effect on [src]!"))
	..()

/mob/living/simple_animal/hostile/asteroid/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum) //No floor tiling them to death, wiseguy
	if(istype(AM, /obj/item))
		var/obj/item/T = AM
		if(!stat)
			Aggro()
		if(T.throwforce <= 20)
			visible_message(SPAN_NOTICE("The [T.name] [throw_message] [src.name]!"))
			return
	..()

/mob/living/simple_animal/hostile/asteroid/death(gibbed)
	SSblackbox.record_feedback("tally", "mobs_killed_mining", 1, type)
	..(gibbed)
