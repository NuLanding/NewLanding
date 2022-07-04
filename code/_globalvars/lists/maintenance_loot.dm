//as of:10/28/2019:
//boxstation: ~153 loot items spawned
//metastation: ~183 loot items spawned
//deltastation: ~165 loot items spawned

//how to balance maint loot spawns:
// 1) Ensure each category has items of approximately the same power level
// 2) Tune weight of each category until average power of a maint loot spawn is acceptable
// 3) Mapping considerations - Loot value should scale with difficulty of acquisition, or an assistaint will run through collecting free gear with no risk

//goal of maint loot:
// 1) Provide random equipment to people who take effort to crawl maint
// 2) Create memorable moments with very rare, crazy items

//Loot tables

GLOBAL_LIST_INIT(trash_loot, list(//junk: useless, very easy to get, or ghetto chemistry items
	list(//trash
		/obj/item/trash/can = 1,
		/obj/item/trash/raisins = 1,
		/obj/item/trash/candy = 1,
		/obj/item/trash/cheesie = 1,
		/obj/item/trash/chips = 1,
		/obj/item/trash/popcorn = 1,
		/obj/item/trash/sosjerky = 1,
		/obj/item/trash/pistachios = 1,
		/obj/item/folder/yellow = 1,
		/obj/item/hand_labeler = 1,
		/obj/item/pen = 1,
		/obj/item/paper = 1,
		/obj/item/paper/crumpled = 1,
		/obj/item/photo/old = 1,
		/obj/item/stack/sheet/cardboard = 1,
		/obj/item/storage/box = 1,
		/obj/item/c_tube = 1,

		/obj/item/reagent_containers/food/drinks/drinkingglass = 1,
		/obj/item/coin/silver = 1,
		/obj/effect/decal/cleanable/ash = 1,
		/obj/item/camera = 1,
		/obj/item/camera_film = 1,
		/obj/item/food/urinalcake = 1,

		/obj/item/rack_parts = 1,
		/obj/item/shard = 1,

		/obj/item/toy/eightball = 1,
		) = 8,

	list(//tier 1 stock parts

		) = 1,
	))



GLOBAL_LIST_INIT(common_loot, list( //common: basic items
	list(//tools
		/obj/item/screwdriver = 1,
		/obj/item/wirecutters = 1,
		/obj/item/wrench = 1,
		/obj/item/crowbar = 1,
		/obj/item/t_scanner = 1,
		/obj/item/geiger_counter = 1,
		/obj/item/mop = 1,
		/obj/item/pushbroom = 1,
		/obj/item/reagent_containers/glass/bucket = 1,
		/obj/item/toy/crayon/spraycan = 1,
		/obj/item/weldingtool = 1,
		) = 1,

	list(//equipment
		/obj/item/storage/backpack = 1,
		/obj/item/storage/wallet/random = 1,
		/obj/item/storage/belt/fannypack = 1,
		) = 1,

	list(//construction and crafting
		/obj/item/stack/rods/twentyfive = 1,
		/obj/item/stack/sheet/iron/twenty = 1,
		/obj/item/stack/sheet/mineral/plasma = 1,

		/obj/item/stack/package_wrap = 1,
		/obj/item/stack/wrapping_paper = 1,
		) = 1,

	list(//medical and chemicals
		/obj/item/grenade/chem_grenade/cleaner = 1,
		/obj/item/reagent_containers/syringe = 1,
		/obj/item/reagent_containers/glass/beaker = 1,
		/obj/item/reagent_containers/rag = 1,
		/obj/item/reagent_containers/hypospray/medipen/pumpup = 2,
		/obj/item/reagent_containers/glass/bottle/random_buffer = 2,
		) = 1,

	list(//food
		/obj/item/reagent_containers/food/drinks/beer = 1,
		/obj/item/reagent_containers/food/drinks/coffee = 1,
		) = 1,

	list(//misc
		/obj/item/extinguisher = 1,
		/obj/item/grenade/smokebomb = 1,
		/obj/item/stack/spacecash/c10 = 1,
		/obj/item/stack/sticky_tape = 1,

		//light sources
		/obj/item/flashlight = 1,
		/obj/effect/spawner/lootdrop/glowstick = 1,
		/obj/item/flashlight/flare = 1,
		) = 1,
	))



