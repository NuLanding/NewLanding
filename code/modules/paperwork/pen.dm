/* Pens!
 * Contains:
 * Pens
 * Sleepy Pens
 * Parapens
 * Edaggers
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_EARS
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=10)
	grind_results = list(/datum/reagent/iron = 2, /datum/reagent/iodine = 1)
	var/colour = "black" //what colour the ink is!
	var/degrees = 0
	var/font = PEN_FONT
	embedding = list(embed_chance = 50)
	sharpness = SHARP_POINTY

/obj/item/pen/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] is scribbling numbers all over [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit sudoku..."))
	return(BRUTELOSS)

/obj/item/pen/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"
	throw_speed = 4 // red ones go faster (in this case, fast enough to embed!)

/obj/item/pen/invisible
	desc = "It's an invisible pen marker."
	icon_state = "pen"
	colour = "white"

/obj/item/pen/fourcolor
	desc = "It's a fancy four-color ink pen, set to black."
	name = "four-color pen"
	colour = "black"

/obj/item/pen/fourcolor/attack_self(mob/living/carbon/user)
	switch(colour)
		if("black")
			colour = "red"
			throw_speed++
		if("red")
			colour = "green"
			throw_speed = initial(throw_speed)
		if("green")
			colour = "blue"
		else
			colour = "black"
	to_chat(user, SPAN_NOTICE("\The [src] will now write in [colour]."))
	desc = "It's a fancy four-color ink pen, set to [colour]."

/obj/item/pen/fountain
	name = "fountain pen"
	desc = "It's a common fountain pen, with a faux wood body."
	icon_state = "pen-fountain"
	font = FOUNTAIN_PEN_FONT

/obj/item/pen/charcoal
	name = "charcoal stylus"
	desc = "It's just a wooden stick with some compressed ash on the end. At least it can write."
	icon_state = "pen-charcoal"
	colour = "dimgray"
	font = CHARCOAL_FONT
	custom_materials = null
	grind_results = list(/datum/reagent/ash = 5, /datum/reagent/cellulose = 10)

/obj/item/pen/fountain/captain
	name = "captain's fountain pen"
	desc = "It's an expensive Oak fountain pen. The nib is quite sharp."
	icon_state = "pen-fountain-o"
	force = 5
	throwforce = 5
	throw_speed = 4
	colour = "crimson"
	custom_materials = list(/datum/material/gold = 750)
	sharpness = SHARP_EDGED
	resistance_flags = FIRE_PROOF
	unique_reskin = list("Oak" = "pen-fountain-o",
						"Gold" = "pen-fountain-g",
						"Rosewood" = "pen-fountain-r",
						"Black and Silver" = "pen-fountain-b",
						"Command Blue" = "pen-fountain-cb"
						)
	embedding = list("embed_chance" = 75)

/obj/item/pen/fountain/captain/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 200, 115) //the pen is mightier than the sword

/obj/item/pen/fountain/captain/reskin_obj(mob/M)
	..()
	if(current_skin)
		desc = "It's an expensive [current_skin] fountain pen. The nib is quite sharp."

/obj/item/pen/attack_self(mob/living/carbon/user)
	var/deg = input(user, "What angle would you like to rotate the pen head to? (1-360)", "Rotate Pen Head") as null|num
	if(deg && (deg > 0 && deg <= 360))
		degrees = deg
		to_chat(user, SPAN_NOTICE("You rotate the top of the pen to [degrees] degrees."))
		SEND_SIGNAL(src, COMSIG_PEN_ROTATED, deg, user)

/obj/item/pen/attack(mob/living/M, mob/user, params)
	if(force) // If the pen has a force value, call the normal attack procs. Used for e-daggers and captain's pen mostly.
		return ..()
	if(!M.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		return FALSE
	to_chat(user, SPAN_WARNING("You stab [M] with the pen."))
	to_chat(M, SPAN_DANGER("You feel a tiny prick!"))
	log_combat(user, M, "stabbed", src)
	return TRUE

/obj/item/pen/afterattack(obj/O, mob/living/user, proximity)
	. = ..()
	//Changing name/description of items. Only works if they have the UNIQUE_RENAME object flag set
	if(isobj(O) && proximity && (O.obj_flags & UNIQUE_RENAME))
		var/penchoice = input(user, "What would you like to edit?", "Rename, change description or reset both?") as null|anything in list("Rename","Change description","Reset")
		if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
			return
		if(penchoice == "Rename")
			var/input = stripped_input(user,"What do you want to name [O]?", ,"[O.name]", MAX_NAME_LEN)
			var/oldname = O.name
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(input == oldname || !input)
				to_chat(user, SPAN_NOTICE("You changed [O] to... well... [O]."))
			else
				O.AddComponent(/datum/component/rename, input, O.desc)
				var/datum/component/label/label = O.GetComponent(/datum/component/label)
				if(label)
					label.remove_label()
					label.apply_label()
				to_chat(user, SPAN_NOTICE("You have successfully renamed \the [oldname] to [O]."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Change description")
			var/input = stripped_input(user,"Describe [O] here:", ,"[O.desc]", 140)
			var/olddesc = O.desc
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(input == olddesc || !input)
				to_chat(user, SPAN_NOTICE("You decide against changing [O]'s description."))
			else
				O.AddComponent(/datum/component/rename, O.name, input)
				to_chat(user, SPAN_NOTICE("You have successfully changed [O]'s description."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Reset")
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return

			qdel(O.GetComponent(/datum/component/rename))

			//reapply any label to name
			var/datum/component/label/label = O.GetComponent(/datum/component/label)
			if(label)
				label.remove_label()
				label.apply_label()

			to_chat(user, SPAN_NOTICE("You have successfully reset [O]'s name and description."))
			O.renamedByPlayer = FALSE

/*
 * Sleepypens
 */

