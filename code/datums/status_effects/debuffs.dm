#define TRAIT_STATUS_EFFECT(effect_id) "[effect_id]-trait"

//Largely negative status effects go here, even if they have small benificial effects
//STUN EFFECTS
/datum/status_effect/incapacitating
	tick_interval = 0
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/needs_update_stat = FALSE

/datum/status_effect/incapacitating/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()
	if(. && (needs_update_stat))
		owner.update_stat()


/datum/status_effect/incapacitating/on_remove()
	if(needs_update_stat)
		owner.update_stat()
	return ..()


//STUN
/datum/status_effect/incapacitating/stun
	id = "stun"

/datum/status_effect/incapacitating/stun/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/stun/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	return ..()


//KNOCKDOWN
/datum/status_effect/incapacitating/knockdown
	id = "knockdown"

/datum/status_effect/incapacitating/knockdown/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/knockdown/on_remove()
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	return ..()


//IMMOBILIZED
/datum/status_effect/incapacitating/immobilized
	id = "immobilized"

/datum/status_effect/incapacitating/immobilized/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/immobilized/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	return ..()


//PARALYZED
/datum/status_effect/incapacitating/paralyzed
	id = "paralyzed"

/datum/status_effect/incapacitating/paralyzed/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/paralyzed/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	return ..()


//UNCONSCIOUS
/datum/status_effect/incapacitating/unconscious
	id = "unconscious"
	needs_update_stat = TRUE

/datum/status_effect/incapacitating/unconscious/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/unconscious/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/unconscious/tick()
	if(owner.getStaminaLoss())
		owner.adjustStaminaLoss(-0.3) //reduce stamina loss by 0.3 per tick, 6 per 2 seconds


//SLEEPING
/datum/status_effect/incapacitating/sleeping
	id = "sleeping"
	alert_type = /atom/movable/screen/alert/status_effect/asleep
	needs_update_stat = TRUE
	tick_interval = 2 SECONDS
	var/mob/living/carbon/carbon_owner
	var/mob/living/carbon/human/human_owner

/datum/status_effect/incapacitating/sleeping/on_creation(mob/living/new_owner)
	. = ..()
	if(.)
		if(iscarbon(owner)) //to avoid repeated istypes
			carbon_owner = owner
		if(ishuman(owner))
			human_owner = owner

/datum/status_effect/incapacitating/sleeping/Destroy()
	carbon_owner = null
	human_owner = null
	return ..()

/datum/status_effect/incapacitating/sleeping/on_apply()
	. = ..()
	if(!.)
		return
	if(!HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE))
		ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
		tick_interval = -1
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE), .proc/on_owner_insomniac)
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_SLEEPIMMUNE), .proc/on_owner_sleepy)

/datum/status_effect/incapacitating/sleeping/on_remove()
	UnregisterSignal(owner, list(SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE), SIGNAL_REMOVETRAIT(TRAIT_SLEEPIMMUNE)))
	if(!HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE))
		REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
		tick_interval = initial(tick_interval)
	return ..()

