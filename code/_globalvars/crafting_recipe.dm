GLOBAL_LIST_INIT(crafting_recipes, build_crafting_recipe_list())

/proc/build_crafting_recipe_list()
	var/list/recipe_list = list()
	for(var/type in typesof(/datum/crafting_recipe))
		if(is_abstract(type))
			continue
		recipe_list[type] = new type()
	return recipe_list
