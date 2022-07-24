/// Attempts to perform recipes with the passed arguments.
/proc/perform_recipes(appliance, atom/source, list/atoms, list/conditions, list/return_list)
	// Recipe list which is already sorted while building the global list.
	var/list/recipe_list = GLOB.appliance_recipes[appliance]
	for(var/datum/recipe/recipe as anything in recipe_list)
		if(recipe.try_perform(source, atoms, conditions, return_list))
			// Remove used up atoms.
			for(var/atom/movable/check_atom as anything in atoms)
				if(QDELETED(check_atom))
					atoms -= check_atom
			. = TRUE

/// Shortcut proc.
/proc/perform_recipe(recipe_type, atom/source, list/atoms, list/conditions, list/return_list)
	var/datum/recipe/recipe = GLOB.recipes[recipe_type]
	if(recipe.try_perform(source, atoms, conditions, return_list))
		return TRUE
	return FALSE

/proc/get_available_recipes(appliance, atom/source, list/atoms, list/conditions)
	// Recipe list which is already sorted while building the global list.
	var/list/recipe_list = GLOB.appliance_recipes[appliance]
	var/list/available_recipe_types = list()
	for(var/datum/recipe/recipe as anything in recipe_list)
		if(recipe.check_perform(source, atoms, conditions))
			available_recipe_types += recipe.type
	return available_recipe_types

/proc/is_available_recipe(recipe_type, atom/source, list/atoms, list/conditions)
	var/datum/recipe/recipe = GLOB.recipes[recipe_type]
	if(recipe.check_perform(source, atoms, conditions))
		return TRUE
	return FALSE
