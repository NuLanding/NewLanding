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

/obj/structure/crafting_table/attack_hand(mob/living/user, list/modifiers)
	if(user.combat_mode)
		return ..()
	show_ui(user)
	return

/obj/structure/crafting_table/attackby(obj/item/item, mob/living/user, params)
	if(user.combat_mode)
		return ..()
	var/list/modifiers = params2list(params)
	user.transferItemToLoc(item, loc, silent = FALSE, user_click_modifiers = modifiers)
	return TRUE

/obj/structure/crafting_table/proc/show_ui(mob/user)
	var/list/dat = list()
	var/list/items = loc.contents
	var/list/all_recipes = GLOB.crafting_table_recipes
	var/list/available_recipes = list()
	for(var/path in all_recipes)
		var/datum/crafting_table_recipe/table_recipe = CRAFTING_TABLE_RECIPE(path)
		if(is_available_recipe(table_recipe.recipe_type, src, items))
			available_recipes += path

	dat += "<div class='row' style='width:100%;height:100%;'>"

	// The crafting recipe buttons
	dat += "<div class='column' style='width:30%;'>"
	var/first = TRUE
	for(var/path in all_recipes)
		var/datum/crafting_table_recipe/table_recipe = CRAFTING_TABLE_RECIPE(path)
		var/button_class
		if(path == chosen_recipe)
			button_class = "class='linkOn'"
		else if (!(path in available_recipes))
			button_class = "class='linkOff'"
		if(!first)
			dat += "<br>"
		dat += "<a href='?src=[REF(src)];action=set_recipe;path=[path]' [button_class]>[table_recipe.name]</a>"
		first = FALSE

	dat += "</div>"

	// The panel of the selected recipe
	dat += "<div class='column' style='width:70%;background-color:#241f18'>"
	if(chosen_recipe)
		var/datum/crafting_table_recipe/table_recipe = CRAFTING_TABLE_RECIPE(chosen_recipe)
		dat += "<center><b>[table_recipe.name]</b></center>"
		dat += "<br>[table_recipe.desc]"
		dat += "<br><br>Requirements:<br>[table_recipe.requirements]"
		var/button_class
		if(!(chosen_recipe in available_recipes))
			button_class = "class='linkOff'"
		dat += "<br><center><a href='?src=[REF(src)];action=craft_recipe;path=[chosen_recipe]' [button_class]>Craft</a></center>"
	dat += "</div>"

	dat += "</div>"

	var/datum/browser/popup = new(user, "crafting_table", name, 600, 700)
	popup.add_stylesheet("admin_panelscss", 'html/admin/admin_panels.css')
	popup.set_content(dat.Join())
	popup.open()

/obj/structure/crafting_table/Topic(href, href_list)
	. = ..()
	var/mob/user = usr
	if(href_list["action"])
		switch(href_list["action"])
			if("set_recipe")
				var/recipe_path = text2path(href_list["path"])
				if(!recipe_path)
					return
				chosen_recipe = recipe_path
			if("craft_recipe")
				var/recipe_path = text2path(href_list["path"])
				if(!recipe_path)
					return
				user_try_craft_recipe(user, recipe_path)
				return

		show_ui(user)

/obj/structure/crafting_table/proc/user_try_craft_recipe(mob/living/user, crafting_table_recipe_path)
	var/datum/crafting_table_recipe/table_recipe = CRAFTING_TABLE_RECIPE(crafting_table_recipe_path)
	var/recipe_type = table_recipe.recipe_type
	var/list/items = loc.contents
	if(!is_available_recipe(recipe_type, src, items))
		to_chat(user, SPAN_WARNING("You don't have all the components for this!"))
		return
	items = null
	if(!do_after(user, 2 SECONDS, target = src))
		return
	items = loc.contents
	if(!perform_recipe(recipe_type, src, items))
		to_chat(user, SPAN_WARNING("You don't have all the components for this!"))
		return
	to_chat(user, SPAN_NOTICE("You successfully craft \the [table_recipe.name]."))
	show_ui(user)
