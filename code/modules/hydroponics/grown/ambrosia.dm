// Ambrosia - base type
/obj/item/food/grown/ambrosia
	seed = /obj/item/seeds/ambrosia
	name = "ambrosia branch"
	desc = "This is a plant."
	icon_state = "ambrosiavulgaris"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	tastes = list("ambrosia" = 1)

// Ambrosia Vulgaris
/obj/item/seeds/ambrosia
	name = "pack of ambrosia vulgaris seeds"
	desc = "These seeds grow into common ambrosia, a plant grown by and from medicine."
	icon_state = "seed-ambrosiavulgaris"
	species = "ambrosiavulgaris"
	plantname = "Ambrosia Vulgaris"
	product = /obj/item/food/grown/ambrosia/vulgaris
	lifespan = 60
	endurance = 25
	yield = 6
	potency = 5
	instability = 30
	icon_dead = "ambrosia-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/medicine/c2/aiuri = 0.1, /datum/reagent/medicine/c2/libital = 0.1 ,/datum/reagent/drug/space_drugs = 0.15, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/toxin = 0.1)

/obj/item/food/grown/ambrosia/vulgaris
	seed = /obj/item/seeds/ambrosia
	name = "ambrosia vulgaris branch"
	desc = "This is a plant containing various healing chemicals."
	wine_power = 30