///If the mob is sleeping and gain the TRAIT_SLEEPIMMUNE we remove the TRAIT_KNOCKEDOUT and stop the tick() from happening
/datum/status_effect/incapacitating/sleeping/proc/on_owner_insomniac(mob/living/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	tick_interval = -1

///If the mob has the TRAIT_SLEEPIMMUNE but somehow looses it we make him sleep and restart the tick()
/datum/status_effect/incapacitating/sleeping/proc/on_owner_sleepy(mob/living/source)
	SIGNAL_HANDLER
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	tick_interval = initial(tick_interval)

/datum/status_effect/incapacitating/sleeping/tick()
	if(owner.maxHealth)
		var/health_ratio = owner.health / owner.maxHealth
		var/healing = -0.2
		if((locate(/obj/structure/bed) in owner.loc))
			healing -= 0.3
		else if((locate(/obj/structure/table) in owner.loc))
			healing -= 0.1
		for(var/obj/item/bedsheet/bedsheet in range(owner.loc,0))
			if(bedsheet.loc != owner.loc) //bedsheets in your backpack/neck don't give you comfort
				continue
			healing -= 0.1
			break //Only count the first bedsheet
		if(health_ratio > 0.8)
			owner.adjustBruteLoss(healing)
			owner.adjustFireLoss(healing)
			owner.adjustToxLoss(healing * 0.5, TRUE, TRUE)
		owner.adjustStaminaLoss(healing)
	if(human_owner?.drunkenness)
		human_owner.drunkenness *= 0.997 //reduce drunkenness by 0.3% per tick, 6% per 2 seconds
	if(prob(20))
		if(carbon_owner)
			carbon_owner.handle_dreams()
		if(prob(10) && owner.health > owner.crit_threshold)
			owner.emote("snore")

/atom/movable/screen/alert/status_effect/asleep
	name = "Asleep"
	desc = "You've fallen asleep. Wait a bit and you should wake up. Unless you don't, considering how helpless you are."
	icon_state = "asleep"

//STASIS
/datum/status_effect/grouped/stasis
	id = "stasis"
	duration = -1
	tick_interval = 10
	alert_type = /atom/movable/screen/alert/status_effect/stasis
	var/last_dead_time

/datum/status_effect/grouped/stasis/proc/update_time_of_death()
	if(last_dead_time)
		var/delta = world.time - last_dead_time
		var/new_timeofdeath = owner.timeofdeath + delta
		owner.timeofdeath = new_timeofdeath
		owner.tod = station_time_timestamp(wtime=new_timeofdeath)
		last_dead_time = null
	if(owner.stat == DEAD)
		last_dead_time = world.time

/datum/status_effect/grouped/stasis/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	if(.)
		update_time_of_death()
		owner.reagents?.end_metabolization(owner, FALSE)

/datum/status_effect/grouped/stasis/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	owner.add_filter("stasis_status_ripple", 2, list("type" = "ripple", "flags" = WAVE_BOUNDED, "radius" = 0, "size" = 2))
	var/filter = owner.get_filter("stasis_status_ripple")
	animate(filter, radius = 32, time = 15, size = 0, loop = -1)


/datum/status_effect/grouped/stasis/tick()
	update_time_of_death()

/datum/status_effect/grouped/stasis/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, TRAIT_STATUS_EFFECT(id))
	owner.remove_filter("stasis_status_ripple")
	update_time_of_death()
	return ..()

/atom/movable/screen/alert/status_effect/stasis
	name = "Stasis"
	desc = "Your biological functions have halted. You could live forever this way, but it's pretty boring."
	icon_state = "stasis"

//GOLEM GANG

//OTHER DEBUFFS
/datum/status_effect/strandling //get it, strand as in durathread strand + strangling = strandling hahahahahahahahahahhahahaha i want to die
	id = "strandling"
	examine_text = "SUBJECTPRONOUN seems to be being choked by some durathread strands. You may be able to <b>cut</b> them off."
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/strandling

/datum/status_effect/strandling/on_apply()
	ADD_TRAIT(owner, TRAIT_MAGIC_CHOKE, STATUS_EFFECT_TRAIT)
	return ..()

/datum/status_effect/strandling/on_remove()
	REMOVE_TRAIT(owner, TRAIT_MAGIC_CHOKE, STATUS_EFFECT_TRAIT)
	return ..()

/atom/movable/screen/alert/status_effect/strandling
	name = "Choking strand"
	desc = "A magical strand of Durathread is wrapped around your neck, preventing you from breathing! Click this icon to remove the strand."
	icon_state = "his_grace"
	alerttooltipstyle = "hisgrace"

/atom/movable/screen/alert/status_effect/strandling/Click(location, control, params)
	. = ..()
	if(!.)
		return

	to_chat(owner, SPAN_NOTICE("You attempt to remove the durathread strand from around your neck."))
	if(do_after(owner, 3.5 SECONDS, owner))
		if(isliving(owner))
			var/mob/living/living_owner = owner
			to_chat(living_owner, SPAN_NOTICE("You succesfuly remove the durathread strand."))
			living_owner.remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)

//OTHER DEBUFFS
/datum/status_effect/pacify
	id = "pacify"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	duration = 100
	alert_type = null

/datum/status_effect/pacify/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

/datum/status_effect/pacify/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, STATUS_EFFECT_TRAIT)
	return ..()

/datum/status_effect/pacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, STATUS_EFFECT_TRAIT)

/datum/status_effect/cultghost //is a cult ghost and can't use manifest runes
	id = "cult_ghost"
	duration = -1
	alert_type = null

/datum/status_effect/cultghost/on_apply()
	owner.see_invisible = SEE_INVISIBLE_OBSERVER
	owner.see_in_dark = 2

/datum/status_effect/cultghost/tick()
	if(owner.reagents)
		owner.reagents.del_reagent(/datum/reagent/water/holywater) //can't be deconverted

/// A status effect used for specifying confusion on a living mob.
/// Created automatically with /mob/living/set_confusion.
/datum/status_effect/confusion
	id = "confusion"
	alert_type = null
	var/strength

/datum/status_effect/confusion/tick()
	strength -= 1
	if (strength <= 0)
		owner.remove_status_effect(STATUS_EFFECT_CONFUSION)
		return

