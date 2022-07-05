/obj/item/stamp
	name = "\improper GRANTED rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-ok"
	inhand_icon_state = "stamp"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=60)
	attack_verb_continuous = list("stamps")
	attack_verb_simple = list("stamp")

/obj/item/stamp/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] stamps 'VOID' on [user.p_their()] forehead, then promptly falls over, dead."))
	return (OXYLOSS)

/obj/item/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"
	dye_color = DYE_REDCOAT

/obj/item/stamp/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)
