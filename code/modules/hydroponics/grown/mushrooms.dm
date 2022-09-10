/obj/item/food/grown/mushroom
	name = "mushroom"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	wine_power = 40

// Reishi
/obj/item/seeds/whiteshroom
	name = "pack of whiteshroom"
	desc = "This mycelium grows into something medicinal and relaxing."
	icon_state = "whiteshroom"
	species = "whiteshroom"
	plantname = "whiteshroom"
	product = /obj/item/food/grown/mushroom/whiteshroom

/obj/item/food/grown/mushroom/whiteshroom
	seed = /obj/item/seeds/whiteshroom
	name = "whiteshroom"
	desc = "<I>Amanita Muscaria</I>: Learn poisonous mushrooms by heart. Only pick mushrooms you know."
	icon_state = "whiteshroom"

// Reishi
/obj/item/seeds/reishi
	name = "pack of reishi mycelium"
	desc = "This mycelium grows into something medicinal and relaxing."
	icon_state = "mycelium-reishi"
	species = "reishi"
	plantname = "Reishi"
	product = /obj/item/food/grown/mushroom/reishi
	lifespan = 35
	endurance = 35
	maturation = 10
	production = 5
	yield = 4
	potency = 15
	instability = 30
	growthstages = 4
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/medicine/morphine = 0.35, /datum/reagent/medicine/c2/multiver = 0.35, /datum/reagent/consumable/nutriment = 0)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/reishi
	seed = /obj/item/seeds/reishi
	name = "reishi"
	desc = "<I>Ganoderma lucidum</I>: A special fungus known for its medicinal and stress relieving properties."
	icon_state = "reishi"

// Fly Amanita
/obj/item/seeds/amanita
	name = "pack of fly amanita mycelium"
	desc = "This mycelium grows into something horrible."
	icon_state = "mycelium-amanita"
	species = "amanita"
	plantname = "Fly Amanitas"
	product = /obj/item/food/grown/mushroom/amanita
	lifespan = 50
	endurance = 35
	maturation = 10
	production = 5
	yield = 4
	instability = 30
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	mutatelist = list(/obj/item/seeds/angel)
	reagents_add = list(/datum/reagent/drug/mushroomhallucinogen = 0.04, /datum/reagent/toxin/amatoxin = 0.35, /datum/reagent/consumable/nutriment = 0, /datum/reagent/growthserum = 0.1)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/amanita
	seed = /obj/item/seeds/amanita
	name = "fly amanita"
	desc = "<I>Amanita Muscaria</I>: Learn poisonous mushrooms by heart. Only pick mushrooms you know."
	icon_state = "amanita"

// Destroying Angel
/obj/item/seeds/angel
	name = "pack of destroying angel mycelium"
	desc = "This mycelium grows into something devastating."
	icon_state = "mycelium-angel"
	species = "angel"
	plantname = "Destroying Angels"
	product = /obj/item/food/grown/mushroom/angel
	lifespan = 50
	endurance = 35
	maturation = 12
	production = 5
	yield = 2
	potency = 35
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/drug/mushroomhallucinogen = 0.04, /datum/reagent/toxin/amatoxin = 0.1, /datum/reagent/consumable/nutriment = 0, /datum/reagent/toxin/amanitin = 0.2)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/angel
	seed = /obj/item/seeds/angel
	name = "destroying angel"
	desc = "<I>Amanita Virosa</I>: Deadly poisonous basidiomycete fungus filled with alpha amatoxins."
	icon_state = "angel"
	wine_power = 60

// Liberty Cap
/obj/item/seeds/liberty
	name = "pack of liberty-cap mycelium"
	desc = "This mycelium grows into liberty-cap mushrooms."
	icon_state = "mycelium-liberty"
	species = "liberty"
	plantname = "Liberty-Caps"
	product = /obj/item/food/grown/mushroom/libertycap
	maturation = 7
	production = 1
	yield = 5
	potency = 15
	instability = 10
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/drug/mushroomhallucinogen = 0.25, /datum/reagent/consumable/nutriment = 0.02)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/libertycap
	seed = /obj/item/seeds/liberty
	name = "liberty-cap"
	desc = "<I>Psilocybe Semilanceata</I>: Liberate yourself!"
	icon_state = "libertycap"
	wine_power = 80

// Plump Helmet
/obj/item/seeds/plump
	name = "pack of plump-helmet mycelium"
	desc = "This mycelium grows into helmets... maybe."
	icon_state = "mycelium-plump"
	species = "plump"
	plantname = "Plump-Helmet Mushrooms"
	product = /obj/item/food/grown/mushroom/plumphelmet
	maturation = 8
	production = 1
	yield = 4
	potency = 15
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/plumphelmet
	seed = /obj/item/seeds/plump
	name = "plump-helmet"
	desc = "<I>Plumus Hellmus</I>: Plump, soft and s-so inviting~"
	icon_state = "plumphelmet"
	distill_reagent = /datum/reagent/consumable/ethanol/manly_dorf

// Chanterelle
/obj/item/seeds/chanter
	name = "pack of chanterelle mycelium"
	desc = "This mycelium grows into chanterelle mushrooms."
	icon_state = "mycelium-chanter"
	species = "chanter"
	plantname = "Chanterelle Mushrooms"
	product = /obj/item/food/grown/mushroom/chanterelle
	lifespan = 35
	endurance = 20
	maturation = 7
	production = 1
	yield = 5
	potency = 15
	instability = 20
	growthstages = 3
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism)
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/food/grown/mushroom/chanterelle
	seed = /obj/item/seeds/chanter
	name = "chanterelle cluster"
	desc = "<I>Cantharellus Cibarius</I>: These jolly yellow little shrooms sure look tasty!"
	icon_state = "chanterelle"
