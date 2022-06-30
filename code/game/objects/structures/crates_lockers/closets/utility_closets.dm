/* Utility Closets
 * Contains:
 * Emergency Closet
 * Fire Closet
 * Tool Closet
 * Radiation Closet
 * Bombsuit Closet
 * Hydrant
 * First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "emergency closet"
	desc = "It's a storage unit for emergency breath masks and O2 tanks."
	icon_state = "emergency"

/obj/structure/closet/emcloset/anchored
	anchored = TRUE

/obj/structure/closet/emcloset/PopulateContents()
	..()

	if (prob(40))
		new /obj/item/storage/toolbox/emergency(src)

	switch (pickweight(list("small" = 35, "aid" = 30, "tank" = 20, "both" = 10, "nothing" = 4, "delete" = 1)))

		if ("nothing")
			// doot

		// teehee
		if ("delete")
			qdel(src)

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "fire"

/obj/structure/closet/firecloset/PopulateContents()
	..()
	new /obj/item/extinguisher(src)

/obj/structure/closet/firecloset/full/PopulateContents()
	new /obj/item/flashlight(src)
	new /obj/item/extinguisher(src)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/toolcloset/PopulateContents()
	..()
	if(prob(70))
		new /obj/item/flashlight(src)
	if(prob(70))
		new /obj/item/screwdriver(src)
	if(prob(70))
		new /obj/item/wrench(src)
	if(prob(70))
		new /obj/item/weldingtool(src)
	if(prob(70))
		new /obj/item/crowbar(src)
	if(prob(70))
		new /obj/item/wirecutters(src)
	if(prob(70))
		new /obj/item/t_scanner(src)
	if(prob(20))
		new /obj/item/storage/belt/utility(src)
	if(prob(20))
		new /obj/item/multitool(src)


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/PopulateContents()
	..()
	new /obj/item/geiger_counter(src)
/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bomb"

/*
 * Ammunition
 */
/obj/structure/closet/ammunitionlocker
	name = "ammunition locker"

/obj/structure/closet/ammunitionlocker/PopulateContents()
	..()
	for(var/i in 1 to 8)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
