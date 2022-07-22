/obj/structure/campfire
	name = "campfire"
	desc = "A campfire."
	icon = 'icons/obj/structures/campfire.dmi'
	icon_state = "campfire"
	base_icon_state = "campfire"
	density = FALSE
	anchored = TRUE
	var/lit = FALSE
	var/fuel_remaining = 0 MINUTES
	var/starts_full = FALSE
	var/starts_ignited = FALSE

/obj/structure/campfire/get_temperature()
	return lit

/obj/structure/campfire/Initialize()
	. = ..()
	if(starts_full)
		fuel_remaining = 40 MINUTES
	if(starts_ignited)
		set_lit_state(TRUE)
	update_appearance()

/obj/structure/campfire/update_icon_state()
	. = ..()
	if(lit)
		icon_state = "[base_icon_state]_fire"
	else if (fuel_remaining > 0)
		icon_state = "[base_icon_state]_full"
	else
		icon_state = base_icon_state

/obj/structure/campfire/attackby(obj/item/item, mob/living/user, params)
	if(can_ignite(item))
		user.visible_message(
			SPAN_NOTICE("[user] lights \the [src] with \the [item]."),
			SPAN_NOTICE("You light \the [src] with \the [item].")
			)
		set_lit_state(TRUE)
		return TRUE
	return ..()

/obj/structure/campfire/proc/can_ignite(atom/item)
	return(!lit && item.get_temperature() && fuel_remaining > 0)

/obj/structure/campfire/proc/set_lit_state(new_state)
	if(lit == new_state)
		return
	lit = new_state
	if(lit)
		set_ambience(AMBIENCE_FIRE)
		set_light(4, 1.5)
		START_PROCESSING(SSobj, src)
	else
		set_ambience(null)
		set_light(0)
		STOP_PROCESSING(SSobj, src)
	update_appearance()

/obj/structure/campfire/process(delta_time)
	fuel_remaining -= delta_time
	if(fuel_remaining <= 0)
		set_lit_state(FALSE)

/obj/structure/campfire/full
	starts_full = TRUE

/obj/structure/campfire/full_ignited
	starts_full = TRUE
	starts_ignited = TRUE

// Braziers, which are dense and climbable campfires
/obj/structure/campfire/brazier
	name = "brazier"
	desc = "A brazier."
	icon = 'icons/obj/structures/brazier.dmi'
	icon_state = "brazier"
	base_icon_state = "brazier"
	density = TRUE
	anchored = TRUE

/obj/structure/campfire/brazier/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

/obj/structure/campfire/brazier/full
	starts_full = TRUE

/obj/structure/campfire/brazier/full_ignited
	starts_full = TRUE
	starts_ignited = TRUE
