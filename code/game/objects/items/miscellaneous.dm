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
