//predominantly negative traits

/datum/quirk/badback
	name = "Bad Back"
	desc = "Thanks to your poor posture, backpacks and other bags never sit right on your back. More evently weighted objects are fine, though."
	value = -8
	mood_quirk = TRUE
	gain_text = SPAN_DANGER("Your back REALLY hurts!")
	lose_text = SPAN_NOTICE("Your back feels better.")
	medical_record_text = "Patient scans indicate severe and chronic back pain."
	var/datum/weakref/backpack

/datum/quirk/badback/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/storage/backpack/equipped_backpack = human_holder.back
	if(istype(equipped_backpack))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "back_pain", /datum/mood_event/back_pain)
		RegisterSignal(human_holder.back, COMSIG_ITEM_POST_UNEQUIP, .proc/on_unequipped_backpack)
	else
		RegisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM, .proc/on_equipped_item)

/datum/quirk/badback/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM)

	var/obj/item/storage/equipped_backpack = backpack?.resolve()
	if(equipped_backpack)
		UnregisterSignal(equipped_backpack, COMSIG_ITEM_POST_UNEQUIP)
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "back_pain")

/// Signal handler for when the quirk_holder equips an item. If it's a backpack, adds the back_pain mood event.
/datum/quirk/badback/proc/on_equipped_item(mob/living/source, obj/item/equipped_item, slot)
	SIGNAL_HANDLER

	if((slot != ITEM_SLOT_BACK) || !istype(equipped_item, /obj/item/storage/backpack))
		return

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "back_pain", /datum/mood_event/back_pain)
	RegisterSignal(equipped_item, COMSIG_ITEM_POST_UNEQUIP, .proc/on_unequipped_backpack)
	UnregisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM)
	backpack = WEAKREF(equipped_item)

/// Signal handler for when the quirk_holder unequips an equipped backpack. Removes the back_pain mood event.
/datum/quirk/badback/proc/on_unequipped_backpack(obj/item/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_ITEM_POST_UNEQUIP)
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "back_pain")
	backpack = null
	RegisterSignal(quirk_holder, COMSIG_MOB_EQUIPPED_ITEM, .proc/on_equipped_item)

/datum/quirk/blooddeficiency
	name = "Blood Deficiency"
	desc = "Your body can't produce enough blood to sustain itself."
	value = -8
	gain_text = SPAN_DANGER("You feel your vigor slowly fading away.")
	lose_text = SPAN_NOTICE("You feel vigorous again.")
	medical_record_text = "Patient requires regular treatment for blood loss due to low production of blood."
	processing_quirk = TRUE

/datum/quirk/blooddeficiency/process(delta_time)
	if(quirk_holder.stat == DEAD)
		return

	var/mob/living/carbon/human/H = quirk_holder
	if(NOBLOOD in H.dna.species.species_traits) //can't lose blood if your species doesn't have any
		return

	if (H.blood_volume > (BLOOD_VOLUME_SAFE - 25)) // just barely survivable without treatment
		H.blood_volume -= 0.275 * delta_time

/datum/quirk/deafness
	name = "Deaf"
	desc = "You are incurably deaf."
	value = -8
	mob_trait = TRAIT_DEAF
	gain_text = SPAN_DANGER("You can't hear anything.")
	lose_text = SPAN_NOTICE("You're able to hear again!")
	medical_record_text = "Patient's cochlear nerve is incurably damaged."

/datum/quirk/depression
	name = "Depression"
	desc = "You sometimes just hate life."
	mob_trait = TRAIT_DEPRESSION
	value = -3
	gain_text = SPAN_DANGER("You start feeling depressed.")
	lose_text = SPAN_NOTICE("You no longer feel depressed.") //if only it were that easy!
	medical_record_text = "Patient has a mild mood disorder causing them to experience acute episodes of depression."
	mood_quirk = TRUE

/datum/quirk/item_quirk/family_heirloom
	name = "Family Heirloom"
	desc = "You are the current owner of an heirloom, passed down for generations. You have to keep it safe!"
	value = -2
	mood_quirk = TRUE
	medical_record_text = "Patient demonstrates an unnatural attachment to a family heirloom."
	processing_quirk = TRUE
	/// A weak reference to our heirloom.
	var/datum/weakref/heirloom

