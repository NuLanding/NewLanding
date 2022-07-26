/datum/crafting_recipe
	abstract_type = /datum/crafting_recipe
	/// Name of the recipe
	var/name
	/// Description of the recipe
	var/desc
	/// Requirements of the recipe as a string.
	var/requirements
	/// Type of the /datum/recipe this crafting table recipe will try and perform.
	var/recipe_type
	/// Type of the craft this crafting recipe is performed as.
	var/craft_type = /datum/craft_type/personal
