///////////////////////////////////////
///////////HALLOWEEN CONTENT///////////
///////////////////////////////////////


//spooky recipes

/datum/recipe/sugarcookie/spookyskull
	reagents_list = list(/datum/reagent/consumable/flour = 5, /datum/reagent/consumable/sugar = 5, /datum/reagent/consumable/milk = 5)
	items = list(
		/obj/item/food/egg,
	)
	result = /obj/item/food/cookie/sugar/spookyskull

/datum/recipe/sugarcookie/spookycoffin
	reagents_list = list(/datum/reagent/consumable/flour = 5, /datum/reagent/consumable/sugar = 5, /datum/reagent/consumable/coffee = 5)
	items = list(
		/obj/item/food/egg,
	)
	result = /obj/item/food/cookie/sugar/spookycoffin

////////////////////
//Spookoween Ghost//
////////////////////

/mob/living/simple_animal/shade/howling_ghost
	name = "ghost"
	real_name = "ghost"
	icon = 'icons/mob/mob.dmi'
	maxHealth = 1e6
	health = 1e6
	speak_emote = list("howls")
	emote_hear = list("wails","screeches")
	density = FALSE
	anchored = TRUE
	incorporeal_move = 1
	layer = 4
	var/timer = 0

/mob/living/simple_animal/shade/howling_ghost/Initialize()
	. = ..()
	icon_state = pick("ghost","ghostian","ghostian2","ghostking","ghost1","ghost2")
	icon_living = icon_state
	status_flags |= GODMODE
	timer = rand(1,15)

/mob/living/simple_animal/shade/howling_ghost/Life()
	..()
	timer--
	if(prob(20))
		roam()
	if(timer == 0)
		spooky_ghosty()
		timer = rand(1,15)

/mob/living/simple_animal/shade/howling_ghost/proc/EtherealMove(direction)
	forceMove(get_step(src, direction))
	setDir(direction)

/mob/living/simple_animal/shade/howling_ghost/proc/roam()
	if(prob(80))
		var/direction = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)
		EtherealMove(direction)

/mob/living/simple_animal/shade/howling_ghost/proc/spooky_ghosty()
	if(prob(20)) //haunt
		playsound(loc, pick('sound/spookoween/ghosty_wind.ogg','sound/spookoween/ghost_whisper.ogg','sound/spookoween/chain_rattling.ogg'), 300, TRUE)
	if(prob(5)) //poltergeist
		var/obj/item/I = locate(/obj/item) in view(3, src)
		if(I)
			var/direction = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)
			step(I,direction)
		return

/mob/living/simple_animal/shade/howling_ghost/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = 0

///////////////////////////
//Spookoween Insane Clown//
///////////////////////////

///Insane clown mob. Basically a clown that haunts you.
/mob/living/simple_animal/hostile/clown_insane
	name = "insane clown"
	desc = "Some clowns do not manage to be accepted, and go insane. This is one of them."
	icon = 'icons/mob/clown_mobs.dmi'
	icon_state = "scary_clown"
	icon_living = "scary_clown"
	icon_dead = "scary_clown"
	icon_gib = "scary_clown"
	speak = list("...", ". . .")
	maxHealth = INFINITY
	health = INFINITY
	emote_see = list("silently stares")
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	minbodytemp = 0
	maxbodytemp = INFINITY
	var/timer

/mob/living/simple_animal/hostile/clown_insane/Initialize()
	. = ..()
	status_flags |= GODMODE //Slightly easier to maintain.

/mob/living/simple_animal/hostile/clown_insane/Destroy()
	timer = null
	return ..()

/mob/living/simple_animal/hostile/clown_insane/ex_act()
	return

///Adds a timer to call stalk() on Aggro
/mob/living/simple_animal/hostile/clown_insane/Aggro()
	. = ..()
	timer = addtimer(CALLBACK(src, .proc/stalk), 30, TIMER_STOPPABLE|TIMER_UNIQUE)

/mob/living/simple_animal/hostile/clown_insane/LoseAggro()
	. = ..()
	if(timer)
		deltimer(timer)
		timer = null

///Plays scary noises and adds some timers.
/mob/living/simple_animal/hostile/clown_insane/proc/stalk()
	var/mob/living/M = target
	if(!istype(M))
		LoseAggro()
		return
	if(M.stat == DEAD)
		playsound(M.loc, 'sound/spookoween/insane_low_laugh.ogg', 100, TRUE)
		qdel(src)
		return
	playsound(M, pick('sound/spookoween/scary_horn.ogg','sound/spookoween/scary_horn2.ogg', 'sound/spookoween/scary_horn3.ogg'), 100, TRUE)
	timer = addtimer(CALLBACK(src, .proc/stalk), 30, TIMER_STOPPABLE|TIMER_UNIQUE)
	addtimer(CALLBACK(src, .proc/teleport_to_target), 12, TIMER_STOPPABLE|TIMER_UNIQUE)

///Does what's in the name. Teleports to target.loc. Called from a timer.
/mob/living/simple_animal/hostile/clown_insane/proc/teleport_to_target()
	if(target && isturf(target.loc)) //Hiding in lockers works to get rid of this thing.
		forceMove(target.loc)

/mob/living/simple_animal/hostile/clown_insane/MoveToTarget()
	return

/mob/living/simple_animal/hostile/clown_insane/AttackingTarget()
	return

/mob/living/simple_animal/hostile/clown_insane/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = 0
	if(prob(5))
		playsound(loc, 'sound/spookoween/insane_low_laugh.ogg', 300, TRUE)

/mob/living/simple_animal/hostile/clown_insane/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/nullrod))
		if(prob(5))
			visible_message(SPAN_NOTICE("[src] finally found the peace it deserves. <i>You hear honks echoing off into the distance.</i>"))
			playsound(loc, 'sound/spookoween/insane_low_laugh.ogg', 300, TRUE)
			qdel(src)
		else
			visible_message(SPAN_DANGER("[src] seems to be resisting the effect!"))
		return
	return ..()

/////////////////////////
// Spooky Uplink Items //
/////////////////////////

/datum/uplink_item/dangerous/crossbow/candy
	name = "Candy Corn Crossbow"
	desc = "A standard miniature energy crossbow that uses a hard-light projector to transform bolts into candy corn. Happy Halloween!"
	category = "Holiday"
	surplus = 0

/datum/uplink_item/device_tools/emag/hack_o_lantern
	name = "Hack-o'-Lantern"
	desc = "An emag fitted to support the Halloween season. Candle not included."
	category = "Holiday"
	item = /obj/item/card/emag/halloween
	surplus = 0
