/obj/structure/crafting_table
	name = "crafting table"
	desc = "A tidy table with lots of rooms for blueprints, tools and work."
	icon = 'icons/obj/structures/crafting_table.dmi'
	icon_state = "crafting_table"
	base_icon_state = "crafting_table"
	density = TRUE
	anchored = TRUE
	// UI states
	var/chosen_recipe

/obj/structure/crafting_table/attack_hand(mob/user, list/modifiers)
	if(user.combat_mode)
		return ..()
	//Open UI here
	return

/obj/structure/crafting_table/attackby(obj/item/item, mob/living/user, params)
	if(user.combat_mode)
		return ..()
	user.transferItemToLoc(item, loc, silent = FALSE, user_click_modifiers = modifiers)
	return TRUE