/datum/status_effect/confusion/proc/set_strength(new_strength)
	strength = new_strength

/datum/status_effect/stacking/saw_bleed
	id = "saw_bleed"
	tick_interval = 6
	delay_before_decay = 5
	stack_threshold = 10
	max_stacks = 10
	overlay_file = 'icons/effects/bleed.dmi'
	underlay_file = 'icons/effects/bleed.dmi'
	overlay_state = "bleed"
	underlay_state = "bleed"
	var/bleed_damage = 200

/datum/status_effect/stacking/saw_bleed/fadeout_effect()
	new /obj/effect/temp_visual/bleed(get_turf(owner))

/datum/status_effect/stacking/saw_bleed/threshold_cross_effect()
	owner.adjustBruteLoss(bleed_damage)
	var/turf/T = get_turf(owner)
	new /obj/effect/temp_visual/bleed/explode(T)
	for(var/d in GLOB.alldirs)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, d)
	playsound(T, "desecration", 100, TRUE, -1)

/datum/status_effect/stacking/saw_bleed/bloodletting
	id = "bloodletting"
	stack_threshold = 7
	max_stacks = 7
	bleed_damage = 20

/datum/status_effect/neck_slice
	id = "neck_slice"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = -1

/datum/status_effect/neck_slice/tick()
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/throat = H.get_bodypart(BODY_ZONE_HEAD)
	if(H.stat == DEAD || !throat)
		H.remove_status_effect(/datum/status_effect/neck_slice)

	var/still_bleeding = FALSE
	for(var/thing in throat.wounds)
		var/datum/wound/W = thing
		if(W.wound_type == WOUND_SLASH && W.severity > WOUND_SEVERITY_MODERATE)
			still_bleeding = TRUE
			break
	if(!still_bleeding)
		H.remove_status_effect(/datum/status_effect/neck_slice)

	if(prob(10))
		H.emote(pick("gasp", "gag", "choke"))

/obj/effect/temp_visual/curse
	icon_state = "curse"

/obj/effect/temp_visual/curse/Initialize()
	. = ..()
	deltimer(timerid)


/datum/status_effect/gonbola_pacify
	id = "gonbolaPacify"
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = -1
	alert_type = null

/datum/status_effect/gonbola_pacify/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_PACIFISM, CLOTHING_TRAIT)
	ADD_TRAIT(owner, TRAIT_MUTE, CLOTHING_TRAIT)
	to_chat(owner, SPAN_NOTICE("You suddenly feel at peace and feel no need to make any sudden or rash actions..."))

/datum/status_effect/gonbola_pacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, CLOTHING_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_MUTE, CLOTHING_TRAIT)
	return ..()

/datum/status_effect/trance
	id = "trance"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 300
	tick_interval = 10
	examine_text = SPAN_WARNING("SUBJECTPRONOUN seems slow and unfocused.")
	var/stun = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/trance

/atom/movable/screen/alert/status_effect/trance
	name = "Trance"
	desc = "Everything feels so distant, and you can feel your thoughts forming loops inside your head..."
	icon_state = "high"

/datum/status_effect/trance/tick()
	if(stun)
		owner.Stun(60, TRUE)
	owner.dizziness = 20

