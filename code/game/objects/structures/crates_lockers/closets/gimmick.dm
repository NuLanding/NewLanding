/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	max_integrity = 70

/obj/structure/closet/acloset
	name = "strange closet"
	desc = "It looks alien!"
	icon_state = "alien"


/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "It's a storage unit for things that have no right being here."
	icon_state = "syndicate"

/obj/structure/closet/mini_fridge
	name = "grimy mini-fridge"
	desc = "A small contraption designed to imbue a few drinks with a pleasant chill. This antiquated unit however seems to serve no purpose other than keeping the roaches company."
	icon_state = "mini_fridge"
	icon_welded = "welded_small"
	max_mob_size = MOB_SIZE_SMALL
	storage_capacity = 7

/obj/structure/closet/mini_fridge/PopulateContents()
	. = ..()
	new /obj/effect/spawner/lootdrop/refreshing_beverage(src)
	new /obj/effect/spawner/lootdrop/refreshing_beverage(src)
	if(prob(50))
		new /obj/effect/spawner/lootdrop/refreshing_beverage(src)
	if(prob(40))
		new /obj/item/food/pizzaslice/moldy(src)
	else if(prob(30))
		new /obj/item/food/syndicake(src)
