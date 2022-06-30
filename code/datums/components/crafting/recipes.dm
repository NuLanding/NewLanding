/datum/crafting_recipe
	var/name = "" //in-game display name
	var/list/reqs = list() //type paths of items consumed associated with how many are needed
	var/list/blacklist = list() //type paths of items explicitly not allowed as an ingredient
	var/result //type path of item resulting from this craft
	/// String defines of items needed but not consumed. Lazy list.
	var/list/tool_behaviors
	/// Type paths of items needed but not consumed. Lazy list.
	var/list/tool_paths
	var/time = 30 //time in deciseconds
	var/list/parts = list() //type paths of items that will be placed in the result
	var/list/chem_catalysts = list() //like tool_behaviors but for reagents
	var/category = CAT_NONE //where it shows up in the crafting UI
	var/subcategory = CAT_NONE
	var/always_available = TRUE //Set to FALSE if it needs to be learned first.
	/// Additonal requirements text shown in UI
	var/additional_req_text
	///Should only one object exist on the same turf?
	var/one_per_turf = FALSE

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result
	if(tool_behaviors)
		tool_behaviors = string_list(tool_behaviors)
	if(tool_paths)
		tool_paths = string_list(tool_paths)

/**
 * Run custom pre-craft checks for this recipe
 *
 * user: The /mob that initiated the crafting
 * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
 */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE

/datum/crafting_recipe/proc/on_craft_completion(mob/user, atom/result)
	return

/datum/crafting_recipe/lance
	name = "Explosive Lance (Grenade)"
	result = /obj/item/spear/explosive
	reqs = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	blacklist = list(/obj/item/spear/bonespear)
	parts = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/molotov
	name = "Molotov"
	result = /obj/item/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/reagent_containers/rag = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/bola
	name = "Bola"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/iron = 6)
	time = 20//15 faster than crafting them by hand!
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gonbola
	name = "Gonbola"
	result = /obj/item/restraints/legcuffs/bola/gonbola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/iron = 6,
				/obj/item/stack/sheet/animalhide/gondola = 1)
	time = 40
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/tailclub
	name = "Tail Club"
	result = /obj/item/tailclub
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/sheet/iron = 1)
	blacklist = list(/obj/item/organ/tail/lizard/fake)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/tailwhip
	name = "Liz O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip
	reqs = list(/obj/item/organ/tail/lizard = 1)
	blacklist = list(/obj/item/organ/tail/lizard/fake)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/catwhip
	name = "Cat O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip/kitty
	reqs = list(/obj/item/organ/tail/cat = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/riflestock
	name = "Wooden Rifle Stock"
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/weaponcrafting/stock
	reqs = list(/obj/item/stack/sheet/mineral/wood = 8,
				/obj/item/stack/sticky_tape = 1)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1, /datum/reagent/phosphorus = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid = 5,
				/datum/reagent/toxin/acid/fluacid = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/stack/sheet/iron = 2,
				/datum/reagent/fuel = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 12
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/pipegun
	name = "Pipegun"
	result = /obj/item/gun/ballistic/rifle/boltaction/pipegun
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/sticky_tape = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/chainsaw
	name = "Chainsaw"
	result = /obj/item/chainsaw
	reqs = list(/obj/item/circular_saw = 1,
				/obj/item/stack/sheet/plasteel = 5)
	tool_behaviors = list(TOOL_WELDER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/spear
	name = "Spear"
	result = /obj/item/spear
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/shard = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/shard = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/mixedbouquet
	name = "Mixed bouquet"
	result = /obj/item/bouquet
	reqs = list(/obj/item/food/grown/poppy/lily =2,
				/obj/item/grown/sunflower = 2,
				/obj/item/food/grown/poppy/geranium = 2)
	category = CAT_MISC

/datum/crafting_recipe/sunbouquet
	name = "Sunflower bouquet"
	result = /obj/item/bouquet/sunflower
	reqs = list(/obj/item/grown/sunflower = 6)
	category = CAT_MISC

/datum/crafting_recipe/poppybouquet
	name = "Poppy bouquet"
	result = /obj/item/bouquet/poppy
	reqs = list (/obj/item/food/grown/poppy = 6)
	category = CAT_MISC

/datum/crafting_recipe/rosebouquet
	name = "Rose bouquet"
	result = /obj/item/bouquet/rose
	reqs = list(/obj/item/food/grown/rose = 6)
	category = CAT_MISC

/datum/crafting_recipe/spooky_camera
	name = "Camera Obscura"
	result = /obj/item/camera/spooky
	time = 15
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	category = CAT_MISC


/datum/crafting_recipe/skateboard
	name = "Skateboard"
	result = /obj/vehicle/ridden/scooter/skateboard/improvised
	time = 60
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/rods = 10)
	category = CAT_MISC

/datum/crafting_recipe/scooter
	name = "Scooter"
	result = /obj/vehicle/ridden/scooter
	time = 65
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/rods = 12)
	category = CAT_MISC

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/iron = 4,
				/obj/item/stack/rods = 6)
	time = 100
	category = CAT_MISC

