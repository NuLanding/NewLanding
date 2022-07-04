
/**
 * # Giant Spider
 *
 * A versatile mob which can occur from a variety of sources.
 *
 * A mob which can be created by botany or xenobiology.  The basic type is the guard, which is slower but sturdy and outputs good damage.
 * All spiders can produce webbing.  Currently does not inject toxin into its target.
 */
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has deep red eyes."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	speed = 0
	turns_per_move = 5
	see_in_dark = 4
	butcher_results = list(/obj/item/food/meat/slab/spider = 2, /obj/item/food/spiderleg = 8)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	initial_language_holder = /datum/language_holder/spider
	maxHealth = 80
	health = 80
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)
	unsuitable_cold_damage = 10
	unsuitable_heat_damage = 10
	obj_damage = 30
	melee_damage_lower = 20
	melee_damage_upper = 25
	combat_mode = TRUE
	faction = list("spiders")
	pass_flags = PASSTABLE
	move_to_delay = 6
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	unique_name = 1
	gold_core_spawnable = HOSTILE_SPAWN
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	footstep_type = FOOTSTEP_MOB_CLAW
	///How much of a reagent the mob injects on attack
	var/poison_per_bite = 0
	///What reagent the mob injects targets with
	var/poison_type = /datum/reagent/toxin
	///Whether or not the spider is in the middle of an action.
	var/is_busy = FALSE
	///How quickly the spider can place down webbing.  One is base speed, larger numbers are slower.
	var/web_speed = 1
	/// Short description of what this mob is capable of, for radial menu uses
	var/menu_description = "Versatile spider variant for frontline combat. Jack of all trades, master of none. Does not inject toxin."

/mob/living/simple_animal/hostile/giant_spider/Initialize()
	. = ..()
	if(poison_per_bite)
		AddElement(/datum/element/venomous, poison_type, poison_per_bite)

/mob/living/simple_animal/hostile/giant_spider/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	GLOB.spidermobs[src] = TRUE

/mob/living/simple_animal/hostile/giant_spider/Destroy()
	GLOB.spidermobs -= src
	return ..()

/**
 * # Spider Hunter
 *
 * A subtype of the giant spider with purple eyes and toxin injection.
 *
 * A subtype of the giant spider which is faster, has toxin injection, but less health.  This spider is only slightly slower than a human.
 */
/mob/living/simple_animal/hostile/giant_spider/hunter
	name = "hunter spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"
	maxHealth = 50
	health = 50
	melee_damage_lower = 15
	melee_damage_upper = 20
	poison_per_bite = 10
	move_to_delay = 5
	speed = -0.1
	menu_description = "Fast spider variant specializing in catching running prey, but has less health. Toxin injection of 10u per bite."

/**
 * # Spider Nurse
 *
 * A subtype of the giant spider with green eyes that specializes in support.
 *
 * A subtype of the giant spider which specializes in support skills.  Nurses can place down webbing in a quarter of the time
 * that other species can and can wrap other spiders' wounds, healing them.  Note that it cannot heal itself.
 */
/mob/living/simple_animal/hostile/giant_spider/nurse
	name = "nurse spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has brilliant green eyes."
	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"
	gender = FEMALE
	butcher_results = list(/obj/item/food/meat/slab/spider = 2, /obj/item/food/spiderleg = 8, /obj/item/food/spidereggs = 4)
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 3
	web_speed = 0.25
	menu_description = "Support spider variant specializing in healing their brethren and placing webbings swiftly, but has very low amount of health and deals low damage. Toxin injection of 3u per bite."
	///The health HUD applied to the mob.
	var/health_hud = DATA_HUD_MEDICAL_ADVANCED

/mob/living/simple_animal/hostile/giant_spider/nurse/Initialize()
	. = ..()
	var/datum/atom_hud/datahud = GLOB.huds[health_hud]
	datahud.add_hud_to(src)