/datum/quirk/item_quirk/family_heirloom/add_unique()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/heirloom_type

	// The quirk holder's species - we have a 50% chance, if we have a species with a set heirloom, to choose a species heirloom.
	var/datum/species/holder_species = human_holder.dna?.species
	if(holder_species && LAZYLEN(holder_species.family_heirlooms) && prob(50))
		heirloom_type = pick(holder_species.family_heirlooms)
	else
		// Our quirk holder's job
		var/datum/job/holder_job = human_holder.mind?.assigned_role
		if(holder_job && LAZYLEN(holder_job.family_heirlooms))
			heirloom_type = pick(holder_job.family_heirlooms)

	// If we didn't find an heirloom somehow, throw them a generic one
	if(!heirloom_type)
		heirloom_type = pick(/obj/item/toy/cards/deck, /obj/item/dice/d20)

	var/obj/new_heirloom = new heirloom_type(get_turf(human_holder))
	heirloom = WEAKREF(new_heirloom)

	give_item_to_holder(
		new_heirloom,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		),
		flavour_text = "This is a precious family heirloom, passed down from generation to generation. Keep it safe!",
	)

/datum/quirk/item_quirk/family_heirloom/post_add()
	var/list/names = splittext(quirk_holder.real_name, " ")
	var/family_name = names[names.len]

	var/obj/family_heirloom = heirloom?.resolve()
	if(!family_heirloom)
		to_chat(quirk_holder, SPAN_BOLDNOTICE("A wave of existential dread runs over you as you realise your precious family heirloom is missing. Perhaps the Gods will show mercy on your cursed soul?"))
		return

	family_heirloom.AddComponent(/datum/component/heirloom, quirk_holder.mind, family_name)

	return ..()

/datum/quirk/item_quirk/family_heirloom/process()
	if(quirk_holder.stat == DEAD)
		return

	var/obj/family_heirloom = heirloom?.resolve()

	if(family_heirloom && (family_heirloom in quirk_holder.GetAllContents()))
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom_missing")
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "family_heirloom", /datum/mood_event/family_heirloom)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom")
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "family_heirloom_missing", /datum/mood_event/family_heirloom_missing)

/datum/quirk/item_quirk/family_heirloom/remove()
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom_missing")
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom")

/datum/quirk/frail
	name = "Frail"
	desc = "You have skin of paper and bones of glass! You suffer wounds much more easily than most."
	value = -6
	mob_trait = TRAIT_EASILY_WOUNDED
	gain_text = SPAN_DANGER("You feel frail.")
	lose_text = SPAN_NOTICE("You feel sturdy again.")
	medical_record_text = "Patient is absurdly easy to injure. Please take all due dilligence to avoid possible malpractice suits."

/datum/quirk/heavy_sleeper
	name = "Heavy Sleeper"
	desc = "You sleep like a rock! Whenever you're put to sleep or knocked unconscious, you take a little bit longer to wake up."
	value = -2
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = SPAN_DANGER("You feel sleepy.")
	lose_text = SPAN_NOTICE("You feel awake again.")
	medical_record_text = "Patient has abnormal sleep study results and is difficult to wake up."

/datum/quirk/hypersensitive
	name = "Hypersensitive"
	desc = "For better or worse, everything seems to affect your mood more than it should."
	value = -2
	gain_text = SPAN_DANGER("You seem to make a big deal out of everything.")
	lose_text = SPAN_NOTICE("You don't seem to make a big deal out of everything anymore.")
	medical_record_text = "Patient demonstrates a high level of emotional volatility."

/datum/quirk/hypersensitive/add()
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood)
		mood.mood_modifier += 0.5

/datum/quirk/hypersensitive/remove()
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood)
		mood.mood_modifier -= 0.5

/datum/quirk/light_drinker
	name = "Light Drinker"
	desc = "You just can't handle your drinks and get drunk very quickly."
	value = -2
	mob_trait = TRAIT_LIGHT_DRINKER
	gain_text = SPAN_NOTICE("Just the thought of drinking alcohol makes your head spin.")
	lose_text = SPAN_DANGER("You're no longer severely affected by alcohol.")
	medical_record_text = "Patient demonstrates a low tolerance for alcohol. (Wimp)"

