/obj/effect/spawner/lootdrop
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"
	layer = OBJ_LAYER
	var/lootcount = 1 //how many items will be spawned
	var/lootdoubles = TRUE //if the same item can be spawned twice
	var/list/loot //a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)
	var/fan_out_items = FALSE //Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself

/obj/effect/spawner/lootdrop/Initialize(mapload)
	..()
	if(loot?.len)
		var/loot_spawned = 0
		while((lootcount-loot_spawned) && loot.len)
			var/lootspawn = pickweight(fill_with_ones(loot))
			while(islist(lootspawn))
				lootspawn = pickweight(fill_with_ones(lootspawn))
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				var/atom/movable/spawned_loot = new lootspawn(loc)
				if (!fan_out_items)
					if (pixel_x != 0)
						spawned_loot.pixel_x = pixel_x
					if (pixel_y != 0)
						spawned_loot.pixel_y = pixel_y
				else
					if (loot_spawned)
						spawned_loot.pixel_x = spawned_loot.pixel_y = ((!(loot_spawned%2)*loot_spawned/2)*-1)+((loot_spawned%2)*(loot_spawned+1)/2*1)
			loot_spawned++
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/lootdrop/donkpockets
	name = "donk pocket box spawner"
	lootdoubles = FALSE

	loot = list(
			/obj/item/storage/box/donkpockets/donkpocketspicy = 1,
			/obj/item/storage/box/donkpockets/donkpocketteriyaki = 1,
			/obj/item/storage/box/donkpockets/donkpocketpizza = 1,
			/obj/item/storage/box/donkpockets/donkpocketberry = 1,
			/obj/item/storage/box/donkpockets/donkpockethonk = 1,
		)

/obj/effect/spawner/lootdrop/armory_contraband
	name = "armory contraband gun spawner"
	lootdoubles = FALSE

	loot = list(
				/obj/item/gun/ballistic/automatic/pistol = 8,
				/obj/item/gun/ballistic/shotgun/automatic/combat = 5,
				/obj/item/gun/ballistic/automatic/pistol/deagle,
				/obj/item/gun/ballistic/revolver/mateba
				)

/obj/effect/spawner/lootdrop/armory_contraband/metastation
	loot = list(/obj/item/gun/ballistic/automatic/pistol = 5,
				/obj/item/gun/ballistic/shotgun/automatic/combat = 5,
				/obj/item/gun/ballistic/automatic/pistol/deagle,
				/obj/item/gun/ballistic/revolver/mateba)

/obj/effect/spawner/lootdrop/armory_contraband/donutstation
	loot = list(/obj/item/grenade/clusterbuster/teargas = 5,
				/obj/item/gun/ballistic/shotgun/automatic/combat = 5,
				/obj/item/bikehorn/golden,
				/obj/item/grenade/clusterbuster,
				/obj/item/gun/ballistic/revolver/mateba)

/obj/effect/spawner/lootdrop/prison_contraband
	name = "prison contraband loot spawner"
	loot = list(/obj/item/clothing/mask/cigarette/space_cigarette = 4,
				/obj/item/clothing/mask/cigarette/robust = 2,
				/obj/item/clothing/mask/cigarette/carp = 3,
				/obj/item/clothing/mask/cigarette/uplift = 2,
				/obj/item/clothing/mask/cigarette/dromedary = 3,
				/obj/item/clothing/mask/cigarette/robustgold = 1,
				/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
				/obj/item/storage/fancy/cigarettes = 3,
				/obj/item/clothing/mask/cigarette/rollie/cannabis = 4,
				/obj/item/toy/crayon/spraycan = 2,
				/obj/item/restraints/handcuffs/cable/zipties = 1,
				/obj/item/restraints/handcuffs = 1,
				/obj/item/lighter = 3,
				/obj/item/storage/box/matches = 3,
				/obj/item/reagent_containers/syringe/contraband/space_drugs = 1,
				/obj/item/reagent_containers/syringe/contraband/krokodil = 1,
				/obj/item/reagent_containers/syringe/contraband/crank = 1,
				/obj/item/reagent_containers/syringe/contraband/methamphetamine = 1,
				/obj/item/reagent_containers/syringe/contraband/bath_salts = 1,
				/obj/item/reagent_containers/syringe/contraband/fentanyl = 1,
				/obj/item/reagent_containers/syringe/contraband/morphine = 1,
				/obj/item/storage/pill_bottle/happy = 1,
				/obj/item/storage/pill_bottle/lsd = 1,
				/obj/item/storage/pill_bottle/psicodine = 1,
				/obj/item/reagent_containers/food/drinks/beer = 4,
				/obj/item/reagent_containers/food/drinks/bottle/whiskey = 1,
				/obj/item/paper/fluff/jobs/prisoner/letter = 1,
				/obj/item/grenade/smokebomb = 1,
				/obj/item/flashlight/seclite = 1,
				/obj/item/tailclub = 1, //want to buy makeshift wooden club sprite
				/obj/item/kitchen/knife/shiv = 4,
				/obj/item/kitchen/knife/shiv/carrot = 1,
				/obj/item/kitchen/knife = 1,
				/obj/item/storage/wallet/random = 1,
				)

