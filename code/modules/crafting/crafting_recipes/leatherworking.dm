/datum/crafting_recipe/commoners_clothes
	name = "commoner's outfit"
	desc = "An ordinary shirt and a pair of leather pants."
	requirements = "2x leather"
	recipe_type = /datum/recipe/commoners_clothes
	craft_type = /datum/craft_type/crafting_table

/datum/recipe/commoners_clothes
	recipe_components = list(
		/datum/recipe_component/item/stack/leather_two
		)
	recipe_result = /datum/recipe_result/item/commoners_clothes

/datum/recipe_component/item/stack/leather_two
	types = list(/obj/item/stack/sheet/leather)
	stack_amount = 2

/datum/recipe_result/item/commoners_clothes
	item_type = /obj/item/clothing/under/commoner
