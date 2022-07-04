//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	max_integrity = 200
	integrity_failure = 0.5

/obj/structure/mirror/directional/north
	dir = SOUTH
	pixel_y = 28

/obj/structure/mirror/directional/south
	dir = NORTH
	pixel_y = -28

/obj/structure/mirror/directional/east
	dir = WEST
	pixel_x = 28

/obj/structure/mirror/directional/west
	dir = EAST
	pixel_x = -28

/obj/structure/mirror/Initialize(mapload)
	. = ..()
	if(icon_state == "mirror_broke" && !broken)
		obj_break(null, mapload)

/obj/structure/mirror/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(broken || !Adjacent(user))
		return

/obj/structure/mirror/examine_status(mob/user)
	if(broken)
		return list()// no message spam
	return ..()

/obj/structure/mirror/attacked_by(obj/item/I, mob/living/user)
	if(broken || !istype(user) || !I.force)
		return ..()

	. = ..()
	if(broken) // breaking a mirror truly gets you bad luck!
		to_chat(user, SPAN_WARNING("A chill runs down your spine as [src] shatters..."))
		user.AddComponent(/datum/component/omen, silent=TRUE) // we have our own message

/obj/structure/mirror/bullet_act(obj/projectile/P)
	if(broken || !isliving(P.firer) || !P.damage)
		return ..()

	. = ..()
	if(broken) // breaking a mirror truly gets you bad luck!
		var/mob/living/unlucky_dude = P.firer
		to_chat(unlucky_dude, SPAN_WARNING("A chill runs down your spine as [src] shatters..."))
		unlucky_dude.AddComponent(/datum/component/omen, silent=TRUE) // we have our own message

/obj/structure/mirror/obj_break(damage_flag, mapload)
	. = ..()
	if(broken || (flags_1 & NODECONSTRUCT_1))
		return
	icon_state = "mirror_broke"
	if(!mapload)
		playsound(src, "shatter", 70, TRUE)
	if(desc == initial(desc))
		desc = "Oh no, seven years of bad luck!"
	broken = TRUE

/obj/structure/mirror/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			new /obj/item/shard( src.loc )
	qdel(src)

/obj/structure/mirror/welder_act(mob/living/user, obj/item/I)
	..()
	if(user.combat_mode)
		return FALSE

	if(!broken)
		return TRUE

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, SPAN_NOTICE("You begin repairing [src]..."))
	if(I.use_tool(src, user, 10, volume=50))
		to_chat(user, SPAN_NOTICE("You repair [src]."))
		broken = 0
		icon_state = initial(icon_state)
		desc = initial(desc)

	return TRUE

/obj/structure/mirror/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)
		if(BURN)
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)