/obj/effect/spawner/lootdrop/gambling
	name = "gambling valuables spawner"
	loot = list(
				/obj/item/gun/ballistic/revolver/russian = 5,
				/obj/item/clothing/head/ushanka = 3,
				/obj/item/coin/gold,
				/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka,
				)

/obj/effect/spawner/lootdrop/garbage_spawner
	name = "garbage_spawner"
	loot = list(/obj/effect/spawner/lootdrop/food_packaging = 56,
				/obj/item/trash/can = 8,
				/obj/item/shard = 8,
				/obj/effect/spawner/lootdrop/botanical_waste = 8,
				/obj/effect/spawner/lootdrop/cigbutt = 8,
				/obj/item/reagent_containers/syringe = 5,
				/obj/item/food/deadmouse = 2,
				/obj/item/trash/candle = 1)

/obj/effect/spawner/lootdrop/cigbutt
	name = "cigarette butt spawner"
	loot = list(/obj/item/cigbutt = 65,
				/obj/item/cigbutt/roach = 20,
				/obj/item/cigbutt/cigarbutt = 15)

/obj/effect/spawner/lootdrop/food_packaging
	name = "food packaging spawner"
	loot = list(/obj/item/trash/raisins = 20,
				/obj/item/trash/cheesie = 10,
				/obj/item/trash/candy = 10,
				/obj/item/trash/chips = 10,
				/obj/item/trash/sosjerky = 10,
				/obj/item/trash/pistachios = 10,
				/obj/item/trash/boritos = 8,
				/obj/item/trash/can/food/beans = 6,
				/obj/item/trash/popcorn = 5,
				/obj/item/trash/energybar = 5,
				/obj/item/trash/can/food/peaches/maint = 4,
				/obj/item/trash/semki = 2)

/obj/effect/spawner/lootdrop/botanical_waste
	name = "botanical waste spawner"
	loot = list(/obj/item/grown/bananapeel = 60,
				/obj/item/grown/corncob = 30,
				/obj/item/food/grown/bungopit = 10)

/obj/effect/spawner/lootdrop/refreshing_beverage
	name = "good soda spawner"
	loot = list(/obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola = 15,
				/obj/item/reagent_containers/food/drinks/soda_cans/grey_bull = 15,
				/obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/thirteenloko = 10,
				/obj/item/reagent_containers/food/drinks/beer/light = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/sol_dry = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/cola = 5)

/obj/effect/spawner/lootdrop/maint_drugs
	name = "maint drugs spawner"
	loot = list(/obj/item/reagent_containers/food/drinks/bottle/hooch = 50,
				/obj/item/clothing/mask/cigarette/rollie/cannabis = 15,
				/obj/item/clothing/mask/cigarette/rollie/mindbreaker = 5,
				/obj/item/reagent_containers/syringe = 15,
				/obj/item/cigbutt/roach = 15)

/obj/effect/spawner/lootdrop/grille_or_trash
	name = "maint grille or trash spawner"
	loot = list(/obj/structure/grille = 5,
			/obj/item/cigbutt = 1,
			/obj/item/trash/cheesie = 1,
			/obj/item/trash/candy = 1,
			/obj/item/trash/chips = 1,
			/obj/item/food/deadmouse = 1,
			/obj/item/trash/pistachios = 1,
			/obj/item/trash/popcorn = 1,
			/obj/item/trash/raisins = 1,
			/obj/item/trash/sosjerky = 1,
			/obj/item/trash/syndi_cakes = 1)

/obj/effect/spawner/lootdrop/three_course_meal
	name = "three course meal spawner"
	lootcount = 3
	lootdoubles = FALSE
	var/soups = list(
			/obj/item/food/soup/beet,
			/obj/item/food/soup/sweetpotato,
			/obj/item/food/soup/stew,
			/obj/item/food/soup/hotchili,
			/obj/item/food/soup/nettle,
			/obj/item/food/soup/meatball)
	var/salads = list(
			/obj/item/food/salad/herbsalad,
			/obj/item/food/salad/validsalad,
			/obj/item/food/salad/fruit,
			/obj/item/food/salad/jungle,
			/obj/item/food/salad/aesirsalad)
	var/mains = list(
			/obj/item/food/bearsteak,
			/obj/item/food/enchiladas,
			/obj/item/food/stewedsoymeat,
			/obj/item/food/burger/bigbite,
			/obj/item/food/burger/superbite,
			/obj/item/food/burger/fivealarm)

