/obj/item/storage/box/ingredients //This box is for the randomly chosen version the chef used to spawn with, it shouldn't actually exist.
	name = "ingredients box"
	illustration = "fruit"
	var/theme_name

/obj/item/storage/box/ingredients/Initialize()
	. = ..()
	if(theme_name)
		name = "[name] ([theme_name])"
		desc = "A box containing supplementary ingredients for the aspiring chef. The box's theme is '[theme_name]'."
		inhand_icon_state = "syringe_kit"

/obj/item/storage/box/ingredients/wildcard
	theme_name = "wildcard"

/obj/item/storage/box/ingredients/wildcard/PopulateContents()
	for(var/i in 1 to 7)
		var/randomFood = pick(/obj/item/food/grown/chili,
							  /obj/item/food/grown/tomato,
							  /obj/item/food/grown/carrot,
							  /obj/item/food/grown/potato,
							  /obj/item/food/grown/potato/sweet,
							  /obj/item/food/grown/apple,
							  /obj/item/food/chocolatebar,
							  /obj/item/food/grown/cherries,
							  /obj/item/food/grown/banana,
							  /obj/item/food/grown/cabbage,
							  /obj/item/food/grown/soybeans,
							  /obj/item/food/grown/corn,
							  /obj/item/food/grown/mushroom/plumphelmet,
							  /obj/item/food/grown/mushroom/chanterelle)
		new randomFood(src)

/obj/item/storage/box/ingredients/fiesta
	theme_name = "fiesta"

/obj/item/storage/box/ingredients/fiesta/PopulateContents()
	new /obj/item/food/tortilla(src)
	for(var/i in 1 to 2)
		new /obj/item/food/grown/corn(src)
		new /obj/item/food/grown/soybeans(src)
		new /obj/item/food/grown/chili(src)

/obj/item/storage/box/ingredients/italian
	theme_name = "italian"

/obj/item/storage/box/ingredients/italian/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/food/grown/tomato(src)
		new /obj/item/food/meatball(src)
	new /obj/item/reagent_containers/food/drinks/bottle/wine(src)

/obj/item/storage/box/ingredients/vegetarian
	theme_name = "vegetarian"

/obj/item/storage/box/ingredients/vegetarian/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/carrot(src)
	new /obj/item/food/grown/eggplant(src)
	new /obj/item/food/grown/potato(src)
	new /obj/item/food/grown/apple(src)
	new /obj/item/food/grown/corn(src)
	new /obj/item/food/grown/tomato(src)

/obj/item/storage/box/ingredients/american
	theme_name = "american"

/obj/item/storage/box/ingredients/american/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/potato(src)
		new /obj/item/food/grown/tomato(src)
		new /obj/item/food/grown/corn(src)
	new /obj/item/food/meatball(src)

/obj/item/storage/box/ingredients/fruity
	theme_name = "fruity"

/obj/item/storage/box/ingredients/fruity/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/apple(src)
		new /obj/item/food/grown/citrus/orange(src)
	new /obj/item/food/grown/citrus/lemon(src)
	new /obj/item/food/grown/citrus/lime(src)
	new /obj/item/food/grown/watermelon(src)

/obj/item/storage/box/ingredients/sweets
	theme_name = "sweets"

/obj/item/storage/box/ingredients/sweets/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/cherries(src)
		new /obj/item/food/grown/banana(src)
	new /obj/item/food/chocolatebar(src)
	new /obj/item/food/grown/cocoapod(src)
	new /obj/item/food/grown/apple(src)

/obj/item/storage/box/ingredients/delights
	theme_name = "delights"

/obj/item/storage/box/ingredients/delights/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/grown/potato/sweet(src)
		new /obj/item/food/grown/bluecherries(src)
	new /obj/item/food/grown/vanillapod(src)
	new /obj/item/food/grown/cocoapod(src)
	new /obj/item/food/grown/berries(src)

/obj/item/storage/box/ingredients/grains
	theme_name = "grains"

/obj/item/storage/box/ingredients/grains/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/food/grown/oat(src)
	new /obj/item/food/grown/wheat(src)
	new /obj/item/food/grown/cocoapod(src)
	new /obj/item/seeds/poppy(src)

/obj/item/storage/box/ingredients/carnivore
	theme_name = "carnivore"

/obj/item/storage/box/ingredients/carnivore/PopulateContents()
	new /obj/item/food/meat/slab/bear(src)
	new /obj/item/food/meat/slab/spider(src)
	new /obj/item/food/spidereggs(src)
	new /obj/item/food/fishmeat/carp(src)
	new /obj/item/food/meat/slab/xeno(src)
	new /obj/item/food/meat/slab/corgi(src)
	new /obj/item/food/meatball(src)

/obj/item/storage/box/ingredients/exotic
	theme_name = "exotic"

/obj/item/storage/box/ingredients/exotic/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/food/fishmeat/carp(src)
		new /obj/item/food/grown/soybeans(src)
		new /obj/item/food/grown/cabbage(src)
	new /obj/item/food/grown/chili(src)

