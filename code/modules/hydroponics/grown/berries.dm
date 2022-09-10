// Berries
/obj/item/seeds/berries
	name = "seeds"
	desc = "These seeds are brown and have round and oblong shapes, and resemble small pebbles."
	icon_state = "seed-blueberry"
	species = "berry"
	plantname = "Berry Bush"
	product = /obj/item/food/grown/berries
	lifespan = 20
	maturation = 5
	production = 5
	yield = 2
	instability = 30
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "berry-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "berry-dead" // Same for the dead icon
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

// Blueberries

/obj/item/food/grown/berries
	seed = /obj/item/seeds/berries
	name = "berries"
	desc = "Pea sized round berries that range from blue to purple. They appear to have some kind of powdery coat around them."
	icon_state = "blueberry"
	gender = PLURAL
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/berryjuice = 0)
	tastes = list("berry" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/gin

// Elder Berries

/obj/item/seeds/berries/elder
	name = "seeds"
	desc = "These pebble sized seeds have a tapered almond shape and have a light indigo shade to them."
	icon_state = "seed-elder"
	product = /obj/item/food/grown/berries/elder
	reagents_add = list(/datum/reagent/toxin/staminatoxin = 0.8, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/berries/elder
	seed = /obj/item/seeds/berries/elder
	name = "berries"
	desc = "Dark purple-blue berries that resemble small grapes, that are almost perfectly round."
	icon_state = "elder"

// Myrtle Berries

/obj/item/seeds/berries/myrtle
	name = "seeds"
	desc = "Tiny brown half-circle crescent like seeds that appear to have come from a pod."
	icon_state = "seed-myrtle"
	product = /obj/item/food/grown/berries/myrtle
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/nutriment = 0.4)

/obj/item/food/grown/berries/myrtle
	seed = /obj/item/seeds/berries/myrtle
	name = "berries"
	desc = "Dusty looking oblong shaped berries with small protrusions of filament where they were detached from."
	icon_state = "myrtle"
	gender = PLURAL
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/berryjuice = 0)
	tastes = list("berry" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/gin

// Raspberry

/obj/item/seeds/berries/raspberry
	name = "seeds"
	desc = "These pebble sized seeds have a tapered almond shape and have a light indigo shade to them."
	icon_state = "seed-raspberry"
	product = /obj/item/food/grown/berries/raspberry

/obj/item/food/grown/berries/raspberry
	seed = /obj/item/seeds/berries/raspberry
	name = "berries"
	desc = "Dark purple-blue berries that resemble small grapes, that are almost perfectly round."
	icon_state = "raspberry"

// Strawberry

/obj/item/seeds/berries/strawberry
	name = "seeds"
	desc = "These pebble sized seeds have a tapered almond shape and have a light indigo shade to them."
	icon_state = "seed-strawberry"
	product = /obj/item/food/grown/berries/strawberry

/obj/item/food/grown/berries/strawberry
	seed = /obj/item/seeds/berries/strawberry
	name = "berries"
	desc = "Dark purple-blue berries that resemble small grapes, that are almost perfectly round."
	icon_state = "strawberry"


// Red Currant

/obj/item/seeds/berries/redcurrant
	name = "seeds"
	desc = "These pebble sized seeds have a tapered almond shape and have a light indigo shade to them."
	icon_state = "seed-redcurrant"
	product = /obj/item/food/grown/berries/redcurrant

/obj/item/food/grown/berries/redcurrant
	seed = /obj/item/seeds/berries/redcurrant
	name = "berries"
	desc = "Dark purple-blue berries that resemble small grapes, that are almost perfectly round."
	icon_state = "redcurrant"

// Pokeberry
/obj/item/seeds/berries/pokeberry
	name = "pack of pokeberry seeds"
	desc = "These seeds grow into death berries."
	icon_state = "seed-pokeberry"
	species = "pokeberry"
	product = /obj/item/food/grown/berries/pokeberry
	reagents_add = list(/datum/reagent/toxin/coniine = 0.08, /datum/reagent/toxin/staminatoxin = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/berries/pokeberry
	seed = /obj/item/seeds/berries/pokeberry
	name = "pokeberry"
	desc = "Taste so good, you will die!"
	icon_state = "pokeberry"
	bite_consumption_mod = 3
	foodtypes = FRUIT | TOXIC
	tastes = list("death" = 1)
	distill_reagent = null
	wine_power = 50

// Cherries
/obj/item/seeds/cherry
	name = "pack of cherry pits"
	desc = "Careful not to crack a tooth on one... That'd be the pits."
	icon_state = "seed-cherry"
	species = "cherry"
	plantname = "Cherry Tree"
	product = /obj/item/food/grown/cherries
	lifespan = 35
	endurance = 35
	maturation = 5
	production = 5
	growthstages = 5
	instability = 15
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "cherry-grow"
	icon_dead = "cherry-dead"
	icon_harvest = "cherry-harvest"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/cherry/blue)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07)

/obj/item/food/grown/cherries
	seed = /obj/item/seeds/cherry
	name = "cherries"
	desc = "Great for toppings!"
	icon_state = "cherry"
	gender = PLURAL
	bite_consumption_mod = 2
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/cherryjelly = 0)
	tastes = list("cherry" = 1)
	wine_power = 30

// Blue Cherries
/obj/item/seeds/cherry/blue
	name = "pack of blue cherry pits"
	desc = "The blue kind of cherries."
	icon_state = "seed-bluecherry"
	species = "bluecherry"
	plantname = "Blue Cherry Tree"
	product = /obj/item/food/grown/bluecherries
	mutatelist = list()
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.07, /datum/reagent/consumable/sugar = 0.07, /datum/reagent/oxygen = 0.07)
	rarity = 10

/obj/item/food/grown/bluecherries
	seed = /obj/item/seeds/cherry/blue
	name = "blue cherries"
	desc = "They're cherries that are blue."
	icon_state = "bluecherry"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	grind_results = list(/datum/reagent/consumable/bluecherryjelly = 0)
	tastes = list("blue cherry" = 1)
	wine_power = 50

// Grapes
/obj/item/seeds/grape
	name = "pack of grape seeds"
	desc = "These seeds grow into grape vines."
	icon_state = "seed-grapes"
	species = "grape"
	plantname = "Grape Vine"
	product = /obj/item/food/grown/grapes
	lifespan = 50
	endurance = 25
	maturation = 3
	production = 5
	yield = 4
	growthstages = 2
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "grape-grow"
	icon_dead = "grape-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/grape/green)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.1)

/obj/item/food/grown/grapes
	seed = /obj/item/seeds/grape
	name = "bunch of grapes"
	desc = "Nutritious!"
	icon_state = "grapes"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/grapejuice = 0)
	tastes = list("grape" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/wine

// Green Grapes
/obj/item/seeds/grape/green
	name = "pack of green grape seeds"
	desc = "These seeds grow into green-grape vines."
	icon_state = "seed-greengrapes"
	species = "greengrape"
	plantname = "Green-Grape Vine"
	product = /obj/item/food/grown/grapes/green
	reagents_add = list( /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/consumable/sugar = 0.1, /datum/reagent/medicine/c2/aiuri = 0.2)

/obj/item/food/grown/grapes/green
	seed = /obj/item/seeds/grape/green
	name = "bunch of green grapes"
	icon_state = "greengrapes"
	bite_consumption_mod = 3
	tastes = list("green grape" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/cognac
