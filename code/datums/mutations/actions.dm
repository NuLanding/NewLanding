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