/obj/item/storage/box/ingredients/random
	theme_name = "random"
	desc = "This box should not exist, contact the proper authorities."

/obj/item/storage/box/ingredients/random/Initialize()
	.=..()
	var/chosen_box = pick(subtypesof(/obj/item/storage/box/ingredients) - /obj/item/storage/box/ingredients/random)
	new chosen_box(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/skub
	desc = "It's skub."
	name = "skub"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("skubs")
	attack_verb_simple = list("skub")

/obj/item/skub/suicide_act(mob/living/user)
	user.visible_message(SPAN_SUICIDE("[user] has declared themself as anti-skub! The skub tears them apart!"))

	user.gib()
	playsound(src, 'sound/items/eatfood.ogg', 50, TRUE, -1)
	return MANUAL_SUICIDE

/obj/item/virgin_mary
	name = "\proper a picture of the virgin mary"
	desc = "A small, cheap icon depicting the virgin mother."
	icon = 'icons/obj/blackmarket.dmi'
	icon_state = "madonna"
	resistance_flags = FLAMMABLE
	///Has this item been used already.
	var/used_up = FALSE
	///List of mobs that have already been mobbed.
	var/static/list/mob_mobs = list()

#define NICKNAME_CAP (MAX_NAME_LEN/2)
/obj/item/virgin_mary/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(resistance_flags & ON_FIRE)
		return
	if(!burn_paper_product_attackby_check(W, user, TRUE))
		return
	if(used_up)
		return
	if(!isliving(user) || !user.mind) //A sentient mob needs to be burning it, ya cheezit.
		return
	var/mob/living/joe = user

	if(joe in mob_mobs) //Only one nickname fuckhead
		to_chat(joe, SPAN_WARNING("You have already been initiated into the mafioso life."))
		return

	to_chat(joe, SPAN_NOTICE("As you burn the picture, a nickname comes to mind..."))
	var/nickname = stripped_input(joe, "Pick a nickname", "Mafioso Nicknames", null, NICKNAME_CAP, TRUE)
	nickname = reject_bad_name(nickname, allow_numbers = FALSE, max_length = NICKNAME_CAP, ascii_only = TRUE)
	if(!nickname)
		return
	var/new_name
	var/space_position = findtext(joe.real_name, " ")
	if(space_position)//Can we find a space?
		new_name = "[copytext(joe.real_name, 1, space_position)] \"[nickname]\" [copytext(joe.real_name, space_position)]"
	else //Append otherwise
		new_name = "[joe.real_name] \"[nickname]\""
	joe.real_name = new_name
	used_up = TRUE
	mob_mobs += joe
	joe.say("My soul will burn like this saint if I betray my family. I enter alive and I will have to get out dead.", forced = /obj/item/virgin_mary)
	to_chat(joe, SPAN_USERDANGER("Being inducted into the mafia does not grant antagonist status."))

#undef NICKNAME_CAP

/obj/item/virgin_mary/suicide_act(mob/living/user)
	user.visible_message(SPAN_SUICIDE("[user] starts saying their Hail Mary's at a terrifying pace! It looks like [user.p_theyre()] trying to enter the afterlife!"))
	user.say("Hail Mary, full of grace, the Lord is with thee. Blessed are thou amongst women, and blessed is the fruit of thy womb, Jesus. Holy Mary, mother of God, pray for us sinners, now and at the hour of our death. Amen. ", forced = /obj/item/virgin_mary)
	addtimer(CALLBACK(src, .proc/manual_suicide, user), 75)
	addtimer(CALLBACK(user, /atom/movable/proc/say, "O my Mother, preserve me this day from mortal sin..."), 50)
	return MANUAL_SUICIDE

/obj/item/virgin_mary/proc/manual_suicide(mob/living/user)
	user.adjustOxyLoss(200)
	user.death(0)

// Bouquets
/obj/item/bouquet
	name = "mixed bouquet"
	desc = "A bouquet of sunflowers, lilies, and geraniums. How delightful."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "mixedbouquet"

/obj/item/bouquet/sunflower
	name = "sunflower bouquet"
	desc = "A bright bouquet of sunflowers."
	icon_state = "sunbouquet"

/obj/item/bouquet/poppy
	name = "poppy bouquet"
	desc = "A bouquet of poppies. You feel loved just looking at it."
	icon_state = "poppybouquet"

/obj/item/bouquet/rose
	name = "rose bouquet"
	desc = "A bouquet of roses. A bundle of love."
	icon_state = "rosebouquet"

/obj/item/gun_maintenance_supplies
	name = "gun maintenance supplies"
	desc = "plastic box containing gun maintenance supplies and spare parts. Use them on a Mosin Nagant to clean it."
	icon = 'icons/obj/storage.dmi'
	icon_state = "plasticbox"
	w_class = WEIGHT_CLASS_SMALL
