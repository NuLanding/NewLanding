
#define GIBTONITE_QUALITY_HIGH 3
#define GIBTONITE_QUALITY_MEDIUM 2
#define GIBTONITE_QUALITY_LOW 1

#define ORESTACK_OVERLAYS_MAX 10

/**********************Mineral ores**************************/

/obj/item/stack/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore"
	inhand_icon_state = "ore"
	full_w_class = WEIGHT_CLASS_BULKY
	singular_name = "ore chunk"
	var/points = 0 //How many points this ore gets you from the ore redemption machine
	var/refined_type = null //What this ore defaults to being refined into
	var/mine_experience = 5 //How much experience do you get for mining this ore?
	novariants = TRUE // Ore stacks handle their icon updates themselves to keep the illusion that there's more going
	var/list/stack_overlays
	var/scan_state = "" //Used by mineral turfs for their scan overlay.
	var/spreadChance = 0 //Also used by mineral turfs for spreading veins

/obj/item/stack/ore/update_overlays()
	. = ..()
	var/difference = min(ORESTACK_OVERLAYS_MAX, amount) - (LAZYLEN(stack_overlays)+1)
	if(!difference)
		return

	if(difference < 0 && LAZYLEN(stack_overlays)) //amount < stack_overlays, remove excess.
		if(LAZYLEN(stack_overlays)-difference <= 0)
			stack_overlays = null
			return
		stack_overlays.len += difference

	else //amount > stack_overlays, add some.
		for(var/i in 1 to difference)
			var/mutable_appearance/newore = mutable_appearance(icon, icon_state)
			newore.pixel_x = rand(-8,8)
			newore.pixel_y = rand(-8,8)
			LAZYADD(stack_overlays, newore)

	if(stack_overlays)
		. += stack_overlays

/obj/item/stack/ore/welder_act(mob/living/user, obj/item/I)
	..()
	if(!refined_type)
		return TRUE

	if(I.use_tool(src, user, 0, volume=50, amount=15))
		new refined_type(drop_location())
		use(1)

	return TRUE

/obj/item/stack/ore/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	if(isnull(refined_type))
		return
	else
		var/probability = (rand(0,100))/100
		var/burn_value = probability*amount
		var/amountrefined = round(burn_value, 1)
		if(amountrefined < 1)
			qdel(src)
		else
			new refined_type(drop_location(),amountrefined)
			qdel(src)

/obj/item/stack/ore/uranium
	name = "uranium ore"
	icon_state = "Uranium ore"
	inhand_icon_state = "Uranium ore"
	singular_name = "uranium ore chunk"
	points = 30
	material_flags = MATERIAL_NO_EFFECTS
	mats_per_unit = list(/datum/material/uranium=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/uranium
	mine_experience = 6
	scan_state = "rock_Uranium"
	spreadChance = 5
	merge_type = /obj/item/stack/ore/uranium

/obj/item/stack/ore/iron
	name = "iron ore"
	icon_state = "Iron ore"
	inhand_icon_state = "Iron ore"
	singular_name = "iron ore chunk"
	points = 1
	mats_per_unit = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/iron
	mine_experience = 1
	scan_state = "rock_Iron"
	spreadChance = 20
	merge_type = /obj/item/stack/ore/iron

/obj/item/stack/ore/glass
	name = "sand pile"
	icon_state = "Glass ore"
	inhand_icon_state = "Glass ore"
	singular_name = "sand pile"
	points = 1
	mats_per_unit = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/glass
	w_class = WEIGHT_CLASS_TINY
	mine_experience = 0 //its sand
	merge_type = /obj/item/stack/ore/glass

GLOBAL_LIST_INIT(sand_recipes, list(\
		new /datum/stack_recipe("sandstone", /obj/item/stack/sheet/mineral/sandstone, 1, 1, 50),\
))

/obj/item/stack/ore/glass/get_main_recipes()
	. = ..()
	. += GLOB.sand_recipes

/obj/item/stack/ore/glass/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !ishuman(hit_atom))
		return
	var/mob/living/carbon/human/C = hit_atom
	if(C.is_eyes_covered())
		C.visible_message(SPAN_DANGER("[C]'s eye protection blocks the sand!"), SPAN_WARNING("Your eye protection blocks the sand!"))
		return
	C.adjust_blurriness(6)
	C.adjustStaminaLoss(15)//the pain from your eyes burning does stamina damage
	C.add_confusion(5)
	to_chat(C, SPAN_USERDANGER("\The [src] gets into your eyes! The pain, it burns!"))
	qdel(src)

