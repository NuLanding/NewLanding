GLOBAL_LIST_INIT(crafting_table_recipes, build_table_recipe_list())

/proc/build_table_recipe_list()
	var/list/recipe_list = list()
	for(var/type in typesof(/datum/crafting_table_recipe))
		if(is_abstract(type))
			continue
		recipe_list[type] = new type()
	return recipe_list
