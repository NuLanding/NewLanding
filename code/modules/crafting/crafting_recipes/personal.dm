/datum/crafting_recipe/firestarter_sticks
	name = "firestarter sticks"
	desc = "Sticks capable of creating sparks by rubbing one against another."
	requirements = "1x log"
	recipe_type = /datum/recipe/firestarter_sticks
	craft_type = /datum/craft_type/personal

/datum/recipe/firestarter_sticks
	recipe_components = list(
		/datum/recipe_component/item/log
		)
	recipe_result = /datum/recipe_result/item/firestarter_sticks

/datum/recipe_component/item/log
	types = list(/obj/item/grown/log)

/datum/recipe_result/item/firestarter_sticks
	item_type = /obj/item/firestarter/wood
