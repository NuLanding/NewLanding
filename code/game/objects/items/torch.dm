/obj/item/torch
	name = "torch"
	desc = "A branch wrapped with some cloth and smeared with some resin."
	icon = 'icons/obj/items/torch.dmi'
	icon_state = "torch"
	base_icon_state = "torch"
	w_class = WEIGHT_CLASS_NORMAL
	light_color = LIGHT_COLOR_ORANGE
	var/force_off = 5
	var/force_on = 9
	var/lit = FALSE
	var/fuel_remaining = 20 MINUTES
	var/obj/structure/torch_stand/stand

/obj/item/torch/Moved(atom/OldLoc, Dir)
	. = ..()
	if(stand && loc != stand)
		stand.remove_torch()

/obj/item/torch/Destroy()
	set_lit_state(FALSE)
	return ..()

/obj/item/torch/update_icon_state()
	. = ..()
	if(fuel_remaining <= 0)
		icon_state = "[base_icon_state]_empty"
	else if(lit)
		icon_state = "[base_icon_state]_on"
	else
		icon_state = base_icon_state

/obj/item/torch/get_temperature()
	return lit

/obj/item/torch/pre_attack(atom/attacked, mob/living/user, params)
	if(can_ignite(attacked))
		user.visible_message(
			SPAN_NOTICE("[user] lights \the [src] with \the [attacked]."),
			SPAN_NOTICE("You light \the [src] with \the [attacked].")
			)
		set_lit_state(TRUE)
		return TRUE
	return ..()

/obj/item/torch/attackby(obj/item/item, mob/living/user, params)
	if(can_ignite(item))
		user.visible_message(
			SPAN_NOTICE("[user] lights \the [src] with \the [item]."),
			SPAN_NOTICE("You light \the [src] with \the [item].")
			)
		set_lit_state(TRUE)
		return TRUE
	return ..()

/obj/item/torch/proc/can_ignite(atom/item)
	return(!lit && item.get_temperature() && fuel_remaining > 0)

/obj/item/torch/proc/set_lit_state(new_state)
	if(lit == new_state)
		return
	lit = new_state
	if(lit)
		force = force_on
		damtype = BURN
		set_light(4, 1.5)
		START_PROCESSING(SSobj, src)
	else
		force = force_off
		damtype = BRUTE
		set_light(0)
		STOP_PROCESSING(SSobj, src)
	update_appearance()
	if(stand)
		stand.update_torch()

/obj/item/torch/process(delta_time)
	fuel_remaining -= delta_time
	if(fuel_remaining <= 0)
		set_lit_state(FALSE)