/obj/effect/spawner/lootdrop/three_course_meal/Initialize(mapload)
	loot = list(pick(soups) = 1,pick(salads) = 1,pick(mains) = 1)
	. = ..()

/obj/effect/spawner/lootdrop/maintenance
	name = "maintenance loot spawner"
	// see code/_globalvars/lists/maintenance_loot.dm for loot table

/obj/effect/spawner/lootdrop/maintenance/Initialize(mapload)
	loot = GLOB.maintenance_loot

	if(HAS_TRAIT(SSstation, STATION_TRAIT_FILLED_MAINT))
		lootcount = FLOOR(lootcount * 1.5, 1)

	else if(HAS_TRAIT(SSstation, STATION_TRAIT_EMPTY_MAINT))
		lootcount = FLOOR(lootcount * 0.5, 1)

	. = ..()

/obj/effect/spawner/lootdrop/maintenance/two
	name = "2 x maintenance loot spawner"
	lootcount = 2

/obj/effect/spawner/lootdrop/maintenance/three
	name = "3 x maintenance loot spawner"
	lootcount = 3

/obj/effect/spawner/lootdrop/maintenance/four
	name = "4 x maintenance loot spawner"
	lootcount = 4

/obj/effect/spawner/lootdrop/maintenance/five
	name = "5 x maintenance loot spawner"
	lootcount = 5

/obj/effect/spawner/lootdrop/maintenance/six
	name = "6 x maintenance loot spawner"
	lootcount = 6

/obj/effect/spawner/lootdrop/maintenance/seven
	name = "7 x maintenance loot spawner"
	lootcount = 7

/obj/effect/spawner/lootdrop/maintenance/eight
	name = "8 x maintenance loot spawner"
	lootcount = 8

/obj/effect/spawner/lootdrop/memeorgans
	name = "meme organ spawner"
	loot = list(
		/obj/item/organ/ears/penguin,
		/obj/item/organ/ears/cat,
		/obj/item/organ/eyes/moth,
		/obj/item/organ/eyes/snail,
		/obj/item/organ/tongue/bone,
		/obj/item/organ/tongue/fly,
		/obj/item/organ/tongue/snail,
		/obj/item/organ/tongue/lizard,
		/obj/item/organ/tongue/robot,
		/obj/item/organ/tongue/zombie,
		/obj/item/organ/appendix,
		/obj/item/organ/liver/fly,
		/obj/item/organ/lungs/plasmaman,
		/obj/item/organ/tail/cat,
		/obj/item/organ/tail/lizard)
	lootcount = 5

/obj/effect/spawner/lootdrop/costume
	name = "random costume spawner"

/obj/effect/spawner/lootdrop/costume/Initialize()
	loot = list()
	for(var/path in subtypesof(/obj/effect/spawner/bundle/costume))
		loot[path] = TRUE
	. = ..()

// Minor lootdrops follow

/obj/effect/spawner/lootdrop/minor/beret_or_rabbitears
	name = "beret or rabbit ears spawner"
	loot = list(
		/obj/item/clothing/head/beret = 1,
		/obj/item/clothing/head/rabbitears = 1)

/obj/effect/spawner/lootdrop/minor/bowler_or_that
	name = "bowler or top hat spawner"
	loot = list(
		/obj/item/clothing/head/bowler = 1,
		/obj/item/clothing/head/that = 1)

/obj/effect/spawner/lootdrop/minor/kittyears_or_rabbitears
	name = "kitty ears or rabbit ears spawner"
	loot = list(
		/obj/item/clothing/head/kitty = 1,
		/obj/item/clothing/head/rabbitears = 1)

/obj/effect/spawner/lootdrop/minor/pirate_or_bandana
	name = "pirate hat or bandana spawner"
	loot = list(
		/obj/item/clothing/head/pirate = 1,
		/obj/item/clothing/head/bandana = 1)

/obj/effect/spawner/lootdrop/minor/twentyfive_percent_cyborg_mask
	name = "25% cyborg mask spawner"
	loot = list(
		/obj/item/clothing/mask/gas/cyborg = 25,
		"" = 75)

// Tech storage circuit board spawners

