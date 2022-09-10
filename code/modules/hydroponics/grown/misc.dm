// Starthistle
/obj/item/seeds/starthistle
	name = "pack of starthistle seeds"
	desc = "A robust species of weed that often springs up in-between the cracks of spaceship parking lots."
	icon_state = "seed-starthistle"
	species = "starthistle"
	plantname = "Starthistle"
	lifespan = 70
	endurance = 50 // damm pesky weeds
	maturation = 5
	production = 1
	yield = 2
	potency = 10
	instability = 35
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/seeds/starthistle/harvest(mob/user)
	return

// Cabbage
/obj/item/seeds/cabbage
	name = "pack of cabbage seeds"
	desc = "These seeds grow into cabbages."
	icon_state = "seed-cabbage"
	species = "cabbage"
	plantname = "Cabbages"
	product = /obj/item/food/grown/cabbage
	lifespan = 50
	endurance = 25
	maturation = 3
	production = 5
	yield = 4
	instability = 10
	growthstages = 1
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	seed_flags = null

/obj/item/food/grown/cabbage
	seed = /obj/item/seeds/cabbage
	name = "cabbage"
	desc = "Ewwwwwwwwww. Cabbage."
	icon_state = "cabbage"
	foodtypes = VEGETABLES
	wine_power = 20

// Sugarcane
/obj/item/seeds/sugarcane
	name = "pack of sugarcane seeds"
	desc = "These seeds grow into sugarcane."
	icon_state = "seed-sugarcane"
	species = "sugarcane"
	plantname = "Sugarcane"
	product = /obj/item/food/grown/sugarcane
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 60
	endurance = 50
	maturation = 3
	yield = 4
	instability = 15
	growthstages = 2
	reagents_add = list(/datum/reagent/consumable/sugar = 0.25)
	mutatelist = list(/obj/item/seeds/bamboo)

/obj/item/food/grown/sugarcane
	seed = /obj/item/seeds/sugarcane
	name = "sugarcane"
	desc = "Sickly sweet."
	icon_state = "sugarcane"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | SUGAR
	distill_reagent = /datum/reagent/consumable/ethanol/rum

// aloe
/obj/item/seeds/aloe
	name = "pack of aloe seeds"
	desc = "These seeds grow into aloe."
	icon_state = "seed-aloe"
	species = "aloe"
	plantname = "Aloe"
	product = /obj/item/food/grown/aloe
	lifespan = 60
	endurance = 25
	maturation = 4
	production = 4
	yield = 6
	growthstages = 5
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/aloe
	seed = /obj/item/seeds/aloe
	name = "aloe"
	desc = "Cut leaves from the aloe plant."
	icon_state = "aloe"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/aloejuice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/tequila

/obj/item/seeds/shrub
	name = "pack of shrub seeds"
	desc = "These seeds grow into hedge shrubs."
	icon_state = "seed-shrub"
	species = "shrub"
	plantname = "Shrubbery"
	product = /obj/item/grown/shrub
	lifespan = 40
	endurance = 30
	maturation = 4
	production = 6
	yield = 2
	instability = 10
	growthstages = 3
	reagents_add = list()

/obj/item/grown/shrub
	seed = /obj/item/seeds/shrub
	name = "shrub"
	desc = "A shrubbery, it looks nice and it was only a few credits too. Plant it on the ground to grow a hedge, shrubbing skills not required."
	icon_state = "shrub"
