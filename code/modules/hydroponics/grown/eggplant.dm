// Eggplant
/obj/item/seeds/eggplant
	name = "pack of eggplant seeds"
	desc = "These seeds grow to produce berries that look nothing like eggs."
	icon_state = "seed-eggplant"
	species = "eggplant"
	plantname = "Eggplants"
	product = /obj/item/food/grown/eggplant
	yield = 2
	potency = 20
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "eggplant-grow"
	icon_dead = "eggplant-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/eggplant
	seed = /obj/item/seeds/eggplant
	name = "eggplant"
	desc = "Maybe there's a chicken inside?"
	icon_state = "eggplant"
	foodtypes = FRUIT
	wine_power = 20
