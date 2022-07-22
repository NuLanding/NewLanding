/obj/item/firestarter
	abstract_type = /obj/item/firestarter
	icon = 'icons/obj/items/firestarter.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/firestart_time = 8 SECONDS

/obj/item/firestarter/pre_attack(atom/attacked, mob/living/user, params)
	user.visible_message(
		SPAN_NOTICE("[user] starts sparking \the [attacked] with \the [src]."),
		SPAN_NOTICE("You start sparking \the [attacked] with \the [src].")
		)
	if(!do_after(user, firestart_time, target = attacked))
		return TRUE
	heat = TRUE
	return ..()

/obj/item/firestarter/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	heat = FALSE

/obj/item/firestarter/wood
	name = "firestater sticks"
	desc = "Sticks aligned in a way to create some sparks with some work."
	icon_state = "wood"
	firestart_time = 8 SECONDS

/obj/item/firestarter/stone
	name = "firestater stones"
	desc = "Stones aligned in a way to create some sparks with some work."
	icon_state = "stone"
	firestart_time = 8 SECONDS

/obj/item/firestarter/flint_and_steel
	name = "flint and steel"
	desc = "Strike the steel with some flint and become a firestarter."
	icon_state = "steel"
	firestart_time = 2 SECONDS
