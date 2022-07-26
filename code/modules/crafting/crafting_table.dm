/obj/structure/crafting_table
	name = "crafting table"
	desc = "A tidy table with lots of rooms for blueprints, tools and work."
	icon = 'icons/obj/structures/crafting_table.dmi'
	icon_state = "crafting_table"
	base_icon_state = "crafting_table"
	density = TRUE
	anchored = TRUE
	/// The craft type this table allows performing.
	var/craft_type = /datum/craft_type/crafting_table

/obj/structure/crafting_table/attack_hand(mob/living/user, list/modifiers)
	if(user.combat_mode)
		return ..()
	if(!user.client)
		return TRUE
	user.client.crafting_menu.show_menu(user, craft_type)
	return TRUE

/obj/structure/crafting_table/attackby(obj/item/item, mob/living/user, params)
	if(user.combat_mode)
		return ..()
	var/list/modifiers = params2list(params)
	user.transferItemToLoc(item, loc, silent = FALSE, user_click_modifiers = modifiers)
	return TRUE