/mob/living/simple_animal/hostile/giant_spider/nurse/AttackingTarget()
	if(is_busy)
		return
	if(!istype(target, /mob/living/simple_animal/hostile/giant_spider))
		return ..()
	var/mob/living/simple_animal/hostile/giant_spider/hurt_spider = target
	if(hurt_spider == src)
		to_chat(src, SPAN_WARNING("You don't have the dexerity to wrap your own wounds."))
		return
	if(hurt_spider.health >= hurt_spider.maxHealth)
		to_chat(src, SPAN_WARNING("You can't find any wounds to wrap up."))
		return
	visible_message(SPAN_NOTICE("[src] begins wrapping the wounds of [hurt_spider]."),SPAN_NOTICE("You begin wrapping the wounds of [hurt_spider]."))
	is_busy = TRUE
	if(do_after(src, 20, target = hurt_spider))
		hurt_spider.heal_overall_damage(20, 20)
		new /obj/effect/temp_visual/heal(get_turf(hurt_spider), "#80F5FF")
		visible_message(SPAN_NOTICE("[src] wraps the wounds of [hurt_spider]."),SPAN_NOTICE("You wrap the wounds of [hurt_spider]."))
	is_busy = FALSE

/**
 * # Tarantula
 *
 * The tank of spider subtypes.  Is incredibly slow when not on webbing, but has a lunge and the highest health and damage of any spider type.
 *
 * A subtype of the giant spider which specializes in pure strength and staying power.  Is slowed down greatly when not on webbing, but can lunge
 * to throw off attackers and possibly to stun them, allowing the tarantula to net an easy kill.
 */
/mob/living/simple_animal/hostile/giant_spider/tarantula
	name = "tarantula"
	desc = "Furry and black, it makes you shudder to look at it. This one has abyssal red eyes."
	icon_state = "tarantula"
	icon_living = "tarantula"
	icon_dead = "tarantula_dead"
	maxHealth = 300 // woah nelly
	health = 300
	melee_damage_lower = 35
	melee_damage_upper = 40
	obj_damage = 100
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	poison_per_bite = 0
	move_to_delay = 8
	speed = 1
	status_flags = NONE
	mob_size = MOB_SIZE_LARGE
	gold_core_spawnable = NO_SPAWN
	charger = TRUE
	charge_distance = 4
	menu_description = "Tank spider variant with an enormous amount of health and damage, but is very slow when not on webbing. It also has a charge ability to close distance with a target after a small windup. Does not inject toxin."
	///Whether or not the tarantula is currently walking on webbing.
	var/silk_walking = TRUE
	///The spider's charge ability
	var/obj/effect/proc_holder/tarantula_charge/charge

/mob/living/simple_animal/hostile/giant_spider/tarantula/Initialize()
	. = ..()
	charge = new
	AddAbility(charge)

/**
 * # Spider Viper
 *
 * The assassin of spider subtypes.  Essentially a juiced up version of the hunter.
 *
 * A subtype of the giant spider which specializes in speed and poison.  Injects a deadlier toxin than other spiders, moves extremely fast,
 * but like the hunter has a limited amount of health.
 */
/mob/living/simple_animal/hostile/giant_spider/viper
	name = "viper spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has effervescent purple eyes."
	icon_state = "viper"
	icon_living = "viper"
	icon_dead = "viper_dead"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 5
	poison_per_bite = 6
	move_to_delay = 4
	poison_type = /datum/reagent/toxin/venom
	speed = -0.5
	gold_core_spawnable = NO_SPAWN
	menu_description = "Assassin spider variant with an unmatched speed and very deadly poison, but has very low amount of health and damage. Venom injection of 6u per bite."

/datum/action/innate/spider
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_alien"

/obj/effect/proc_holder/tarantula_charge
	name = "Charge"
	panel = "Spider"
	desc = "Charge at a target, knocking them down if you collide with them.  Stuns yourself if you fail."
	ranged_mousepointer = 'icons/effects/mouse_pointers/wrap_target.dmi'
	action_icon = 'icons/mob/actions/actions_animal.dmi'
	action_icon_state = "wrap_0"
	action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/tarantula_charge/update_icon()
	action.button_icon_state = "wrap_[active]"
	action.UpdateButtonIcon()
	return ..()

/obj/effect/proc_holder/tarantula_charge/Click()
	if(!istype(usr, /mob/living/simple_animal/hostile/giant_spider/tarantula))
		return TRUE
	var/mob/living/simple_animal/hostile/giant_spider/tarantula/user = usr
	activate(user)
	return TRUE

