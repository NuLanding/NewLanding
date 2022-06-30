// Pumpkin
/obj/item/seeds/pumpkin
	name = "pack of pumpkin seeds"
	desc = "These seeds grow into pumpkin vines."
	icon_state = "seed-pumpkin"
	species = "pumpkin"
	plantname = "Pumpkin Vines"
	product = /obj/item/food/grown/pumpkin
	lifespan = 50
	endurance = 40
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "pumpkin-grow"
	icon_dead = "pumpkin-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/pumpkin/blumpkin)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.2)

/obj/item/food/grown/pumpkin
	seed = /obj/item/seeds/pumpkin
	name = "pumpkin"
	desc = "It's large and scary."
	icon_state = "pumpkin"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/pumpkinjuice = 0)
	wine_power = 20

// Blumpkin
/obj/item/seeds/pumpkin/blumpkin
	name = "pack of blumpkin seeds"
	desc = "These seeds grow into blumpkin vines."
	icon_state = "seed-blumpkin"
	species = "blumpkin"
	plantname = "Blumpkin Vines"
	product = /obj/item/food/grown/blumpkin
	mutatelist = list()
	reagents_add = list(/datum/reagent/ammonia = 0.2, /datum/reagent/chlorine = 0.1, /datum/reagent/consumable/nutriment = 0.2)
	rarity = 20

/obj/item/food/grown/blumpkin
	seed = /obj/item/seeds/pumpkin/blumpkin
	name = "blumpkin"
	desc = "The pumpkin's toxic sibling."
	icon_state = "blumpkin"
	bite_consumption_mod = 3
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/blumpkinjuice = 0)
	wine_power = 50
