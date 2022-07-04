#define STRONG_PUNCH_COMBO "HH"
#define LAUNCH_KICK_COMBO "HD"
#define DROP_KICK_COMBO "HG"

/datum/martial_art/the_sleeping_carp
	name = "The Sleeping Carp"
	id = MARTIALART_SLEEPINGCARP
	allow_temp_override = FALSE
	help_verb = /mob/living/proc/sleeping_carp_help
	display_combos = TRUE

/datum/martial_art/the_sleeping_carp/proc/check_streak(mob/living/A, mob/living/D)
	if(findtext(streak,STRONG_PUNCH_COMBO))
		streak = ""
		strongPunch(A,D)
		return TRUE
	if(findtext(streak,LAUNCH_KICK_COMBO))
		streak = ""
		launchKick(A,D)
		return TRUE
	if(findtext(streak,DROP_KICK_COMBO))
		streak = ""
		dropKick(A,D)
		return TRUE
	return FALSE

///Gnashing Teeth: Harm Harm, consistent 20 force punch on every second harm punch
/datum/martial_art/the_sleeping_carp/proc/strongPunch(mob/living/A, mob/living/D)
	///this var is so that the strong punch is always aiming for the body part the user is targeting and not trying to apply to the chest before deviating
	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("precisely kick", "brutally chop", "cleanly hit", "viciously slam")
	D.visible_message(SPAN_DANGER("[A] [atk_verb]s [D]!"), \
					SPAN_USERDANGER("[A] [atk_verb]s you!"), null, null, A)
	to_chat(A, SPAN_DANGER("You [atk_verb] [D]!"))
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 25, TRUE, -1)
	log_combat(A, D, "strong punched (Sleeping Carp)")
	D.apply_damage(20, A.get_attack_type(), affecting)
	return