/obj/effect/proc_holder/tarantula_charge/proc/activate(mob/living/user)
	var/message
	var/mob/living/simple_animal/hostile/giant_spider/tarantula/spider = user
	if(active)
		message = SPAN_NOTICE("You stop preparing to charge.")
		remove_ranged_ability(message)
	else
		if(!COOLDOWN_FINISHED(spider, charge_cooldown))
			message = SPAN_NOTICE("Your charge is still on cooldown!</B>")
			remove_ranged_ability(message)
		message = SPAN_NOTICE("You prepare to charge. <B>Left-click your target to charge them!</B>")
		add_ranged_ability(user, message, TRUE)
		return 1

/obj/effect/proc_holder/tarantula_charge/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated() || !istype(ranged_ability_user, /mob/living/simple_animal/hostile/giant_spider/tarantula))
		remove_ranged_ability()
		return

	var/mob/living/simple_animal/hostile/giant_spider/tarantula/user = ranged_ability_user

	INVOKE_ASYNC(user, /mob/living/simple_animal/hostile/.proc/enter_charge, target)
	remove_ranged_ability()
	return TRUE

/obj/effect/proc_holder/tarantula_charge/on_lose(mob/living/carbon/user)
	remove_ranged_ability()

/datum/action/innate/spider/comm
	name = "Command"
	desc = "Send a command to all living spiders."
	button_icon_state = "command"

/datum/action/innate/spider/comm/IsAvailable()
	return TRUE

/datum/action/innate/spider/comm/Trigger()
	var/input = stripped_input(owner, "Input a command for your legions to follow.", "Command", "")
	if(QDELETED(src) || !input || !IsAvailable())
		return FALSE
	spider_command(owner, input)
	return TRUE

/**
 * Sends a message to all spiders from the target.
 *
 * Allows the user to send a message to all spiders that exist.  Ghosts will also see the message.
 * Arguments:
 * * user - The spider sending the message
 * * message - The message to be sent
 */
