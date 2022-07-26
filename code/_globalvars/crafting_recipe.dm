GLOBAL_LIST_EMPTY(crafting_recipes_by_craft)
GLOBAL_LIST_INIT(craft_types, build_craft_types_list())
GLOBAL_LIST_INIT(crafting_recipes, build_crafting_recipe_list())

/proc/build_crafting_recipe_list()
	var/list/recipe_list = list()
	for(var/type in typesof(/datum/crafting_recipe))
		if(is_abstract(type))
			continue
		var/datum/crafting_recipe/crafting_recipe = new type()
		recipe_list[type] = crafting_recipe
		if(crafting_recipe.craft_type)
			GLOB.crafting_recipes_by_craft[crafting_recipe.craft_type][type] = crafting_recipe
	return recipe_list

/proc/build_craft_types_list()
	var/list/craft_types_list = list()
	for(var/type in typesof(/datum/craft_type))
		if(is_abstract(type))
			continue
		craft_types_list[type] = new type()
		if(!GLOB.crafting_recipes_by_craft[type])
			GLOB.crafting_recipes_by_craft[type] = list()
	return craft_types_list