///Crashing Wave Kick: Harm Disarm combo, throws people seven tiles backwards
/datum/martial_art/the_sleeping_carp/proc/launchKick(mob/living/A, mob/living/D)
	A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	D.visible_message(SPAN_WARNING("[A] kicks [D] square in the chest, sending them flying!"), \
					SPAN_USERDANGER("You are kicked square in the chest by [A], sending you flying!"), SPAN_HEAR("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(D, A.dir)
	D.throw_at(throw_target, 7, 14, A)
	D.apply_damage(15, A.get_attack_type(), BODY_ZONE_CHEST, wound_bonus = CANT_WOUND)
	log_combat(A, D, "launchkicked (Sleeping Carp)")
	return

///Keelhaul: Harm Grab combo, knocks people down, deals stamina damage while they're on the floor
/datum/martial_art/the_sleeping_carp/proc/dropKick(mob/living/A, mob/living/D)
	A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
	if(D.body_position == STANDING_UP)
		D.apply_damage(10, A.get_attack_type(), BODY_ZONE_HEAD, wound_bonus = CANT_WOUND)
		D.apply_damage(40, STAMINA, BODY_ZONE_HEAD)
		D.Knockdown(40)
		D.visible_message(SPAN_WARNING("[A] kicks [D] in the head, sending them face first into the floor!"), \
					SPAN_USERDANGER("You are kicked in the head by [A], sending you crashing to the floor!"), SPAN_HEAR("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	else
		D.apply_damage(5, A.get_attack_type(), BODY_ZONE_HEAD, wound_bonus = CANT_WOUND)
		D.apply_damage(40, STAMINA, BODY_ZONE_HEAD)
		D.drop_all_held_items()
		D.visible_message(SPAN_WARNING("[A] kicks [D] in the head!"), \
					SPAN_USERDANGER("You are kicked in the head by [A]!"), SPAN_HEAR("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	log_combat(A, D, "dropkicked (Sleeping Carp)")
	return

/datum/martial_art/the_sleeping_carp/grab_act(mob/living/A, mob/living/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "grabbed (Sleeping Carp)")
	return ..()

/datum/martial_art/the_sleeping_carp/harm_act(mob/living/A, mob/living/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	var/atk_verb = pick("kick", "chop", "hit", "slam")
	D.visible_message(SPAN_DANGER("[A] [atk_verb]s [D]!"), \
					SPAN_USERDANGER("[A] [atk_verb]s you!"), null, null, A)
	to_chat(A, SPAN_DANGER("You [atk_verb] [D]!"))
	D.apply_damage(rand(10,15), BRUTE, affecting, wound_bonus = CANT_WOUND)
	playsound(get_turf(D), 'sound/weapons/punch1.ogg', 25, TRUE, -1)
	log_combat(A, D, "punched (Sleeping Carp)")
	return TRUE

/datum/martial_art/the_sleeping_carp/disarm_act(mob/living/A, mob/living/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "disarmed (Sleeping Carp)")
	return ..()

/datum/martial_art/the_sleeping_carp/on_projectile_hit(mob/living/A, obj/projectile/P, def_zone)
	. = ..()
	if(A.incapacitated(FALSE, TRUE)) //NO STUN
		return BULLET_ACT_HIT
	if(!(A.mobility_flags & MOBILITY_USE)) //NO UNABLE TO USE
		return BULLET_ACT_HIT
	var/datum/dna/dna = A.has_dna()
	if(dna?.check_mutation(HULK)) //NO HULK
		return BULLET_ACT_HIT
	if(!isturf(A.loc)) //NO MOTHERFLIPPIN MECHS!
		return BULLET_ACT_HIT
	if(A.throw_mode)
		A.visible_message(SPAN_DANGER("[A] effortlessly swats the projectile aside! They can block bullets with their bare hands!"), SPAN_USERDANGER("You deflect the projectile!"))
		playsound(get_turf(A), pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, TRUE)
		P.firer = A
		P.set_angle(rand(0, 360))//SHING
		return BULLET_ACT_FORCE_PIERCE
	return BULLET_ACT_HIT

/datum/martial_art/the_sleeping_carp/teach(mob/living/H, make_temporary = FALSE)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(H, TRAIT_NOGUNS, SLEEPING_CARP_TRAIT)
	ADD_TRAIT(H, TRAIT_HARDLY_WOUNDED, SLEEPING_CARP_TRAIT)
	ADD_TRAIT(H, TRAIT_NODISMEMBER, SLEEPING_CARP_TRAIT)
	H.faction |= "carp" //:D

/datum/martial_art/the_sleeping_carp/on_remove(mob/living/H)
	. = ..()
	REMOVE_TRAIT(H, TRAIT_NOGUNS, SLEEPING_CARP_TRAIT)
	REMOVE_TRAIT(H, TRAIT_HARDLY_WOUNDED, SLEEPING_CARP_TRAIT)
	REMOVE_TRAIT(H, TRAIT_NODISMEMBER, SLEEPING_CARP_TRAIT)

	H.faction -= "carp" //:(


/// Verb added to humans who learn the art of the sleeping carp.
/mob/living/proc/sleeping_carp_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Sleeping Carp clan."
	set category = "Sleeping Carp"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Sleeping Carp...</i></b>\n\
	[SPAN_NOTICE("Gnashing Teeth")]: Harm Harm. Deal additional damage every second (consecutive) punch!\n\
	[SPAN_NOTICE("Crashing Wave Kick")]: Harm Disarm. Launch your opponent away from you with incredible force!\n\
	[SPAN_NOTICE("Keelhaul")]: Harm Grab. Kick an opponent to the floor, knocking them down! If your opponent is already prone, this move will disarm them and deal additional stamina damage to them.\n\
	<span class='notice'>While in throw mode (and not stunned, not a hulk, and not in a mech), you can reflect all projectiles that come your way, sending them back at the people who fired them!\
	Also, you are more resilient against suffering wounds in combat, and your limbs cannot be dismembered. This grants you extra staying power during extended combat, especially against slashing and other bleeding weapons.\
	You are not invincible, however- while you may not suffer debilitating wounds often, you must still watch your health and appropriate medical supplies when possible for use during downtime.\
	In addition, your training has imbued you with a loathing of guns, and you can no longer use them.</span>")