/obj/effect/spawner/lootdrop/mafia_outfit
	name = "mafia outfit spawner"
	loot = list(
				/obj/effect/spawner/bundle/costume/mafia = 20,
				/obj/effect/spawner/bundle/costume/mafia/white = 5,
				/obj/effect/spawner/bundle/costume/mafia/checkered = 2,
				/obj/effect/spawner/bundle/costume/mafia/beige = 5
				)

//finds the probabilities of items spawning from a loot spawner's loot pool
/obj/item/loot_table_maker
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"
	var/spawner_to_test = /obj/effect/spawner/lootdrop/maintenance //what lootdrop spawner to use the loot pool of
	var/loot_count = 180 //180 is about how much maint loot spawns per map as of 11/14/2019
	//result outputs
	var/list/spawned_table //list of all items "spawned" and how many
	var/list/stat_table //list of all items "spawned" and their occurrance probability

/obj/item/loot_table_maker/Initialize()
	. = ..()
	make_table()

/obj/item/loot_table_maker/attack_self(mob/user)
	to_chat(user, "Loot pool re-rolled.")
	make_table()

/obj/item/loot_table_maker/proc/make_table()
	spawned_table = list()
	stat_table = list()
	var/obj/effect/spawner/lootdrop/spawner_to_table = new spawner_to_test
	var/lootpool = spawner_to_table.loot
	qdel(spawner_to_table)
	for(var/i in 1 to loot_count)
		var/loot_spawn = pick_loot(lootpool)
		if(!(loot_spawn in spawned_table))
			spawned_table[loot_spawn] = 1
		else
			spawned_table[loot_spawn] += 1
	stat_table += spawned_table
	for(var/item in stat_table)
		stat_table[item] /= loot_count

/obj/item/loot_table_maker/proc/pick_loot(lootpool) //selects path from loot table and returns it
	var/lootspawn = pickweight(fill_with_ones(lootpool))
	while(islist(lootspawn))
		lootspawn = pickweight(fill_with_ones(lootspawn))
	return lootspawn

/obj/effect/spawner/lootdrop/space
	name = "generic space ruin loot spawner"
	lootcount = 1

/// Space loot spawner. Randomlu picks 5 wads of space cash.
/obj/effect/spawner/lootdrop/space/cashmoney
	lootcount = 5
	fan_out_items = TRUE
	loot = list(
		/obj/item/stack/spacecash/c1 = 100,
		/obj/item/stack/spacecash/c10 = 80,
		/obj/item/stack/spacecash/c20 = 60,
		/obj/item/stack/spacecash/c50 = 40,
		/obj/item/stack/spacecash/c100 = 30,
		/obj/item/stack/spacecash/c200 = 20,
		/obj/item/stack/spacecash/c500 = 10,
		/obj/item/stack/spacecash/c1000 = 5,
		/obj/item/stack/spacecash/c10000 = 1
	)

/// Mail loot spawner. Drop pool of advanced medical tools typically from research. Not endgame content.
/obj/effect/spawner/lootdrop/space/fancytool/advmedicalonly
	loot = list(
		/obj/item/scalpel/advanced = 1,
		/obj/item/retractor/advanced = 1,
		/obj/item/cautery/advanced = 1
	)

/// Space loot spawner. A bunch of rarer seeds. /obj/item/seeds/random is not a random seed, but an exotic seed.
/obj/effect/spawner/lootdrop/space/rareseed
	lootcount = 5
	loot = list(
		/obj/item/seeds/random = 30,
		/obj/item/seeds/angel = 1,
		/obj/item/seeds/glowshroom/glowcap = 1,
		/obj/item/seeds/glowshroom/shadowshroom = 1,
		/obj/item/seeds/liberty = 5,
		/obj/item/seeds/nettle/death = 1,
		/obj/item/seeds/plump/walkingmushroom = 1,
		/obj/item/seeds/reishi = 5,
		/obj/item/seeds/cannabis/rainbow = 1,
		/obj/item/seeds/cannabis/death = 1,
		/obj/item/seeds/cannabis/white = 1,
		/obj/item/seeds/cannabis/ultimate = 1,
		/obj/item/seeds/replicapod = 5,
		/obj/item/seeds/kudzu = 1
	)

/// Space loot spawner. A single roundstart species language book.
/obj/effect/spawner/lootdrop/space/languagebook
	lootcount = 1
	loot = list(
		/obj/item/language_manual/roundstart_species = 100,
		/obj/item/language_manual/roundstart_species/five = 3,
		/obj/item/language_manual/roundstart_species/unlimited = 1
	)