/datum/quirk/nyctophobia
	name = "Nyctophobia"
	desc = "As far as you can remember, you've always been afraid of the dark. While in the dark without a light source, you instinctually act careful, and constantly feel a sense of dread."
	value = -3
	medical_record_text = "Patient demonstrates a fear of the dark. (Seriously?)"

/datum/quirk/nyctophobia/add()
	RegisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED, .proc/on_holder_moved)

/datum/quirk/nyctophobia/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED)
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "nyctophobia")

/// Called when the quirk holder moves. Updates the quirk holder's mood.
/datum/quirk/nyctophobia/proc/on_holder_moved(/mob/living/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER

	if(quirk_holder.stat == DEAD)
		return

	var/mob/living/carbon/human/human_holder = quirk_holder

	if(human_holder.dna?.species.id in list("shadow", "nightmare"))
		return

	var/turf/holder_turf = get_turf(quirk_holder)

	var/lums = holder_turf.get_lumcount()

	if(lums > 0.2)
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "nyctophobia")
		return

	if(quirk_holder.m_intent == MOVE_INTENT_RUN)
		to_chat(quirk_holder, SPAN_WARNING("Easy, easy, take it slow... you're in the dark..."))
		quirk_holder.toggle_move_intent()
	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "nyctophobia", /datum/mood_event/nyctophobia)

/datum/quirk/nonviolent
	name = "Pacifist"
	desc = "The thought of violence makes you sick. So much so, in fact, that you can't hurt anyone."
	value = -8
	mob_trait = TRAIT_PACIFISM
	gain_text = SPAN_DANGER("You feel repulsed by the thought of violence!")
	lose_text = SPAN_NOTICE("You think you can defend yourself again.")
	medical_record_text = "Patient is unusually pacifistic and cannot bring themselves to cause physical harm."

/datum/quirk/paraplegic
	name = "Paraplegic"
	desc = "Your legs do not function. Nothing will ever fix this. But hey, free wheelchair!"
	value = -12
	human_only = TRUE
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "Patient has an untreatable impairment in motor function in the lower extremities."

/datum/quirk/paraplegic/add_unique()
	if(quirk_holder.buckled) // Handle late joins being buckled to arrival shuttle chairs.
		quirk_holder.buckled.unbuckle_mob(quirk_holder)

	var/turf/holder_turf = get_turf(quirk_holder)
	var/obj/structure/chair/spawn_chair = locate() in holder_turf

	var/obj/vehicle/ridden/wheelchair/wheels = new(holder_turf)
	if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
		wheels.setDir(spawn_chair.dir)

	wheels.buckle_mob(quirk_holder)

	// During the spawning process, they may have dropped what they were holding, due to the paralysis
	// So put the things back in their hands.
	for(var/obj/item/dropped_item in holder_turf)
		if(dropped_item.fingerprintslast == quirk_holder.ckey)
			quirk_holder.put_in_hands(dropped_item)

/datum/quirk/paraplegic/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/paraplegic/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/poor_aim
	name = "Stormtrooper Aim"
	desc = "You've never hit anything you were aiming for in your life."
	value = -4
	mob_trait = TRAIT_POOR_AIM
	medical_record_text = "Patient possesses a strong tremor in both hands."

/datum/quirk/prosopagnosia
	name = "Prosopagnosia"
	desc = "You have a mental disorder that prevents you from being able to recognize faces at all."
	value = -4
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Patient suffers from prosopagnosia and cannot recognize faces."

/datum/quirk/pushover
	name = "Pushover"
	desc = "Your first instinct is always to let people push you around. Resisting out of grabs will take conscious effort."
	value = -8
	mob_trait = TRAIT_GRABWEAKNESS
	gain_text = SPAN_DANGER("You feel like a pushover.")
	lose_text = SPAN_NOTICE("You feel like standing up for yourself.")
	medical_record_text = "Patient presents a notably unassertive personality and is easy to manipulate."

