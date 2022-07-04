/datum/mutation/human/olfaction
	name = "Transcendent Olfaction"
	desc = "Your sense of smell is comparable to that of a canine."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = SPAN_NOTICE("Smells begin to make more sense...")
	text_lose_indication = SPAN_NOTICE("Your sense of smell goes back to normal.")
	power = /obj/effect/proc_holder/spell/targeted/olfaction
	instability = 30
	synchronizer_coeff = 1
	var/reek = 200

/datum/mutation/human/olfaction/modify()
	if(power)
		var/obj/effect/proc_holder/spell/targeted/olfaction/S = power
		S.sensitivity = GET_MUTATION_SYNCHRONIZER(src)

/obj/effect/proc_holder/spell/targeted/olfaction
	name = "Remember the Scent"
	desc = "Get a scent off of the item you're currently holding to track it. With an empty hand, you'll track the scent you've remembered."
	charge_max = 100
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	action_icon_state = "nose"
	var/mob/living/carbon/tracking_target
	var/list/mob/living/carbon/possible = list()
	var/sensitivity = 1

/obj/effect/proc_holder/spell/targeted/olfaction/cast(list/targets, mob/living/user = usr)
	var/atom/sniffed = user.get_active_held_item()
	if(sniffed)
		var/old_target = tracking_target
		possible = list()
		var/list/prints = sniffed.return_fingerprints()
		if(prints)
			for(var/mob/living/carbon/C in GLOB.carbon_list)
				if(prints[md5(C.dna.uni_identity)])
					possible |= C
		if(!length(possible))
			to_chat(user,SPAN_WARNING("Despite your best efforts, there are no scents to be found on [sniffed]..."))
			return
		tracking_target = input(user, "Choose a scent to remember.", "Scent Tracking") as null|anything in sortNames(possible)
		if(!tracking_target)
			if(!old_target)
				to_chat(user,SPAN_WARNING("You decide against remembering any scents. Instead, you notice your own nose in your peripheral vision. This goes on to remind you of that one time you started breathing manually and couldn't stop. What an awful day that was."))
				return
			tracking_target = old_target
			on_the_trail(user)
			return
		to_chat(user,SPAN_NOTICE("You pick up the scent of [tracking_target]. The hunt begins."))
		on_the_trail(user)
		return

	if(!tracking_target)
		to_chat(user,SPAN_WARNING("You're not holding anything to smell, and you haven't smelled anything you can track. You smell your skin instead; it's kinda salty."))
		return

	on_the_trail(user)

/obj/effect/proc_holder/spell/targeted/olfaction/proc/on_the_trail(mob/living/user)
	if(!tracking_target)
		to_chat(user,SPAN_WARNING("You're not tracking a scent, but the game thought you were. Something's gone wrong! Report this as a bug."))
		return
	if(tracking_target == user)
		to_chat(user,SPAN_WARNING("You smell out the trail to yourself. Yep, it's you."))
		return
	if(usr.z < tracking_target.z)
		to_chat(user,SPAN_WARNING("The trail leads... way up above you? Huh. They must be really, really far away."))
		return
	else if(usr.z > tracking_target.z)
		to_chat(user,SPAN_WARNING("The trail leads... way down below you? Huh. They must be really, really far away."))
		return
	var/direction_text = "[dir2text(get_dir(usr, tracking_target))]"
	if(direction_text)
		to_chat(user,SPAN_NOTICE("You consider [tracking_target]'s scent. The trail leads <b>[direction_text].</b>"))

/datum/mutation/human/self_amputation
	name = "Autotomy"
	desc = "Allows a creature to voluntary discard a random appendage."
	quality = POSITIVE
	text_gain_indication = SPAN_NOTICE("Your joints feel loose.")
	instability = 30
	power = /obj/effect/proc_holder/spell/self/self_amputation

	energy_coeff = 1
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/self/self_amputation
	name = "Drop a limb"
	desc = "Concentrate to make a random limb pop right off your body."
	clothes_req = FALSE
	human_req = FALSE
	charge_max = 100
	action_icon_state = "autotomy"

/obj/effect/proc_holder/spell/self/self_amputation/cast(list/targets, mob/user = usr)
	if(!iscarbon(user))
		return

	var/mob/living/carbon/C = user
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return

	var/list/parts = list()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.body_part != HEAD && BP.body_part != CHEST)
			if(BP.dismemberable)
				parts += BP
	if(!parts.len)
		to_chat(usr, SPAN_NOTICE("You can't shed any more limbs!"))
		return

	var/obj/item/bodypart/BP = pick(parts)
	BP.dismember()

/datum/mutation/human/tongue_spike
	name = "Tongue Spike"
	desc = "Allows a creature to voluntary shoot their tongue out as a deadly weapon."
	quality = POSITIVE
	text_gain_indication = SPAN_NOTICE("Your feel like you can throw your voice.")
	instability = 15
	power = /obj/effect/proc_holder/spell/self/tongue_spike

	energy_coeff = 1
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/self/tongue_spike
	name = "Launch spike"
	desc = "Shoot your tongue out in the direction you're facing, embedding it and dealing damage until they remove it."
	clothes_req = FALSE
	human_req = TRUE
	charge_max = 100
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_icon_state = "spike"
	var/spike_path = /obj/item/hardened_spike