/// Space loot spawner. Random selecton of a few rarer materials.
/obj/effect/spawner/lootdrop/space/material
	lootcount = 3
	loot = list(
		/obj/item/stack/sheet/plastic/fifty = 5,
		/obj/item/stack/sheet/mineral/diamond{amount = 15} = 15,
		/obj/item/stack/sheet/mineral/uranium{amount = 15} = 15,
		/obj/item/stack/sheet/mineral/plasma{amount = 15} = 15,
		/obj/item/stack/sheet/mineral/gold{amount = 15} = 15,
	)

/// A selection of cosmetic syndicate items. Just a couple. No hardsuits or weapons.
/obj/effect/spawner/lootdrop/space/syndiecosmetic
	lootcount = 2
	loot = list(
		/obj/item/clothing/under/syndicate = 10,
		/obj/item/clothing/under/syndicate/skirt = 10,
		/obj/item/clothing/under/syndicate/bloodred = 10,
		/obj/item/clothing/under/syndicate/bloodred/sleepytime = 5,
		/obj/item/clothing/under/syndicate/tacticool = 10,
		/obj/item/clothing/under/syndicate/tacticool/skirt = 10,
		/obj/item/clothing/under/syndicate/sniper = 10,
		/obj/item/clothing/under/syndicate/camo = 10,
		/obj/item/clothing/under/syndicate/soviet = 10,
		/obj/item/clothing/under/syndicate/combat = 10,
		/obj/item/clothing/under/syndicate/rus_army = 10,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate = 7,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 2,
		/obj/item/storage/fancy/cigarettes/cigpack_robust = 2,
		/obj/item/storage/fancy/cigarettes/cigpack_carp = 3,
		/obj/item/storage/fancy/cigarettes/cigpack_midori = 1
	)

/obj/effect/spawner/lootdrop/decorative_material
	lootcount = 1
	loot = list(
		/obj/item/stack/sheet/sandblock{amount = 30} = 25,
		/obj/item/stack/sheet/mineral/wood{amount = 30} = 25,
		/obj/item/stack/sheet/bronze/thirty = 20,
		/obj/item/stack/sheet/plastic{amount = 30} = 10,
	)

/obj/effect/spawner/lootdrop/decorations_spawner
	lootcount = 1
	loot = list(
	/obj/effect/spawner/lootdrop/decorative_material = 25,
	/obj/item/sign = 10,
	/obj/item/flashlight/lamp/green = 10,
	/obj/item/plaque = 5,
	/obj/item/flashlight/lantern/jade = 5,
	/obj/item/phone = 5,
	/obj/item/flashlight/lamp/bananalamp = 3
	)

/// One random selection of some materials, heavily weighted for common drops
/obj/effect/spawner/lootdrop/material
	name = "material spawner"
	loot = list(
		/obj/item/stack/sheet/iron{amount = 15} = 50,
		/obj/item/stack/sheet/glass{amount = 15} = 15,
		/obj/item/stack/sheet/mineral/silver{amount = 10} = 15,
		/obj/item/stack/sheet/mineral/diamond{amount = 5} = 5,
		/obj/item/stack/sheet/mineral/uranium{amount = 5} = 5,
		/obj/item/stack/sheet/mineral/plasma{amount = 5} = 5,
		/obj/item/stack/sheet/mineral/titanium{amount = 5} = 5,
		/obj/item/stack/sheet/mineral/gold{amount = 5} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 1} = 2
	)

//Really low amounts/chances of materials
/obj/effect/spawner/lootdrop/material_scarce
	name = "scarce material spawner"
	loot = list(
		/obj/item/stack/sheet/iron{amount = 5} = 60,
		/obj/item/stack/sheet/glass{amount = 5} = 20,
		/obj/item/stack/sheet/mineral/silver{amount = 3} = 15,
		/obj/item/stack/sheet/mineral/diamond{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/uranium{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/plasma{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/titanium{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/gold{amount = 2} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 1} = 1
	)

/// One random selection of some ore, heavily weighted for common drops
/obj/effect/spawner/lootdrop/ore
	name = "ore spawner"
	loot = list(
		/obj/item/stack/ore/iron{amount = 15} = 50,
		/obj/item/stack/ore/glass{amount = 15} = 15,
		/obj/item/stack/ore/silver{amount = 10} = 15,
		/obj/item/stack/ore/diamond{amount = 5} = 5,
		/obj/item/stack/ore/uranium{amount = 5} = 5,
		/obj/item/stack/ore/plasma{amount = 5} = 5,
		/obj/item/stack/ore/titanium{amount = 5} = 5,
		/obj/item/stack/ore/gold{amount = 5} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 1} = 2
	)

/obj/effect/spawner/lootdrop/ore_scarce
	name = "scarce ore spawner"
	loot = list(
		/obj/item/stack/ore/iron{amount = 5} = 50,
		/obj/item/stack/ore/glass{amount = 5} = 15,
		/obj/item/stack/ore/silver{amount = 3} = 15,
		/obj/item/stack/ore/diamond{amount = 2} = 5,
		/obj/item/stack/ore/uranium{amount = 2} = 5,
		/obj/item/stack/ore/plasma{amount = 2} = 5,
		/obj/item/stack/ore/titanium{amount = 2} = 5,
		/obj/item/stack/ore/gold{amount = 2} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 1} = 2
	)

/obj/effect/spawner/lootdrop/ore_rich
	name = "rich ore spawner"
	loot = list(
		/obj/item/stack/ore/iron{amount = 34} = 50,
		/obj/item/stack/ore/glass{amount = 25} = 15,
		/obj/item/stack/ore/silver{amount = 20} = 15,
		/obj/item/stack/ore/diamond{amount = 10} = 5,
		/obj/item/stack/ore/uranium{amount = 15} = 5,
		/obj/item/stack/ore/plasma{amount = 15} = 5,
		/obj/item/stack/ore/titanium{amount = 15} = 5,
		/obj/item/stack/ore/gold{amount = 15} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 6} = 2
	)