/datum/action/innate/spider/comm/proc/spider_command(mob/living/user, message)
	if(!message)
		return
	var/my_message
	my_message = SPAN_SPIDER("<b>Command from [user]:</b> [message]")
	for(var/mob/living/simple_animal/hostile/giant_spider/spider in GLOB.spidermobs)
		to_chat(spider, my_message)
	for(var/ghost in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(ghost, user)
		to_chat(ghost, "[link] [my_message]")
	usr.log_talk(message, LOG_SAY, tag="spider command")

/**
 * # Giant Ice Spider
 *
 * A giant spider immune to temperature damage.  Injects frost oil.
 *
 * A subtype of the giant spider which is immune to temperature damage, unlike its normal counterpart.
 * Currently unused in the game unless spawned by admins.
 */
/mob/living/simple_animal/hostile/giant_spider/ice
	name = "giant ice spider"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN
	menu_description = "Versatile ice spider variant for frontline combat. Jack of all trades, master of none. Immune to temperature damage. Does not inject frost oil."

/**
 * # Ice Nurse Spider
 *
 * A nurse spider immune to temperature damage.  Injects frost oil.
 *
 * Same thing as the giant ice spider but mirrors the nurse subtype.  Also unused.
 */
/mob/living/simple_animal/hostile/giant_spider/nurse/ice
	name = "giant ice spider"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	menu_description = "Support ice spider variant specializing in healing their brethren and placing webbings swiftly, but has very low amount of health and deals low damage. Immune to temperature damage. Frost oil injection of 3u per bite."

/**
 * # Ice Hunter Spider
 *
 * A hunter spider immune to temperature damage.  Injects frost oil.
 *
 * Same thing as the giant ice spider but mirrors the hunter subtype.  Also unused.
 */
/mob/living/simple_animal/hostile/giant_spider/hunter/ice
	name = "giant ice spider"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	poison_type = /datum/reagent/consumable/frostoil
	color = rgb(114,228,250)
	gold_core_spawnable = NO_SPAWN
	menu_description = "Fast ice spider variant specializing in catching running prey, but has less health. Immune to temperature damage. Frost oil injection of 10u per bite."

/**
 * # Scrawny Hunter Spider
 *
 * A hunter spider that trades damage for health, unable to smash enviroments.
 *
 * Mainly used as a minor threat in abandoned places, such as areas in maintenance or a ruin.
 */
/mob/living/simple_animal/hostile/giant_spider/hunter/scrawny
	name = "scrawny spider"
	environment_smash = ENVIRONMENT_SMASH_NONE
	health = 60
	maxHealth = 60
	melee_damage_lower = 5
	melee_damage_upper = 10
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes, and looks abnormally thin and frail."
	menu_description = "Fast spider variant specializing in catching running prey, but has less damage than a normal hunter spider at the cost of more health. Toxin injection of 10u per bite."

/**
 * # Scrawny Tarantula
 *
 * A weaker version of the Tarantula, unable to smash enviroments.
 *
 * Mainly used as a moderately strong but slow threat in abandoned places, such as areas in maintenance or a ruin.
 */
/mob/living/simple_animal/hostile/giant_spider/tarantula/scrawny
	name = "scrawny tarantula"
	environment_smash = ENVIRONMENT_SMASH_NONE
	health = 150
	maxHealth = 150
	melee_damage_lower = 20
	melee_damage_upper = 25
	desc = "Furry and black, it makes you shudder to look at it. This one has abyssal red eyes, and looks abnormally thin and frail."
	menu_description = "A weaker variant of the tarantula with reduced amount of health and damage, very slow when not on webbing. It also has a charge ability to close distance with a target after a small windup. Does not inject toxin."

/**
 * # Scrawny Nurse Spider
 *
 * A weaker version of the nurse spider with reduced health, unable to smash enviroments.
 *
 * Mainly used as a weak threat in abandoned places, such as areas in maintenance or a ruin.
 */
/mob/living/simple_animal/hostile/giant_spider/nurse/scrawny
	name = "scrawny nurse spider"
	environment_smash = ENVIRONMENT_SMASH_NONE
	health = 30
	maxHealth = 30
	desc = "Furry and black, it makes you shudder to look at it. This one has brilliant green eyes, and looks abnormally thin and frail."
	menu_description = "Weaker version of the nurse spider, specializing in healing their brethren and placing webbings swiftly, but has very low amount of health and deals low damage. Toxin injection of 3u per bite."

/**
 * # Flesh Spider
 *
 * A giant spider subtype specifically created by changelings.  Built to be self-sufficient, unlike other spider types.
 *
 * A subtype of giant spider which only occurs from changelings.  Has the base stats of a hunter, but they can heal themselves.
 * They also produce web in 70% of the time of the base spider.  They also occasionally leave puddles of blood when they walk around.  Flavorful!
 */
/mob/living/simple_animal/hostile/giant_spider/hunter/flesh
	desc = "A odd fleshy creature in the shape of a spider.  Its eyes are pitch black and soulless."
	icon_state = "flesh_spider"
	icon_living = "flesh_spider"
	icon_dead = "flesh_spider_dead"
	web_speed = 0.7
	menu_description = "Self-sufficient spider variant capable of healing themselves and producing webbbing fast, but has less health. Toxin injection of 10u per bite."

/mob/living/simple_animal/hostile/giant_spider/hunter/flesh/AttackingTarget()
	if(is_busy)
		return
	if(src == target)
		if(health >= maxHealth)
			to_chat(src, SPAN_WARNING("You're not injured, there's no reason to heal."))
			return
		visible_message(SPAN_NOTICE("[src] begins mending themselves..."),SPAN_NOTICE("You begin mending your wounds..."))
		is_busy = TRUE
		if(do_after(src, 20, target = src))
			heal_overall_damage(50, 50)
			new /obj/effect/temp_visual/heal(get_turf(src), "#80F5FF")
			visible_message(SPAN_NOTICE("[src]'s wounds mend together."),SPAN_NOTICE("You mend your wounds together."))
		is_busy = FALSE
		return
	return ..()

/**
 * # Viper Spider (Wizard)
 *
 * A viper spider buffed slightly so I don't need to hear anyone complain about me nerfing an already useless wizard ability.
 *
 * A viper spider with buffed attributes.  All I changed was its health value and gave it the ability to ventcrawl.  The crux of the wizard meta.
 */
/mob/living/simple_animal/hostile/giant_spider/viper/wizard
	maxHealth = 80
	health = 80
	menu_description = "Stronger assassin spider variant with an unmatched speed, high amount of health and very deadly poison, but deals very low amount of damage. It also has ability to ventcrawl. Venom injection of 6u per bite."

/mob/living/simple_animal/hostile/giant_spider/viper/wizard/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
