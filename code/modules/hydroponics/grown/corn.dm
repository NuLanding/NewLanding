// Corn
/obj/item/seeds/corn
	name = "pack of corn seeds"
	desc = "I don't mean to sound corny..."
	icon_state = "seed-corn"
	species = "corn"
	plantname = "Corn Stalks"
	product = /obj/item/food/grown/corn
	maturation = 8
	potency = 20
	instability = 50 //Corn used to be wheatgrass, before being cultivated for generations.
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "corn-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "corn-dead" // Same for the dead icon
	reagents_add = list(/datum/reagent/consumable/cornoil = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/corn
	seed = /obj/item/seeds/corn
	name = "ear of corn"
	desc = "Needs some butter!"
	icon_state = "corn"
	trash_type = /obj/item/grown/corncob
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/corn_starch = 0)
	tastes = list("corn" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/whiskey

/obj/item/grown/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon_state = "corncob"
	inhand_icon_state = "corncob"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	grind_results = list(/datum/reagent/cellulose = 10) //really partially hemicellulose