GLOBAL_LIST_INIT(uncommon_loot, list(//uncommon: useful items
	list(//tools
		/obj/item/weldingtool/largetank = 1,
		/obj/item/multitool = 1,
		/obj/item/hatchet = 1,
		/obj/item/roller = 1,
		/obj/item/restraints/legcuffs/bola = 1,
		/obj/item/restraints/handcuffs/cable = 1,
		/obj/item/spear = 1,
		/obj/item/grenade/iedcasing/spawned = 1,
		/obj/item/pen/fountain = 1,
		) = 8,

	list(//equipment
		/obj/item/storage/belt/utility = 1,
		/obj/item/storage/belt/medical = 1,
		) = 8,

	list(//construction and crafting
		/obj/item/stack/sheet/mineral/wood/fifty = 1,
		/obj/item/beacon = 1,
		/obj/item/weaponcrafting/receiver = 1,
		/obj/item/paper/fluff/stations/soap = 1, //recipes count as crafting.
		/obj/item/storage/box/clown = 1,
		) = 8,

	list(//medical and chemicals
		list(//basic healing items
			/obj/item/stack/medical/suture = 1,
			/obj/item/stack/medical/mesh = 1,
			/obj/item/stack/medical/gauze = 1,
			) = 1,
		list(//medical chems
			/obj/item/reagent_containers/glass/bottle/multiver = 1,
			/obj/item/reagent_containers/syringe/convermol = 1,
			/obj/item/reagent_containers/hypospray/medipen = 1,
			) = 1,
		list(//drinks
			/obj/item/reagent_containers/food/drinks/bottle/vodka = 1,
			/obj/item/reagent_containers/food/drinks/soda_cans/grey_bull = 1,
			/obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola = 1,
			) = 1,
		list(//sprayers
			/obj/item/reagent_containers/spray = 1,
			/obj/item/watertank = 1,
			/obj/item/watertank/janitor = 1,
			) = 1,
		) = 8,

	list(//food
		/obj/item/food/canned/peaches/maint = 1,
		/obj/item/storage/box/gum/happiness = 1,
		/obj/item/storage/box/donkpockets = 1,
		list(//Donk Varieties
			/obj/item/storage/box/donkpockets/donkpocketspicy = 1,
			/obj/item/storage/box/donkpockets/donkpocketteriyaki = 1,
			/obj/item/storage/box/donkpockets/donkpocketpizza = 1,
			/obj/item/storage/box/donkpockets/donkpocketberry = 1,
			/obj/item/storage/box/donkpockets/donkpockethonk = 1,
			) = 1,
		/obj/item/food/monkeycube = 1,
		) = 8,

	list(//fakeout items, keep this list at low relative weight
		/obj/item/dice/d20 = 1, //To balance out the stealth die of fates in oddities
		) = 1,
))



GLOBAL_LIST_INIT(rarity_loot, list(//rare: really good items
	list(//tools
		/obj/item/weldingtool/hugetank = 1,
		/obj/item/kitchen/knife = 1,
		/obj/item/restraints/handcuffs = 1,
		/obj/item/shield/riot/buckler = 1,
		/obj/item/throwing_star = 1,
		/obj/item/pen/survival = 1,
		/obj/item/flashlight/flashdark = 1,
		) = 1,

	list(//equipment
		/obj/item/storage/belt/security = 1,
		/obj/item/storage/belt/military/assault = 1,
		) = 1,

	list(//paint
		/obj/item/paint/red = 1,
		/obj/item/paint/green = 1,
		/obj/item/paint/blue = 1,
		/obj/item/paint/yellow = 1,
		/obj/item/paint/violet = 1,
		/obj/item/paint/black = 1,
		/obj/item/paint/white = 1,
		/obj/item/paint/anycolor = 1,
		/obj/item/paint_remover = 1,
		) = 1,

	list(//medical and chemicals
		list(//medkits
			/obj/item/storage/box/hug/medical = 1,
			/obj/item/storage/firstaid/regular = 1,
			/obj/item/storage/firstaid/emergency = 1,
			) = 1,
		list(//medical chems
			/obj/item/reagent_containers/hypospray/medipen/salacid = 1,
			/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 1,
			/obj/item/reagent_containers/syringe/contraband/methamphetamine = 1,
			) = 1,
		) = 1,

	list(//misc
		) = 1,

))



GLOBAL_LIST_INIT(oddity_loot, list(//oddity: strange or crazy items
		/obj/item/spear/grey_tide = 1,
	))

//Maintenance loot spawner pools
#define maint_trash_weight 4500
#define maint_common_weight 4500
#define maint_uncommon_weight 900
#define maint_rarity_weight 99
#define maint_oddity_weight 1 //1 out of 10,000 would give metastation (180 spawns) a 2 in 111 chance of spawning an oddity per round, similar to xeno egg
#define maint_holiday_weight 3500 // When holiday loot is enabled, it'll give every loot item a 25% chance of being a holiday item

//Loot pool used by default maintenance loot spawners
GLOBAL_LIST_INIT(maintenance_loot, list(
	GLOB.trash_loot = maint_trash_weight,
	GLOB.common_loot = maint_common_weight,
	GLOB.uncommon_loot = maint_uncommon_weight,
	GLOB.rarity_loot = maint_rarity_weight,
	GLOB.oddity_loot = maint_oddity_weight,
	))

GLOBAL_LIST_INIT(ratking_trash, list(//Garbage: used by the regal rat mob when spawning garbage.
			/obj/item/trash/cheesie,
			/obj/item/trash/candy,
			/obj/item/trash/chips,
			/obj/item/trash/pistachios,
			/obj/item/trash/popcorn,
			/obj/item/trash/raisins,
			/obj/item/trash/sosjerky,
			/obj/item/trash/syndi_cakes))

GLOBAL_LIST_INIT(ratking_coins, list(//Coins: Used by the regal rat mob when spawning coins.
			/obj/item/coin/iron,
			/obj/item/coin/silver,
			/obj/item/coin/plastic,
			/obj/item/coin/titanium))