/obj/effect/spawner/lootdrop/tool
	name = "tool spawner"
	loot = list(
		/obj/item/wrench = 1,
		/obj/item/screwdriver = 1,
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,
		/obj/item/wirecutters = 1,
		/obj/item/flashlight = 1,
		/obj/item/weldingtool/largetank = 1,
		/obj/item/multitool = 1
	)

/obj/effect/spawner/lootdrop/scanner
	name = "scanner spawner"
	loot = list(
		/obj/item/mining_scanner = 1,
		/obj/item/t_scanner = 1,
		/obj/item/healthanalyzer = 1,
	)

/obj/effect/spawner/lootdrop/toolbox
	name = "toolbox spawner"
	loot = list(
		/obj/item/storage/toolbox/mechanical = 20,
		/obj/item/storage/toolbox/emergency = 20,
		/obj/item/storage/toolbox/electrical = 20,
		/obj/item/storage/toolbox/syndicate = 1
	)

/obj/effect/spawner/lootdrop/tech_supply
	name = "tech supply spawner"
	loot = list(
		/obj/effect/spawner/lootdrop/toolbox = 1,
		/obj/effect/spawner/lootdrop/scanner = 1,
		/obj/effect/spawner/lootdrop/tool = 1,
		/obj/item/storage/belt/utility = 1,
		/obj/item/clothing/gloves/color/yellow = 1,
		/obj/item/clothing/gloves/color/fyellow = 1,
	)

/obj/effect/spawner/lootdrop/tech_supply/five
	name = "5x tech supply spawner"
	fan_out_items = TRUE
	lootcount = 5

/obj/effect/spawner/lootdrop/medical
	name = "medical equipment spawner"
	loot = list(
		/obj/effect/spawner/lootdrop/medicine/five = 1,
		/obj/effect/spawner/lootdrop/medkit = 1,
		/obj/item/bodybag = 1,
		/obj/structure/closet/crate/freezer/blood = 1,
		/obj/structure/closet/crate/freezer/surplus_limbs = 1,
		/obj/item/storage/backpack/duffelbag/med/surgery = 1,
		/obj/item/storage/organbox = 1
	)

/obj/effect/spawner/lootdrop/medicine
	name = "medicine spawner"
	loot = list(
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/ointment= 5,
		/obj/item/reagent_containers/hypospray/medipen = 5,
		/obj/item/stack/medical/gauze/twelve = 5,
		/obj/item/stack/medical/splint/twelve = 5,
		/obj/item/stack/medical/suture = 5,
		/obj/item/stack/medical/mesh = 5,
		/obj/effect/spawner/lootdrop/toolbox = 1,
		/obj/item/storage/pill_bottle/mining = 1,
		/obj/item/storage/pill_bottle/mannitol = 1,
		/obj/item/storage/pill_bottle/iron = 5,
		/obj/item/storage/pill_bottle/probital = 1,
		/obj/item/storage/pill_bottle/potassiodide = 1,
		/obj/item/storage/pill_bottle/mutadone = 1,
		/obj/item/storage/pill_bottle/epinephrine = 5,
		/obj/item/storage/pill_bottle/multiver = 5
	)

/obj/effect/spawner/lootdrop/medicine/five
	name = "5x medicine spawner"
	fan_out_items = TRUE
	lootcount = 5

/obj/effect/spawner/lootdrop/medkit
	name = "medkit spawner"
	loot = list(
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/storage/firstaid/emergency = 1,
		/obj/item/storage/firstaid/fire = 1,
		/obj/item/storage/firstaid/toxin = 1,
		/obj/item/storage/firstaid/o2 = 1,
		/obj/item/storage/firstaid/brute = 1
	)

