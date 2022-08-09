//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/janitor.dmi'
	inhand_icon = 'icons/mob/inhands/misc/food_inhand.dmi'
	desc = "This is rubbish."
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	item_flags = NOBLUDGEON

/obj/item/trash/Initialize(mapload)
	var/turf/T = get_turf(src)
	if(T && is_station_level(T))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)
	return ..()

/obj/item/trash/Destroy()
	var/turf/T = get_turf(src)
	if(T && is_station_level(T))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)
	return ..()

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	resistance_flags = NONE

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"

