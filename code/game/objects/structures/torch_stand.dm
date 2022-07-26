/obj/structure/torch_stand
	name = "torch stand"
	desc = "A torch stand."
	icon = 'icons/obj/structures/torch_stand.dmi'
	icon_state = "torch_stand"
	base_icon_state = "torch_stand"
	density = FALSE
	anchored = TRUE
	var/obj/item/torch/torch = null
	var/start_with_torch = FALSE
	var/started_torch_on = FALSE

/obj/structure/torch_stand/update_overlays()
	. = ..()
	if(torch)
		if(torch.lit)
			. += mutable_appearance(icon, "[base_icon_state]_torch_lit")
		else
			. += mutable_appearance(icon, "[base_icon_state]_torch")

/obj/structure/torch_stand/Exited(atom/movable/gone, direction)
	if(gone == torch)
		remove_torch()
	return ..()

/obj/structure/torch_stand/Initialize(mapload)
	. = ..()
	if(start_with_torch)
		var/obj/item/torch/stick = new /obj/item/torch()
		add_torch(stick)
	if(started_torch_on && torch)
		torch.set_lit_state(TRUE)

/obj/structure/torch_stand/Destroy()
	if(torch)
		qdel(torch)
	return ..()

/obj/structure/torch_stand/attackby(obj/item/item, mob/living/user, params)
	if(!torch && istype(item, /obj/item/torch))
		var/obj/item/torch/stick = item
		user.visible_message(
			SPAN_NOTICE("[user] put \the [stick] in \the [src]."),
			SPAN_NOTICE("You put \the [stick] in \the [src].")
			)
		add_torch(stick)
		return TRUE
	if(torch && item.get_temperature())
		return torch.attackby(item, user, params)
	return ..()

/obj/structure/torch_stand/attack_hand(mob/user, list/modifiers)
	if(torch)
		var/obj/item/torch/stick = torch
		user.visible_message(
			SPAN_NOTICE("[user] removes \the [stick] from \the [src]."),
			SPAN_NOTICE("You remove \the [stick] from \the [src].")
			)
		remove_torch()
		stick.forceMove(loc)
		user.put_in_hands(stick)
		return TRUE
	return ..()

/obj/structure/torch_stand/proc/add_torch(obj/item/torch/stick)
	if(torch != null)
		return
	torch = stick
	torch.forceMove(src)
	torch.stand = src
	update_torch()

/obj/structure/torch_stand/proc/remove_torch()
	torch.stand = null
	torch = null
	update_torch()

/obj/structure/torch_stand/proc/update_torch()
	update_appearance()

/obj/structure/torch_stand/torch
	start_with_torch = TRUE

/obj/structure/torch_stand/torch_on
	start_with_torch = TRUE
	started_torch_on = TRUE

/obj/structure/torch_stand/directional
	icon_state = "torch_sttand_dir"
	base_icon_state = "torch_stand_dir"

/obj/structure/torch_stand/directional/south
	dir = SOUTH

/obj/structure/torch_stand/directional/south/torch
	start_with_torch = TRUE

/obj/structure/torch_stand/directional/south/torch_on
	start_with_torch = TRUE
	started_torch_on = TRUE

/obj/structure/torch_stand/directional/north
	dir = NORTH

/obj/structure/torch_stand/directional/north/torch
	start_with_torch = TRUE

/obj/structure/torch_stand/directional/north/torch_on
	start_with_torch = TRUE
	started_torch_on = TRUE

/obj/structure/torch_stand/directional/west
	dir = WEST

/obj/structure/torch_stand/directional/west/torch
	start_with_torch = TRUE

/obj/structure/torch_stand/directional/west/torch_on
	start_with_torch = TRUE
	started_torch_on = TRUE

/obj/structure/torch_stand/directional/east
	dir = EAST

/obj/structure/torch_stand/directional/east/torch
	start_with_torch = TRUE

/obj/structure/torch_stand/directional/east/torch_on
	start_with_torch = TRUE
	started_torch_on = TRUE