/obj/effect/spawner/lootdrop/contraband
	name = "contraband spawner"
	loot = list(
		/obj/item/gun/ballistic/automatic/pistol = 1,
		/obj/item/switchblade = 3,
		/obj/item/poster/random_contraband = 1,
		/obj/item/food/grown/cannabis = 1,
		/obj/item/food/grown/cannabis/rainbow = 1,
		/obj/item/food/grown/cannabis/white = 1,
		/obj/item/storage/box/fireworks/dangerous = 1,
		/obj/item/storage/pill_bottle/zoom = 1,
		/obj/item/storage/pill_bottle/happy = 1,
		/obj/item/storage/pill_bottle/lsd = 1,
		/obj/item/storage/pill_bottle/aranesp = 1,
		/obj/item/storage/pill_bottle/stimulant = 1,
		/obj/item/toy/cards/deck/syndicate = 1,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 1,
		/obj/item/clothing/under/syndicate/tacticool = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_shadyjims = 1,
		/obj/item/clothing/mask/gas/syndicate = 1,
		/obj/item/clothing/neck/necklace/dope = 1,
	)

/obj/effect/spawner/lootdrop/alcohol_bottle
	name = "alcohol bottle spawner"
	loot = list(
		/obj/item/reagent_containers/food/drinks/bottle/gin = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka = 1,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 1,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 1,
		/obj/item/reagent_containers/food/drinks/bottle/maltliquor = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vermouth = 1,
		/obj/item/reagent_containers/food/drinks/bottle/goldschlager = 1,
		/obj/item/reagent_containers/food/drinks/bottle/cognac = 1,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 1,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua = 1
	)

/obj/effect/spawner/lootdrop/ballistic_weapon
	name = "ballistic weapon spawner"
	loot = list(
		/obj/item/gun/ballistic/automatic/pistol = 1,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
		/obj/item/gun/ballistic/shotgun = 1
	)

/obj/effect/spawner/lootdrop/handgun
	name = "handgun spawner"
	loot = list(
		/obj/item/gun/ballistic/automatic/pistol = 1,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
	)

/obj/effect/spawner/lootdrop/melee_weapon
	name = "melee weapon spawner"
	loot = list(
		/obj/item/switchblade = 1,
		/obj/item/kitchen/knife/combat/survival = 1
	)

/obj/effect/spawner/lootdrop/tactical_gear
	name = "tactical gear spawner"
	loot = list(
		/obj/item/clothing/glasses/night = 1,
		/obj/item/clothing/gloves/tackler/combat/insulated = 1,
		/obj/item/clothing/suit/armor/riot = 1,
		/obj/item/clothing/head/helmet/riot = 1
	)

/obj/effect/spawner/lootdrop/grenade
	name = "grenade spawner"
	loot = list(
		/obj/item/grenade/c4/x4 = 1,
		/obj/item/grenade/c4 = 1,
		/obj/item/grenade/frag = 1,
		/obj/item/grenade/flashbang = 1,
		/obj/item/grenade/empgrenade = 1
	)

/obj/effect/spawner/lootdrop/ammo
	name = "ammo spawner"
	loot = list(
		/obj/item/ammo_box/magazine/m9mm = 1,
		/obj/item/ammo_box/magazine/m45 = 1,
		/obj/item/ammo_box/magazine/m12g = 1,
		/obj/item/ammo_box/magazine/m12g/slug = 1
	)

/obj/effect/spawner/lootdrop/plushie
	name = "plushie spawner"
	loot = list(
		/obj/item/toy/plush/beeplushie = 1,
		/obj/item/toy/plush/moth = 1,
		/obj/item/toy/plush/borbplushie = 1,
		/obj/item/toy/plush/snakeplushie = 1,
		/obj/item/toy/plush/space_lizard_plushie = 1,
		/obj/item/toy/plush/lizard_plushie = 1,
		/obj/item/toy/plush/carpplushie = 1
	)

//Valueable loot dedicated for off-station ruins and facilities
/obj/effect/spawner/lootdrop/away_loot
	name = "away loot spawner"
	loot = list(
		/obj/effect/spawner/lootdrop/ballistic_weapon = 1,
		/obj/effect/spawner/lootdrop/contraband = 1,
		/obj/effect/spawner/lootdrop/medicine/five = 1,
		/obj/effect/spawner/lootdrop/tech_supply/five = 1,
		/obj/effect/spawner/lootdrop/space/material = 1,
		/obj/effect/spawner/lootdrop/melee_weapon = 1,
		/obj/effect/spawner/lootdrop/tactical_gear = 1,
		/obj/effect/spawner/lootdrop/grenade = 1
	)