/datum/crafting_recipe/papersack
	name = "Paper Sack"
	result = /obj/item/storage/box/papersack
	time = 10
	reqs = list(/obj/item/paper = 5)
	category = CAT_MISC

/datum/crafting_recipe/paperframes
	name = "Paper Frames"
	result = /obj/item/stack/sheet/paperframes/five
	time = 10
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5, /obj/item/paper = 20)
	category = CAT_MISC

/datum/crafting_recipe/curtain
	name = "Curtains"
	reqs = list(/obj/item/stack/sheet/cloth = 4, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain/cloth
	category = CAT_MISC

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/sheet/plastic = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	category = CAT_MISC

/datum/crafting_recipe/gold_horn
	name = "Golden Bike Horn"
	result = /obj/item/bikehorn/golden
	time = 20
	reqs = list(/obj/item/stack/sheet/mineral/bananium = 5,
				/obj/item/bikehorn = 1)
	category = CAT_MISC

/datum/crafting_recipe/bonedagger
	name = "Bone Dagger"
	result = /obj/item/kitchen/knife/combat/bone
	time = 20
	reqs = list(/obj/item/stack/sheet/bone = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonespear
	name = "Bone Spear"
	result = /obj/item/spear/bonespear
	time = 30
	reqs = list(/obj/item/stack/sheet/bone = 4,
				/obj/item/stack/sheet/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/boneaxe
	name = "Bone Axe"
	result = /obj/item/fireaxe/boneaxe
	time = 50
	reqs = list(/obj/item/stack/sheet/bone = 6,
				/obj/item/stack/sheet/sinew = 3)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonfire
	name = "Bonfire"
	time = 60
	reqs = list(/obj/item/grown/log = 5)
	parts = list(/obj/item/grown/log = 5)
	blacklist = list(/obj/item/grown/log/steel)
	result = /obj/structure/bonfire
	category = CAT_PRIMAL

/datum/crafting_recipe/rake //Category resorting incoming
	name = "Rake"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	result = /obj/item/cultivator/rake
	category = CAT_PRIMAL

/datum/crafting_recipe/woodbucket
	name = "Wooden Bucket"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	result = /obj/item/reagent_containers/glass/bucket/wooden
	category = CAT_PRIMAL

/datum/crafting_recipe/headpike
	name = "Spike Head (Glass Spear)"
	time = 65
	reqs = list(/obj/item/spear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear = 1)
	blacklist = list(/obj/item/spear/explosive, /obj/item/spear/bonespear)
	result = /obj/structure/headpike
	category = CAT_PRIMAL

/datum/crafting_recipe/headpikebone
	name = "Spike Head (Bone Spear)"
	time = 65
	reqs = list(/obj/item/spear/bonespear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear/bonespear = 1)
	result = /obj/structure/headpike/bone
	category = CAT_PRIMAL

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/mineral/wood = 20)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_MISC

/datum/crafting_recipe/boneshovel
	name = "Serrated Bone Shovel"
	always_available = FALSE
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/datum/reagent/fuel/oil = 5,
		/obj/item/shovel/spade = 1,
	)
	result = /obj/item/shovel/serrated
	category = CAT_PRIMAL

/datum/crafting_recipe/lasso
	name = "Bone Lasso"
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 5,
	)
	result = /obj/item/key/lasso
	category = CAT_PRIMAL