/datum/quirk/insanity
	name = "Reality Dissociation Syndrome"
	desc = "You suffer from a severe disorder that causes very vivid hallucinations. Mindbreaker toxin can suppress its effects, and you are immune to mindbreaker's hallucinogenic properties. <b>This is not a license to grief.</b>"
	value = -8
	mob_trait = TRAIT_INSANITY
	gain_text = SPAN_USERDANGER("...")
	lose_text = SPAN_NOTICE("You feel in tune with the world again.")
	medical_record_text = "Patient suffers from acute Reality Dissociation Syndrome and experiences vivid hallucinations."
	processing_quirk = TRUE

/datum/quirk/insanity/process(delta_time)
	if(quirk_holder.stat == DEAD)
		return

	if(DT_PROB(2, delta_time))
		quirk_holder.hallucination += rand(10, 25)

/datum/quirk/insanity/post_add() //I don't /think/ we'll need this but for newbies who think "roleplay as insane" = "license to kill" it's probably a good thing to have
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, "<span class='big bold info'>Please note that your dissociation syndrome does NOT give you the right to attack people or otherwise cause any interference to \
	the round. You are not an antagonist, and the rules will treat you the same as other crewmembers.</span>")

/datum/quirk/social_anxiety
	name = "Social Anxiety"
	desc = "Talking to people is very difficult for you, and you often stutter or even lock up."
	value = -3
	gain_text = SPAN_DANGER("You start worrying about what you're saying.")
	lose_text = SPAN_NOTICE("You feel easier about talking again.") //if only it were that easy!
	medical_record_text = "Patient is usually anxious in social encounters and prefers to avoid them."
	mob_trait = TRAIT_ANXIOUS
	var/dumb_thing = TRUE

/datum/quirk/social_anxiety/add()
	RegisterSignal(quirk_holder, COMSIG_MOB_EYECONTACT, .proc/eye_contact)
	RegisterSignal(quirk_holder, COMSIG_MOB_EXAMINATE, .proc/looks_at_floor)
	RegisterSignal(quirk_holder, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/quirk/social_anxiety/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_EYECONTACT, COMSIG_MOB_EXAMINATE, COMSIG_MOB_SAY))

