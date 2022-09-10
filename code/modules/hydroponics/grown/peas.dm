// Finally, peas. Base plant.
/obj/item/seeds/peas
	name = "pack of pea pods"
	desc = "These seeds grows into vitamin rich peas!"
	icon_state = "seed-peas"
	species = "peas"
	plantname = "Pea Vines"
	product = /obj/item/food/grown/peas
	maturation = 3
	potency = 25
	instability = 15
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "peas-grow"
	icon_dead = "peas-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list (/datum/reagent/consumable/nutriment/vitamin = 0.1, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/water = 0.05)

/obj/item/food/grown/peas
	seed = /obj/item/seeds/peas
	name = "peapod"
	desc = "Finally... peas."
	icon_state = "peas"
	foodtypes = VEGETABLES
	tastes = list ("peas" = 1, "chalky saltiness" = 1)
	wine_power = 50
	wine_flavor = "what is, distressingly, fermented peas."