/datum/status_effect/trance/on_apply()
	if(!iscarbon(owner))
		return FALSE
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, .proc/hypnotize)
	ADD_TRAIT(owner, TRAIT_MUTE, STATUS_EFFECT_TRAIT)
	owner.add_client_colour(/datum/client_colour/monochrome/trance)
	owner.visible_message("[stun ? SPAN_WARNING("[owner] stands still as [owner.p_their()] eyes seem to focus on a distant point.") : ""]", \
	SPAN_WARNING("[pick("You feel your thoughts slow down...", "You suddenly feel extremely dizzy...", "You feel like you're in the middle of a dream...","You feel incredibly relaxed...")]"))
	return TRUE

/datum/status_effect/trance/on_creation(mob/living/new_owner, _duration, _stun = TRUE)
	duration = _duration
	stun = _stun
	return ..()

/datum/status_effect/trance/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	REMOVE_TRAIT(owner, TRAIT_MUTE, STATUS_EFFECT_TRAIT)
	owner.dizziness = 0
	owner.remove_client_colour(/datum/client_colour/monochrome/trance)
	to_chat(owner, SPAN_WARNING("You snap out of your trance!"))

/datum/status_effect/trance/proc/hypnotize(datum/source, list/hearing_args)
	SIGNAL_HANDLER

	if(!owner.can_hear())
		return
	var/mob/hearing_speaker = hearing_args[HEARING_SPEAKER]
	if(hearing_speaker == owner)
		return
	var/mob/living/carbon/C = owner
	C.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY) //clear previous hypnosis
	// The brain trauma itself does its own set of logging, but this is the only place the source of the hypnosis phrase can be found.
	C.log_message("has been hypnotised by the phrase '[hearing_args[HEARING_RAW_MESSAGE]]' spoken by [key_name(hearing_speaker)]", LOG_ATTACK)
	hearing_speaker.log_message("has hypnotised [key_name(C)] with the phrase '[hearing_args[HEARING_RAW_MESSAGE]]'", LOG_ATTACK, log_globally = FALSE)
	addtimer(CALLBACK(C, /mob/living/carbon.proc/gain_trauma, /datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY, hearing_args[HEARING_RAW_MESSAGE]), 10)
	addtimer(CALLBACK(C, /mob/living.proc/Stun, 60, TRUE, TRUE), 15) //Take some time to think about it
	qdel(src)

/datum/status_effect/spasms
	id = "spasms"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null

/datum/status_effect/spasms/tick()
	if(prob(15))
		switch(rand(1,5))
			if(1)
				if((owner.mobility_flags & MOBILITY_MOVE) && isturf(owner.loc))
					to_chat(owner, SPAN_WARNING("Your leg spasms!"))
					step(owner, pick(GLOB.cardinals))
			if(2)
				if(owner.incapacitated())
					return
				var/obj/item/I = owner.get_active_held_item()
				if(I)
					to_chat(owner, SPAN_WARNING("Your fingers spasm!"))
					owner.log_message("used [I] due to a Muscle Spasm", LOG_ATTACK)
					I.attack_self(owner)
			if(3)
				owner.set_combat_mode(TRUE)

				var/range = 1
				if(istype(owner.get_active_held_item(), /obj/item/gun)) //get targets to shoot at
					range = 7

				var/list/mob/living/targets = list()
				for(var/mob/M in oview(owner, range))
					if(isliving(M))
						targets += M
				if(LAZYLEN(targets))
					to_chat(owner, SPAN_WARNING("Your arm spasms!"))
					owner.log_message(" attacked someone due to a Muscle Spasm", LOG_ATTACK) //the following attack will log itself
					owner.ClickOn(pick(targets))
				owner.set_combat_mode(FALSE)
			if(4)
				owner.set_combat_mode(TRUE)
				to_chat(owner, SPAN_WARNING("Your arm spasms!"))
				owner.log_message("attacked [owner.p_them()]self to a Muscle Spasm", LOG_ATTACK)
				owner.ClickOn(owner)
				owner.set_combat_mode(FALSE)
			if(5)
				if(owner.incapacitated())
					return
				var/obj/item/I = owner.get_active_held_item()
				var/list/turf/targets = list()
				for(var/turf/T in oview(owner, 3))
					targets += T
				if(LAZYLEN(targets) && I)
					to_chat(owner, SPAN_WARNING("Your arm spasms!"))
					owner.log_message("threw [I] due to a Muscle Spasm", LOG_ATTACK)
					owner.throw_item(pick(targets))

/datum/status_effect/convulsing
	id = "convulsing"
	duration = 150
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/convulsing

/datum/status_effect/convulsing/on_creation(mob/living/zappy_boy)
	. = ..()
	to_chat(zappy_boy, SPAN_BOLDWARNING("You feel a shock moving through your body! Your hands start shaking!"))

/datum/status_effect/convulsing/tick()
	var/mob/living/carbon/H = owner
	if(prob(40))
		var/obj/item/I = H.get_active_held_item()
		if(I && H.dropItemToGround(I))
			H.visible_message(SPAN_NOTICE("[H]'s hand convulses, and they drop their [I.name]!"),SPAN_USERDANGER("Your hand convulses violently, and you drop what you were holding!"))
			H.jitteriness += 5

/atom/movable/screen/alert/status_effect/convulsing
	name = "Shaky Hands"
	desc = "You've been zapped with something and your hands can't stop shaking! You can't seem to hold on to anything."
	icon_state = "convulsing"

/datum/status_effect/go_away
	id = "go_away"
	duration = 100
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	alert_type = /atom/movable/screen/alert/status_effect/go_away
	var/direction

/datum/status_effect/go_away/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	direction = pick(NORTH, SOUTH, EAST, WEST)
	new_owner.setDir(direction)

/datum/status_effect/go_away/tick()
	owner.AdjustStun(1, ignore_canstun = TRUE)
	var/turf/T = get_step(owner, direction)
	owner.forceMove(T)

/atom/movable/screen/alert/status_effect/go_away
	name = "TO THE STARS AND BEYOND!"
	desc = "I must go, my people need me!"
	icon_state = "high"

/datum/status_effect/fake_virus
	id = "fake_virus"
	duration = 1800//3 minutes
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	alert_type = null
	var/msg_stage = 0//so you dont get the most intense messages immediately

/datum/status_effect/fake_virus/tick()
	var/fake_msg = ""
	var/fake_emote = ""
	switch(msg_stage)
		if(0 to 300)
			if(prob(1))
				fake_msg = pick(SPAN_WARNING("[pick("Your head hurts.", "Your head pounds.")]"),
				SPAN_WARNING("[pick("You're having difficulty breathing.", "Your breathing becomes heavy.")]"),
				SPAN_WARNING("[pick("You feel dizzy.", "Your head spins.")]"),
				"<span notice='warning'>[pick("You swallow excess mucus.", "You lightly cough.")]</span>",
				SPAN_WARNING("[pick("Your head hurts.", "Your mind blanks for a moment.")]"),
				SPAN_WARNING("[pick("Your throat hurts.", "You clear your throat.")]"))
		if(301 to 600)
			if(prob(2))
				fake_msg = pick(SPAN_WARNING("[pick("Your head hurts a lot.", "Your head pounds incessantly.")]"),
				SPAN_WARNING("[pick("Your windpipe feels like a straw.", "Your breathing becomes tremendously difficult.")]"),
				SPAN_WARNING("You feel very [pick("dizzy","woozy","faint")]."),
				SPAN_WARNING("[pick("You hear a ringing in your ear.", "Your ears pop.")]"),
				SPAN_WARNING("You nod off for a moment."))
		else
			if(prob(3))
				if(prob(50))// coin flip to throw a message or an emote
					fake_msg = pick(SPAN_USERDANGER("[pick("Your head hurts!", "You feel a burning knife inside your brain!", "A wave of pain fills your head!")]"),
					SPAN_USERDANGER("[pick("Your lungs hurt!", "It hurts to breathe!")]"),
					SPAN_WARNING("[pick("You feel nauseated.", "You feel like you're going to throw up!")]"))
				else
					fake_emote = pick("cough", "sniff", "sneeze")

	if(fake_emote)
		owner.emote(fake_emote)
	else if(fake_msg)
		to_chat(owner, fake_msg)

	msg_stage++

/datum/status_effect/corrosion_curse
	id = "corrosion_curse"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	tick_interval = 1 SECONDS

/datum/status_effect/corrosion_curse/on_creation(mob/living/new_owner, ...)
	. = ..()
	to_chat(owner, SPAN_DANGER("Your feel your body starting to break apart..."))

/datum/status_effect/corrosion_curse/tick()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/chance = rand(0,100)
	switch(chance)
		if(0 to 19)
			H.vomit()
		if(20 to 29)
			H.Dizzy(10)
		if(30 to 39)
			H.adjustOrganLoss(ORGAN_SLOT_LIVER,5)
		if(40 to 49)
			H.adjustOrganLoss(ORGAN_SLOT_HEART,5)
		if(50 to 59)
			H.adjustOrganLoss(ORGAN_SLOT_STOMACH,5)
		if(60 to 69)
			H.adjustOrganLoss(ORGAN_SLOT_EYES,10)
		if(70 to 79)
			H.adjustOrganLoss(ORGAN_SLOT_EARS,10)
		if(80 to 89)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS,10)
		if(90 to 99)
			H.adjustOrganLoss(ORGAN_SLOT_TONGUE,10)
		if(100)
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN,20)

/datum/status_effect/cloudstruck
	id = "cloudstruck"
	status_type = STATUS_EFFECT_REPLACE
	duration = 3 SECONDS
	on_remove_on_mob_delete = TRUE
	///This overlay is applied to the owner for the duration of the effect.
	var/mutable_appearance/mob_overlay

/datum/status_effect/cloudstruck/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

/datum/status_effect/cloudstruck/on_apply()
	mob_overlay = mutable_appearance('icons/effects/eldritch.dmi', "cloud_swirl", ABOVE_MOB_LAYER)
	owner.overlays += mob_overlay
	owner.update_appearance()
	ADD_TRAIT(owner, TRAIT_BLIND, STATUS_EFFECT_TRAIT)
	return TRUE

/datum/status_effect/cloudstruck/on_remove()
	. = ..()
	if(QDELETED(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_BLIND, STATUS_EFFECT_TRAIT)
	if(owner)
		owner.overlays -= mob_overlay
		owner.update_appearance()

/datum/status_effect/cloudstruck/Destroy()
	. = ..()
	QDEL_NULL(mob_overlay)
