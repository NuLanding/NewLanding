/obj/item/hand_labeler
	name = "hand labeler"
	desc = "A combined label printer, applicator, and remover, all in a single portable device. Designed to be easy to operate and use."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	inhand_icon_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0

/obj/item/hand_labeler/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] is pointing [src] at [user.p_them()]self. [user.p_theyre(TRUE)] going to label [user.p_them()]self as a suicide!"))
	labels_left = max(labels_left - 1, 0)

	user.real_name += " (suicide)"
	// NOT EVEN DEATH WILL TAKE AWAY THE STAIN
	user.mind.name += " (suicide)"

	mode = 1
	icon_state = "labeler[mode]"
	label = "suicide"

	return OXYLOSS

/obj/item/hand_labeler/afterattack(atom/A, mob/user,proximity)
	. = ..()
	if(!proximity)
		return
	if(!mode) //if it's off, give up.
		return

	if(!labels_left)
		to_chat(user, SPAN_WARNING("No labels left!"))
		return
	if(!label || !length(label))
		to_chat(user, SPAN_WARNING("No text set!"))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_WARNING("Label too big!"))
		return
	if(ismob(A))
		to_chat(user, SPAN_WARNING("You can't label creatures!")) // use a collar
		return

	user.visible_message(SPAN_NOTICE("[user] labels [A] with \"[label]\"."), \
		SPAN_NOTICE("You label [A] with \"[label]\"."))
	A.AddComponent(/datum/component/label, label)
	playsound(A, 'sound/items/handling/component_pickup.ogg', 20, TRUE)
	labels_left--


/obj/item/hand_labeler/attack_self(mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to use [src]!"))
		return
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on [src]."))
		//Now let them chose the text.
		var/str = reject_bad_text(stripped_input(user, "Label text?", "Set label","", MAX_NAME_LEN))
		if(!str || !length(str))
			to_chat(user, SPAN_WARNING("Invalid text!"))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off [src]."))

/obj/item/hand_labeler/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/hand_labeler_refill))
		to_chat(user, SPAN_NOTICE("You insert [I] into [src]."))
		qdel(I)
		labels_left = initial(labels_left) //Yes, it's capped at its initial value

/obj/item/hand_labeler_refill
	name = "hand labeler paper roll"
	icon = 'icons/obj/bureaucracy.dmi'
	desc = "A roll of paper. Use it on a hand labeler to refill it."
	icon_state = "labeler_refill"
	inhand_icon_state = "electropack"
	inhand_icon = 'icons/obj/objects.dmi'
	w_class = WEIGHT_CLASS_TINY