/obj/effect/spawner/lootdrop/eyewear
	name = "eyewear spawner"
	loot = list(
		/obj/item/clothing/glasses/meson = 1,
		/obj/item/clothing/glasses/science = 1,
		/obj/item/clothing/glasses/welding = 1,
		/obj/item/clothing/glasses/hud/health = 1,
		/obj/item/clothing/glasses/sunglasses = 1
	)

/obj/effect/spawner/lootdrop/clothes
	name = "clothes spawner"
	loot = list(
		/obj/item/clothing/under/color/random = 1,
		/obj/item/clothing/under/color/grey = 1,
		/obj/item/clothing/under/misc/overalls = 1,
		/obj/item/clothing/under/misc/assistantformal = 1,
		/obj/item/clothing/under/suit/black = 1,
		/obj/item/clothing/under/suit/black/skirt = 1,
		/obj/item/clothing/under/suit/white = 1,
		/obj/item/clothing/under/suit/white/skirt = 1,
		/obj/item/clothing/under/suit/beige,
		/obj/item/clothing/under/pants/classicjeans = 1,
		/obj/item/clothing/under/pants/blackjeans = 1,
		/obj/item/clothing/under/pants/khaki = 1,
		/obj/item/clothing/under/pants/camo = 1,
		/obj/item/clothing/under/rank/civilian/bartender = 1,
		/obj/item/clothing/under/rank/civilian/bartender/skirt = 1
	)

/obj/effect/spawner/lootdrop/headgear
	name = "headgear spawner"
	loot = list(
		/obj/item/clothing/head/welding = 1,
		/obj/item/clothing/head/ushanka = 1,
		/obj/item/clothing/head/soft/grey = 1,
		/obj/item/clothing/head/soft/black = 1,
		/obj/item/clothing/head/chefhat = 1,
		/obj/item/clothing/head/beret = 1,
		/obj/item/clothing/head/beret/black = 1,
		/obj/item/clothing/head/fedora/curator = 1,
		/obj/item/clothing/head/helmet/old = 1,
		/obj/item/clothing/head/bandana = 1
	)

/obj/effect/spawner/lootdrop/gloves
	name = "gloves spawner"
	loot = list(
		/obj/item/clothing/gloves/color/black = 3,
		/obj/item/clothing/gloves/color/fyellow = 3,
		/obj/item/clothing/gloves/color/yellow = 1,
		/obj/item/clothing/gloves/color/grey = 3,
		/obj/item/clothing/gloves/fingerless = 3,
		/obj/item/clothing/gloves/color/light_brown = 3,
		/obj/item/clothing/gloves/color/brown = 3
	)

/obj/effect/spawner/lootdrop/shoes
	name = "shoes spawner"
	loot = list(
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/shoes/sneakers/brown = 1,
		/obj/item/clothing/shoes/sneakers/blue = 1,
		/obj/item/clothing/shoes/jackboots = 1
	)

/obj/effect/spawner/lootdrop/suit
	name = "suit spawner"
	loot = list(
		/obj/item/clothing/suit/toggle/labcoat = 1,
		/obj/item/clothing/suit/pirate = 1,
		/obj/item/clothing/suit/poncho = 1,
		/obj/item/clothing/suit/jacket/letterman = 1,
		/obj/item/clothing/suit/toggle/chef = 1,
		/obj/item/clothing/suit/hooded/wintercoat = 1,
		/obj/item/clothing/suit/hooded/wintercoat/aformal = 1
	)

/obj/effect/spawner/lootdrop/cash
	name = "cash spawner"
	loot = list(
		/obj/item/stack/spacecash/c1 = 4,
		/obj/item/stack/spacecash/c10 = 4,
		/obj/item/stack/spacecash/c20 = 4,
		/obj/item/stack/spacecash/c50 = 3,
		/obj/item/stack/spacecash/c100 = 2,
		/obj/item/stack/spacecash/c200 = 2,
		/obj/item/stack/spacecash/c500 = 1,
		/obj/item/stack/spacecash/c1000 = 1
	)

/obj/effect/spawner/lootdrop/cash/five
	name = "5x cash spawner"
	fan_out_items = TRUE
	lootcount = 5

// Lets loot tables be both list(a, b, c), as well as list(a = 3, b = 2, c = 2)
/proc/fill_with_ones(list/table)
	if (!islist(table))
		return table

	var/list/final_table = list()

	for (var/key in table)
		if (table[key])
			final_table[key] = table[key]
		else
			final_table[key] = 1

	return final_table
