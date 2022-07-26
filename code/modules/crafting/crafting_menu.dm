/datum/crafting_menu
	var/selected_craft_type = /datum/craft_type/personal
	var/selected_recipe

/datum/crafting_menu/proc/show_menu(mob/user, new_craft_type)
	if(!ishuman(user))
		return
	if(!isnull(new_craft_type))
		select_craft_type(new_craft_type)

	var/datum/craft_type/craft = CRAFT_TYPE(selected_craft_type)
	var/obj/structure/crafting_table/table
	var/needs_table = craft.needs_crafting_table
	if(needs_table)
		table = get_nearby_crafting_table(user, selected_craft_type)
	var/list/items = get_component_items(user, table, needs_table)
	
	var/list/dat = list()
	var/list/all_recipes = CRAFTING_RECIPES_BY_CRAFT(selected_craft_type)
	var/list/available_recipes = list()
	if(items)
		for(var/path in all_recipes)
			var/datum/crafting_recipe/table_recipe = CRAFTING_RECIPE(path)
			if(is_available_recipe(table_recipe.recipe_type, src, items))
				available_recipes += path

	for(var/iterated_type in GLOB.craft_types)
		var/datum/craft_type/iterated_craft = CRAFT_TYPE(iterated_type)
		var/button_class
		if(iterated_type == selected_craft_type)
			button_class = "class='linkOn'"

		dat += "<a href='?src=[REF(src)];action=set_craft_type;path=[iterated_type]' [button_class]>[iterated_craft.name]</a>"

	dat += "<hr><center><i>[craft.desc]</i></center><hr>"

	dat += "<div class='row' style='width:100%;height:100%;'>"

	// The crafting recipe buttons
	dat += "<div class='column' style='width:30%;'>"
	var/first = TRUE
	for(var/path in all_recipes)
		var/datum/crafting_recipe/table_recipe = CRAFTING_RECIPE(path)
		var/button_class
		if(path == selected_recipe)
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
	if(selected_recipe)
		var/datum/crafting_recipe/table_recipe = CRAFTING_RECIPE(selected_recipe)
		dat += "<center><b><font size='3'>[table_recipe.name]</font></b></center>"
		dat += "<br>[table_recipe.desc]"
		dat += "<br><br>Requirements:<br>[table_recipe.requirements]"
		var/button_class
		if(!(selected_recipe in available_recipes))
			button_class = "class='linkOff'"
		dat += "<br><center><a href='?src=[REF(src)];action=craft_recipe;path=[selected_recipe]' [button_class]><font size='3'>Craft</font></a></center>"
	dat += "</div>"

	dat += "</div>"

	var/datum/browser/popup = new(user, "crafting_menu", "crafting menu", 600, 700)
	popup.add_stylesheet("admin_panelscss", 'html/admin/admin_panels.css')
	popup.set_content(dat.Join())
	popup.open()


/datum/crafting_menu/proc/select_craft_type(new_craft_type)
	if(selected_craft_type == new_craft_type)
		return
	selected_craft_type = new_craft_type
	selected_recipe = null

/datum/crafting_menu/Topic(href, href_list)
	. = ..()
	var/mob/user = usr
	if(!ishuman(user))
		return
	/*
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	*/
	if(href_list["action"])
		switch(href_list["action"])
			if("set_recipe")
				var/recipe_path = text2path(href_list["path"])
				if(!recipe_path)
					return
				selected_recipe = recipe_path
			if("set_craft_type")
				var/craft_type_path = text2path(href_list["path"])
				if(!craft_type_path)
					return
				select_craft_type(craft_type_path)
			if("craft_recipe")
				var/recipe_path = text2path(href_list["path"])
				if(!recipe_path)
					return
				user_try_craft_recipe(user, recipe_path)
				return

		show_menu(user)

/datum/crafting_menu/proc/user_try_craft_recipe(mob/living/user, crafting_recipe_path)
	var/datum/crafting_recipe/table_recipe = CRAFTING_RECIPE(crafting_recipe_path)
	var/recipe_type = table_recipe.recipe_type
	var/datum/craft_type/craft = CRAFT_TYPE(table_recipe.craft_type)
	var/obj/structure/crafting_table/table
	var/needs_table = craft.needs_crafting_table
	if(needs_table)
		table = get_nearby_crafting_table(user, table_recipe.craft_type)
		if(!table)
			to_chat(user, SPAN_WARNING("You need a crafting table nearby!"))
			return
		user.face_atom(table)
	var/list/items = get_component_items(user, table, needs_table)
	var/atom/movable/craft_source = table || user

	if(!is_available_recipe(recipe_type, craft_source, items))
		to_chat(user, SPAN_WARNING("You don't have all the components for this!"))
		return
	items = null
	if(!do_after(user, 2 SECONDS, target = craft_source))
		return
	items = get_component_items(user, table, needs_table)
	if(!perform_recipe(recipe_type, craft_source, items))
		to_chat(user, SPAN_WARNING("You don't have all the components for this!"))
		return
	to_chat(user, SPAN_NOTICE("You successfully craft \the [table_recipe.name]."))
	show_menu(user)

/datum/crafting_menu/proc/get_nearby_crafting_table(mob/living/user, craft_type)
	for(var/obj/structure/crafting_table/table in oview(1, user))
		if(table.craft_type == craft_type)
			return table
	return null

/datum/crafting_menu/proc/get_component_items(mob/living/user, obj/structure/crafting_table/table, table_recipe)
	if(table_recipe)
		if(!table)
			return null
		if(table)
			return table.loc.contents
	else
		var/list/component_items = oview(1, user)
		component_items += user.get_held_items()
		return component_items