/datum/quirk/social_anxiety/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return

	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	var/moodmod
	if(mood)
		moodmod = (1+0.02*(50-(max(50, mood.mood_level*(7-mood.sanity_level))))) //low sanity levels are better, they max at 6
	else
		moodmod = (1+0.02*(50-(max(50, 0.1*quirk_holder.nutrition))))
	var/nearby_people = 0
	for(var/mob/living/carbon/human/H in oview(3, quirk_holder))
		if(H.client)
			nearby_people++
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()
		var/mob/living/carbon/human/quirker = quirk_holder
		for(var/word in message_split)
			if(prob(max(5,(nearby_people*12.5*moodmod))) && word != message_split[1]) //Minimum 1/20 chance of filler
				new_message += pick("uh,","erm,","um,")
				if(prob(min(5,(0.05*(nearby_people*12.5)*moodmod)))) //Max 1 in 20 chance of cutoff after a succesful filler roll, for 50% odds in a 15 word sentence
					quirker.silent = max(3, quirker.silent)
					to_chat(quirker, SPAN_DANGER("You feel self-conscious and stop talking. You need a moment to recover!"))
					break
			if(prob(max(5,(nearby_people*12.5*moodmod)))) //Minimum 1/20 chance of stutter
				word = html_decode(word)
				var/leng = length(word)
				var/stuttered = ""
				var/newletter = ""
				var/rawchar = ""
				var/static/regex/nostutter = regex(@@[aeiouAEIOU ""''()[\]{}.!?,:;_`~-]@)
				for(var/i = 1, i <= leng, i += length(rawchar))
					rawchar = newletter = word[i]
					if(prob(80) && !nostutter.Find(rawchar))
						if(prob(10))
							newletter = "[newletter]-[newletter]-[newletter]-[newletter]"
						else if(prob(20))
							newletter = "[newletter]-[newletter]-[newletter]"
						else
							newletter = "[newletter]-[newletter]"
					stuttered += newletter
				sanitize(stuttered)
				new_message += stuttered
			else
				new_message += word
		message = jointext(new_message, " ")
	var/mob/living/carbon/human/quirker = quirk_holder
	if(prob(min(50,(0.50*(nearby_people*12.5)*moodmod)))) //Max 50% chance of not talking
		if(dumb_thing)
			to_chat(quirker, SPAN_USERDANGER("You think of a dumb thing you said a long time ago and scream internally."))
			dumb_thing = FALSE //only once per life
			if(prob(1))
				new/obj/item/food/spaghetti/pastatomato(get_turf(quirker)) //now that's what I call spaghetti code
		else
			to_chat(quirk_holder, SPAN_WARNING("You think that wouldn't add much to the conversation and decide not to say it."))
			if(prob(min(25,(0.25*(nearby_people*12.75)*moodmod)))) //Max 25% chance of silence stacks after succesful not talking roll
				to_chat(quirker, SPAN_DANGER("You retreat into yourself. You <i>really</i> don't feel up to talking."))
				quirker.silent = max(5, quirker.silent)
		speech_args[SPEECH_MESSAGE] = pick("Uh.","Erm.","Um.")
	else
		speech_args[SPEECH_MESSAGE] = message

// small chance to make eye contact with inanimate objects/mindless mobs because of nerves
/datum/quirk/social_anxiety/proc/looks_at_floor(datum/source, atom/A)
	SIGNAL_HANDLER

	var/mob/living/mind_check = A
	if(prob(85) || (istype(mind_check) && mind_check.mind))
		return

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, quirk_holder, SPAN_SMALLNOTICE("You make eye contact with [A].")), 3)

/datum/quirk/social_anxiety/proc/eye_contact(datum/source, mob/living/other_mob, triggering_examiner)
	SIGNAL_HANDLER

	if(prob(75))
		return
	var/msg
	if(triggering_examiner)
		msg = "You make eye contact with [other_mob], "
	else
		msg = "[other_mob] makes eye contact with you, "

	switch(rand(1,3))
		if(1)
			quirk_holder.Jitter(10)
			msg += "causing you to start fidgeting!"
		if(2)
			quirk_holder.stuttering = max(3, quirk_holder.stuttering)
			msg += "causing you to start stuttering!"
		if(3)
			quirk_holder.Stun(2 SECONDS)
			msg += "causing you to freeze up!"

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "anxiety_eyecontact", /datum/mood_event/anxiety_eyecontact)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, quirk_holder, SPAN_USERDANGER("[msg]")), 3) // so the examine signal has time to fire and this will print after
	return COMSIG_BLOCK_EYECONTACT

/datum/mood_event/anxiety_eyecontact
	description = "<span class='warning'>Sometimes eye contact makes me so nervous...</span>\n"
	mood_change = -5
	timeout = 3 MINUTES

/datum/quirk/item_quirk/junkie
	name = "Junkie"
	desc = "You can't get enough of hard drugs."
	value = -6
	gain_text = SPAN_DANGER("You suddenly feel the craving for drugs.")
	medical_record_text = "Patient has a history of hard drugs."
	processing_quirk = TRUE
	var/drug_list = list(/datum/reagent/drug/crank, /datum/reagent/drug/krokodil, /datum/reagent/medicine/morphine, /datum/reagent/drug/happiness, /datum/reagent/drug/methamphetamine) //List of possible IDs
	var/datum/reagent/reagent_type //!If this is defined, reagent_id will be unused and the defined reagent type will be instead.
	var/datum/reagent/reagent_instance //! actual instanced version of the reagent
	var/where_drug //! Where the drug spawned
	var/obj/item/drug_container_type //! If this is defined before pill generation, pill generation will be skipped. This is the type of the pill bottle.
	var/where_accessory //! where the accessory spawned
	var/obj/item/accessory_type //! If this is null, an accessory won't be spawned.
	var/process_interval = 30 SECONDS //! how frequently the quirk processes
	var/next_process = 0 //! ticker for processing
	var/drug_flavour_text = "Better hope you don't run out..."

/datum/quirk/item_quirk/junkie/add_unique()
	var/mob/living/carbon/human/human_holder = quirk_holder

	if(!reagent_type)
		reagent_type = pick(drug_list)

	reagent_instance = new reagent_type()

	for(var/addiction in reagent_instance.addiction_types)
		human_holder.mind.add_addiction_points(addiction, 1000)

	var/current_turf = get_turf(quirk_holder)

	if(!drug_container_type)
		drug_container_type = /obj/item/storage/pill_bottle

	var/obj/item/drug_instance = new drug_container_type(current_turf)
	if(istype(drug_instance, /obj/item/storage/pill_bottle))
		var/pill_state = "pill[rand(1,20)]"
		for(var/i in 1 to 7)
			var/obj/item/reagent_containers/pill/pill = new(drug_instance)
			pill.icon_state = pill_state
			pill.reagents.add_reagent(reagent_type, 3)

	give_item_to_holder(
		drug_instance,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		),
		flavour_text = drug_flavour_text,
	)

	if(accessory_type)
		give_item_to_holder(
		accessory_type,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		)
	)

/datum/quirk/item_quirk/junkie/remove()
	if(quirk_holder && reagent_instance)
		for(var/addiction_type in subtypesof(/datum/addiction))
			quirk_holder.mind.remove_addiction_points(addiction_type, MAX_ADDICTION_POINTS)

/datum/quirk/item_quirk/junkie/process(delta_time)
	if(HAS_TRAIT(quirk_holder, TRAIT_NOMETABOLISM))
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(world.time > next_process)
		next_process = world.time + process_interval
		var/deleted = QDELETED(reagent_instance)
		var/missing_addiction = FALSE
		for(var/addiction_type in reagent_instance.addiction_types)
			if(!LAZYACCESS(human_holder.mind.active_addictions, addiction_type))
				missing_addiction = TRUE
		if(deleted || missing_addiction)
			if(deleted)
				reagent_instance = new reagent_type()
			to_chat(quirk_holder, SPAN_DANGER("You thought you kicked it, but you feel like you're falling back onto bad habits.."))
			for(var/addiction in reagent_instance.addiction_types)
				human_holder.mind.add_addiction_points(addiction, 1000) ///Max that shit out

/datum/quirk/unstable
	name = "Unstable"
	desc = "Due to past troubles, you are unable to recover your sanity if you lose it. Be very careful managing your mood!"
	value = -10
	mob_trait = TRAIT_UNSTABLE
	gain_text = SPAN_DANGER("There's a lot on your mind right now.")
	lose_text = SPAN_NOTICE("Your mind finally feels calm.")
	medical_record_text = "Patient's mind is in a vulnerable state, and cannot recover from traumatic events."

/datum/quirk/bad_touch
	name = "Bad Touch"
	desc = "You don't like hugs. You'd really prefer if people just left you alone."
	mob_trait = TRAIT_BADTOUCH
	value = -1
	gain_text = SPAN_DANGER("You just want people to leave you alone.")
	lose_text = SPAN_NOTICE("You could use a big hug.")
	medical_record_text = "Patient has disdain for being touched. Potentially has undiagnosed haphephobia."
	mood_quirk = TRUE

/datum/quirk/bad_touch/add()
	RegisterSignal(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HUGGED, COMSIG_CARBON_HEADPAT), .proc/uncomfortable_touch)

/datum/quirk/bad_touch/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HUGGED, COMSIG_CARBON_HEADPAT))

/datum/quirk/bad_touch/proc/uncomfortable_touch()
	SIGNAL_HANDLER

	new /obj/effect/temp_visual/annoyed(quirk_holder.loc)
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood.sanity <= SANITY_NEUTRAL)
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_touch", /datum/mood_event/very_bad_touch)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_touch", /datum/mood_event/bad_touch)

/datum/quirk/mute
	name = "Mute"
	desc = "Due to some accident, medical condition, or simply by choice, you are completely unable to speak."
	value = -2
	gain_text = SPAN_DANGER("You find yourself unable to speak!")
	lose_text = SPAN_NOTICE("You feel a growing strength in your vocal chords.")
	medical_record_text = "Functionally mute, patient is unable to use their voice in any capacity."

/datum/quirk/mute/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(new /datum/brain_trauma/severe/mute, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/mute/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder?.cure_trauma_type(/datum/brain_trauma/severe/mute, TRAUMA_RESILIENCE_ABSOLUTE)