/obj/item/stack/ore/glass/ex_act(severity, target)
	if(severity)
		qdel(src)

/obj/item/stack/ore/glass/basalt
	name = "volcanic ash"
	icon_state = "volcanic_sand"
	inhand_icon_state = "volcanic_sand"
	singular_name = "volcanic ash pile"
	mine_experience = 0
	merge_type = /obj/item/stack/ore/glass/basalt

/obj/item/stack/ore/plasma
	name = "plasma ore"
	icon_state = "Plasma ore"
	inhand_icon_state = "Plasma ore"
	singular_name = "plasma ore chunk"
	points = 15
	mats_per_unit = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/plasma
	mine_experience = 5
	scan_state = "rock_Plasma"
	spreadChance = 8
	merge_type = /obj/item/stack/ore/plasma

/obj/item/stack/ore/plasma/welder_act(mob/living/user, obj/item/I)
	to_chat(user, SPAN_WARNING("You can't hit a high enough temperature to smelt [src] properly!"))
	return TRUE

/obj/item/stack/ore/silver
	name = "silver ore"
	icon_state = "Silver ore"
	inhand_icon_state = "Silver ore"
	singular_name = "silver ore chunk"
	points = 16
	mine_experience = 3
	mats_per_unit = list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/silver
	scan_state = "rock_Silver"
	spreadChance = 5
	merge_type = /obj/item/stack/ore/silver

