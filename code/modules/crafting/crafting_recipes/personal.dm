/datum/crafting_recipe/firestarter_sticks
	name = "firestarter sticks"
	desc = "Sticks capable of creating sparks by rubbing one against another."
	requirements = "2x branch"
	recipe_type = /datum/recipe/firestarter_sticks
	craft_type = /datum/craft_type/personal

/datum/recipe/firestarter_sticks
	recipe_components = list(
		/datum/recipe_component/item/branch,
		/datum/recipe_component/item/branch,
		)
	recipe_result = /datum/recipe_result/item/firestarter_sticks

/datum/recipe_component/item/branch
	types = list(/obj/item/branch)

/datum/recipe_result/item/firestarter_sticks
	item_type = /obj/item/firestarter/wood

/datum/crafting_recipe/firestarter_stones
	name = "firestarter stones"
	desc = "Stones capable of creating sparks by rubbing one against another."
	requirements = "2x stones"
	recipe_type = /datum/recipe/firestarter_stones
	craft_type = /datum/craft_type/personal

/datum/recipe/firestarter_stones
	recipe_components = list(
		/datum/recipe_component/item/stone_two,
		)
	recipe_result = /datum/recipe_result/item/firestarter_stones

/datum/recipe_component/item/stone_two
	types = list(/obj/item/stone)
	min_amount = 2
	max_amount = 2

/datum/recipe_result/item/firestarter_stones
	item_type = /obj/item/firestarter/stone

/datum/crafting_recipe/flint_and_steel
	name = "flint and steel"
	desc = "Extremely efficient tool in settings things on fire by shaving the steel with the flint."
	requirements = "1x flint<br>1x steel"
	recipe_type = /datum/recipe/flint_and_steel
	craft_type = /datum/craft_type/personal

/datum/recipe/flint_and_steel
	recipe_components = list(
		/datum/recipe_component/item/flint,
		/datum/recipe_component/item/stack/steel_one,
		)
	recipe_result = /datum/recipe_result/item/flint_and_steel

/datum/recipe_component/item/flint
	types = list(/obj/item/flint)

/datum/recipe_component/item/stack/steel_one
	types = list(/obj/item/stack/sheet/steel)
	stack_amount = 1

/datum/recipe_result/item/flint_and_steel
	item_type = /obj/item/firestarter/flint_and_steel