/datum/crafting_recipe/ipickaxe
	name = "Improvised Pickaxe"
	reqs = list(
		/obj/item/crowbar = 1,
		/obj/item/kitchen/knife = 1,
		/obj/item/stack/sticky_tape = 1,
	)
	result = /obj/item/pickaxe/improvised
	category = CAT_MISC

/datum/crafting_recipe/basket
	name = "Basket (Bamboo)"
	reqs = list(
		/obj/item/stack/sheet/mineral/bamboo = 20
	)
	result = /obj/item/storage/basket
	category = CAT_MISC

//Same but with wheat
/datum/crafting_recipe/basket/wheat
	name = "Basket (Wheat)"
	reqs = list(
		/obj/item/food/grown/wheat = 50
	)

/datum/crafting_recipe/elder_atmosian_statue
	name = "Elder Atmosian Statue"
	result = /obj/structure/statue/elder_atmosian
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/metal_hydrogen = 20,
				/obj/item/stack/sheet/mineral/zaukerite = 15,
				/obj/item/stack/sheet/iron = 30,
				)
	category = CAT_MISC

/datum/crafting_recipe/aquarium
	name = "Aquarium"
	result = /obj/structure/aquarium
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/stack/sheet/glass = 10,
				/obj/item/aquarium_kit = 1
				)
	category = CAT_MISC

/datum/crafting_recipe/alcohol_burner
	name = "Alcohol burner"
	result = /obj/item/burner
	time = 5 SECONDS
	reqs = list(/obj/item/reagent_containers/glass/beaker  = 1,
				/datum/reagent/consumable/ethanol = 15,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/oil_burner
	name = "Oil burner"
	result = /obj/item/burner/oil
	time = 5 SECONDS
	reqs = list(/obj/item/reagent_containers/glass/beaker  = 1,
				/datum/reagent/fuel/oil = 15,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/fuel_burner
	name = "Fuel burner"
	result = /obj/item/burner/fuel
	time = 5 SECONDS
	reqs = list(/obj/item/reagent_containers/glass/beaker  = 1,
				/datum/reagent/fuel = 15,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/thermometer
	name = "Thermometer"
	tool_behaviors = list(TOOL_WELDER)
	result = /obj/item/thermometer
	time = 5 SECONDS
	reqs = list(
				/datum/reagent/mercury = 5,
				/obj/item/stack/sheet/glass = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/thermometer_alt
	name = "Thermometer"
	result = /obj/item/thermometer/pen
	time = 5 SECONDS
	reqs = list(
				/datum/reagent/mercury = 5,
				/obj/item/pen = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/ph_booklet
	name = "pH booklet"
	result = /obj/item/ph_booklet
	time = 5 SECONDS
	reqs = list(
				/datum/reagent/universal_indicator = 5,
				/obj/item/paper = 1
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/dropper //Maybe make a glass pipette icon?
	name = "Dropper"
	result = /obj/item/reagent_containers/dropper
	tool_behaviors = list(TOOL_WELDER)
	time = 5 SECONDS
	reqs = list(
				/obj/item/stack/sheet/glass  = 1,
				)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/improvised_coolant
	name = "Improvised cooling spray"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/extinguisher/crafted
	time = 10 SECONDS
	reqs = list(
			/obj/item/toy/crayon/spraycan = 1,
			/datum/reagent/water = 20,
			/datum/reagent/consumable/ice = 10
			)
	category = CAT_CHEMISTRY