/obj/item/pen/sleepy/attack(mob/living/M, mob/user, params)
	. = ..()
	if(!.)
		return
	if(!reagents.total_volume)
		return
	if(!M.reagents)
		return
	reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = INJECT)


/obj/item/pen/sleepy/Initialize()
	. = ..()
	create_reagents(45, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/toxin/chloralhydrate, 20)
	reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 15)
	reagents.add_reagent(/datum/reagent/toxin/staminatoxin, 10)

/*
 * (Alan) Edaggers
 */
/obj/item/pen/edagger
	attack_verb_continuous = list("slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts") //these won't show up if the pen is off
	attack_verb_simple = list("slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED
	var/on = FALSE

/obj/item/pen/edagger/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 60, 100, 0, 'sound/weapons/blade1.ogg')
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/pen/edagger/get_sharpness()
	return on * sharpness

/obj/item/pen/edagger/suicide_act(mob/user)
	. = BRUTELOSS
	if(on)
		user.visible_message(SPAN_SUICIDE("[user] forcefully rams the pen into their mouth!"))
	else
		user.visible_message(SPAN_SUICIDE("[user] is holding a pen up to their mouth! It looks like [user.p_theyre()] trying to commit suicide!"))
		attack_self(user)

/obj/item/pen/edagger/attack_self(mob/living/user)
	if(on)
		on = FALSE
		force = initial(force)
		throw_speed = initial(throw_speed)
		w_class = initial(w_class)
		name = initial(name)
		hitsound = initial(hitsound)
		embedding = list(embed_chance = EMBED_CHANCE)
		throwforce = initial(throwforce)
		playsound(user, 'sound/weapons/saberoff.ogg', 5, TRUE)
		to_chat(user, SPAN_WARNING("[src] can now be concealed."))
	else
		on = TRUE
		force = 18
		throw_speed = 4
		w_class = WEIGHT_CLASS_NORMAL
		name = "energy dagger"
		hitsound = 'sound/weapons/blade1.ogg'
		embedding = list(embed_chance = 100) //rule of cool
		throwforce = 35
		playsound(user, 'sound/weapons/saberon.ogg', 5, TRUE)
		to_chat(user, SPAN_WARNING("[src] is now active."))
	updateEmbedding()
	update_appearance()

/obj/item/pen/edagger/update_icon_state()
	if(on)
		icon_state = inhand_icon_state = "edagger"
		inhand_icon = 'icons/mob/inhands/weapons/swords_inhand.dmi'
	else
		icon_state = initial(icon_state) //looks like a normal pen when off.
		inhand_icon_state = initial(inhand_icon_state)
		inhand_icon = initial(inhand_icon)
	return ..()