/obj/item/stack/ore/gold
	name = "gold ore"
	icon_state = "Gold ore"
	inhand_icon_state = "Gold ore"
	singular_name = "gold ore chunk"
	points = 18
	mine_experience = 5
	mats_per_unit = list(/datum/material/gold=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/gold
	scan_state = "rock_Gold"
	spreadChance = 5
	merge_type = /obj/item/stack/ore/gold

/obj/item/stack/ore/diamond
	name = "diamond ore"
	icon_state = "Diamond ore"
	inhand_icon_state = "Diamond ore"
	singular_name = "diamond ore chunk"
	points = 50
	mats_per_unit = list(/datum/material/diamond=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/diamond
	mine_experience = 10
	scan_state = "rock_Diamond"
	merge_type = /obj/item/stack/ore/diamond

/obj/item/stack/ore/bananium
	name = "bananium ore"
	icon_state = "Bananium ore"
	inhand_icon_state = "Bananium ore"
	singular_name = "bananium ore chunk"
	points = 60
	mats_per_unit = list(/datum/material/bananium=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/bananium
	mine_experience = 15
	scan_state = "rock_Bananium"
	merge_type = /obj/item/stack/ore/bananium

/obj/item/stack/ore/titanium
	name = "titanium ore"
	icon_state = "Titanium ore"
	inhand_icon_state = "Titanium ore"
	singular_name = "titanium ore chunk"
	points = 50
	mats_per_unit = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/titanium
	mine_experience = 3
	scan_state = "rock_Titanium"
	spreadChance = 5
	merge_type = /obj/item/stack/ore/titanium

/obj/item/stack/ore/slag
	name = "slag"
	desc = "Completely useless."
	icon_state = "slag"
	inhand_icon_state = "slag"
	singular_name = "slag chunk"
	merge_type = /obj/item/stack/ore/slag

/obj/item/stack/ore/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/stack/ore/ex_act(severity, target)
	if(severity >= EXPLODE_DEVASTATE)
		qdel(src)


/*****************************Coin********************************/

// The coin's value is a value of it's materials.
// Yes, the gold standard makes a come-back!
// This is the only way to make coins that are possible to produce on station actually worth anything.
/obj/item/coin
	icon = 'icons/obj/economy.dmi'
	name = "coin"
	icon_state = "coin"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = 400)
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	var/list/sideslist = list("heads","tails")
	var/cooldown = 0
	var/value
	var/coinflip
	item_flags = NO_MAT_REDEMPTION //You know, it's kind of a problem that money is worth more extrinsicly than intrinsically in this universe.

/obj/item/coin/Initialize()
	. = ..()
	coinflip = pick(sideslist)
	icon_state = "coin_[coinflip]"
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/coin/set_custom_materials(list/materials, multiplier = 1)
	. = ..()
	value = 0
	for(var/i in custom_materials)
		var/datum/material/M = i
		value += M.value_per_unit * custom_materials[M]

/obj/item/coin/suicide_act(mob/living/user)
	user.visible_message(SPAN_SUICIDE("[user] contemplates suicide with \the [src]!"))
	if (!attack_self(user))
		user.visible_message(SPAN_SUICIDE("[user] couldn't flip \the [src]!"))
		return SHAME
	addtimer(CALLBACK(src, .proc/manual_suicide, user), 10)//10 = time takes for flip animation
	return MANUAL_SUICIDE_NONLETHAL

/obj/item/coin/proc/manual_suicide(mob/living/user)
	var/index = sideslist.Find(coinflip)
	if (index==2)//tails
		user.visible_message(SPAN_SUICIDE("\the [src] lands on [coinflip]! [user] promptly falls over, dead!"))
		user.adjustOxyLoss(200)
		user.death(0)
		user.set_suicide(TRUE)
		user.suicide_log()
	else
		user.visible_message(SPAN_SUICIDE("\the [src] lands on [coinflip]! [user] keeps on living!"))

/obj/item/coin/examine(mob/user)
	. = ..()
	. += SPAN_INFO("It's worth [value] credit\s.")

/obj/item/coin/attack_self(mob/user)
	if(cooldown < world.time)
		cooldown = world.time + 15
		flick("coin_[coinflip]_flip", src)
		coinflip = pick(sideslist)
		icon_state = "coin_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, TRUE)
		var/oldloc = loc
		sleep(15)
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message(SPAN_NOTICE("[user] flips [src]. It lands on [coinflip]."), \
				SPAN_NOTICE("You flip [src]. It lands on [coinflip]."), \
				SPAN_HEAR("You hear the clattering of loose change."))
	return TRUE//did the coin flip? useful for suicide_act

/obj/item/coin/gold
	custom_materials = list(/datum/material/gold = 400)

/obj/item/coin/silver
	custom_materials = list(/datum/material/silver = 400)

/obj/item/coin/diamond
	custom_materials = list(/datum/material/diamond = 400)

/obj/item/coin/plasma
	custom_materials = list(/datum/material/plasma = 400)

/obj/item/coin/uranium
	custom_materials = list(/datum/material/uranium = 400)

/obj/item/coin/titanium
	custom_materials = list(/datum/material/titanium = 400)

/obj/item/coin/bananium
	custom_materials = list(/datum/material/bananium = 400)

/obj/item/coin/adamantine
	custom_materials = list(/datum/material/adamantine = 400)

/obj/item/coin/mythril
	custom_materials = list(/datum/material/mythril = 400)

/obj/item/coin/plastic
	custom_materials = list(/datum/material/plastic = 400)

/obj/item/coin/runite
	custom_materials = list(/datum/material/runite = 400)

/obj/item/coin/iron

#undef ORESTACK_OVERLAYS_MAX