/obj/effect/proc_holder/spell/self/tongue_spike/cast(list/targets, mob/user = usr)
	if(!iscarbon(user))
		return

	var/mob/living/carbon/C = user
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return
	var/obj/item/organ/tongue/tongue
	for(var/org in C.internal_organs)
		if(istype(org, /obj/item/organ/tongue))
			tongue = org
			break

	if(!tongue)
		to_chat(C, SPAN_NOTICE("You don't have a tongue to shoot!"))
		return

	tongue.Remove(C, special = TRUE)
	var/obj/item/hardened_spike/spike = new spike_path(get_turf(C), C)
	tongue.forceMove(spike)
	spike.throw_at(get_edge_target_turf(C,C.dir), 14, 4, C)

/obj/item/hardened_spike
	name = "biomass spike"
	desc = "Hardened biomass, shaped into a spike. Very pointy!"
	icon_state = "tonguespike"
	force = 2
	throwforce = 15 //15 + 2 (WEIGHT_CLASS_SMALL) * 4 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = i didnt do the math
	throw_speed = 4
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 100, "embedded_fall_chance" = 0, "embedded_ignore_throwspeed_threshold" = TRUE)
	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_POINTY
	custom_materials = list(/datum/material/biomass = 500)
	var/mob/living/carbon/human/fired_by
	/// if we missed our target
	var/missed = TRUE

/obj/item/hardened_spike/Initialize(mapload, firedby)
	. = ..()
	fired_by = firedby
	addtimer(CALLBACK(src, .proc/checkembedded), 5 SECONDS)

/obj/item/hardened_spike/proc/checkembedded()
	if(missed)
		unembedded()

/obj/item/hardened_spike/embedded(atom/target)
	if(isbodypart(target))
		missed = FALSE

/obj/item/hardened_spike/unembedded()
	var/turf/T = get_turf(src)
	visible_message(SPAN_WARNING("[src] cracks and twists, changing shape!"))
	for(var/i in contents)
		var/obj/o = i
		o.forceMove(T)
	qdel(src)

/datum/mutation/human/tongue_spike/chem
	name = "Chem Spike"
	desc = "Allows a creature to voluntary shoot their tongue out as biomass, allowing a long range transfer of chemicals."
	quality = POSITIVE
	text_gain_indication = SPAN_NOTICE("Your feel like you can really connect with people by throwing your voice.")
	instability = 15
	locked = TRUE
	power = /obj/effect/proc_holder/spell/self/tongue_spike/chem
	energy_coeff = 1
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/self/tongue_spike/chem
	name = "Launch chem spike"
	desc = "Shoot your tongue out in the direction you're facing, embedding it for a very small amount of damage. While the other person has the spike embedded, you can transfer your chemicals to them."
	action_icon_state = "spikechem"
	spike_path = /obj/item/hardened_spike/chem

/obj/item/hardened_spike/chem
	name = "chem spike"
	desc = "Hardened biomass, shaped into... something."
	icon_state = "tonguespikechem"
	throwforce = 2 //2 + 2 (WEIGHT_CLASS_SMALL) * 0 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = i didnt do the math again but very low or smthin
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 100, "embedded_fall_chance" = 0, "embedded_pain_chance" = 0, "embedded_ignore_throwspeed_threshold" = TRUE) //never hurts once it's in you
	var/been_places = FALSE
	var/datum/action/innate/send_chems/chems

/obj/item/hardened_spike/chem/embedded(mob/living/carbon/human/embedded_mob)
	if(been_places)
		return
	been_places = TRUE
	chems = new
	chems.transfered = embedded_mob
	chems.spikey = src
	to_chat(fired_by, SPAN_NOTICE("Link established! Use the \"Transfer Chemicals\" ability to send your chemicals to the linked target!"))
	chems.Grant(fired_by)

/obj/item/hardened_spike/chem/unembedded()
	to_chat(fired_by, SPAN_WARNING("Link lost!"))
	QDEL_NULL(chems)
	..()

/datum/action/innate/send_chems
	icon_icon = 'icons/mob/actions/actions_genetic.dmi'
	background_icon_state = "bg_spell"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "spikechemswap"
	name = "Transfer Chemicals"
	desc = "Send all of your reagents into whomever the chem spike is embedded in. One use."
	var/obj/item/hardened_spike/chem/spikey
	var/mob/living/carbon/human/transfered

/datum/action/innate/send_chems/Activate()
	if(!ishuman(transfered) || !ishuman(owner))
		return
	var/mob/living/carbon/human/transferer = owner

	to_chat(transfered, SPAN_WARNING("You feel a tiny prick!"))
	transferer.reagents.trans_to(transfered, transferer.reagents.total_volume, 1, 1, 0, transfered_by = transferer)

	var/obj/item/bodypart/L = spikey.checkembedded()

	//this is where it would deal damage, if it transfers chems it removes itself so no damage
	spikey.forceMove(get_turf(L))
	transfered.visible_message(SPAN_NOTICE("[spikey] falls out of [transfered]!"))
