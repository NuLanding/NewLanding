/datum/craft_type
	abstract_type = /datum/craft_type
	var/name
	var/desc
	var/needs_crafting_table = FALSE

/datum/craft_type/personal
	name = "Personal"
	desc = "Personal crafting you can perform with items in your hands or around you."

/datum/craft_type/crafting_table
	name = "Crafting Table"
	desc = "Craft items with components by placing them on a crafting table."
	needs_crafting_table = TRUE
