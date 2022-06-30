/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon_state = "toolbox_default"
	inhand_icon_state = "toolbox_default"
	lefthand_file = 'icons/mob/inhands/equipment/toolbox_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/toolbox_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 12
	throwforce = 12
	throw_speed = 2
	throw_range = 7
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron = 500)
	attack_verb_continuous = list("robusts")
	attack_verb_simple = list("robust")
	hitsound = 'sound/weapons/smash.ogg'
	drop_sound = 'sound/items/handling/toolbox_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbox_pickup.ogg'
	material_flags = MATERIAL_COLOR
	var/latches = "single_latch"
	var/has_latches = TRUE
	wound_bonus = 5

/obj/item/storage/toolbox/Initialize()
	. = ..()
	if(has_latches)
		if(prob(10))
			latches = "double_latch"
			if(prob(1))
				latches = "triple_latch"
	update_appearance()

/obj/item/storage/toolbox/update_overlays()
	. = ..()
	if(has_latches)
		. += latches


/obj/item/storage/toolbox/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] robusts [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	inhand_icon_state = "toolbox_red"
	material_flags = NONE

/obj/item/storage/toolbox/emergency/PopulateContents()
	new /obj/item/crowbar/red(src)
	new /obj/item/weldingtool/mini(src)
	new /obj/item/extinguisher/mini(src)
	switch(rand(1,3))
		if(1)
			new /obj/item/flashlight(src)
		if(2)
			new /obj/item/flashlight/glowstick(src)
		if(3)
			new /obj/item/flashlight/flare(src)

/obj/item/storage/toolbox/emergency/old
	name = "rusty red toolbox"
	icon_state = "toolbox_red_old"
	has_latches = FALSE
	material_flags = NONE

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	inhand_icon_state = "toolbox_blue"
	material_flags = NONE
	/// If FALSE, someone with a ensouled soulstone can sacrifice a spirit to change the sprite of this toolbox.
	var/has_soul = FALSE

/obj/item/storage/toolbox/mechanical/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)

/obj/item/storage/toolbox/mechanical/old
	name = "rusty blue toolbox"
	icon_state = "toolbox_blue_old"
	has_latches = FALSE
	has_soul = TRUE

/obj/item/storage/toolbox/mechanical/old/heirloom
	name = "toolbox" //this will be named "X family toolbox"
	desc = "It's seen better days."
	force = 5
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/toolbox/mechanical/old/heirloom/PopulateContents()
	return

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	inhand_icon_state = "toolbox_yellow"
	material_flags = NONE

/obj/item/storage/toolbox/electrical/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wirecutters(src)
	new /obj/item/t_scanner(src)
	new /obj/item/crowbar(src)

/obj/item/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	inhand_icon_state = "toolbox_syndi"
	force = 15
	throwforce = 18
	material_flags = NONE

/obj/item/storage/toolbox/syndicate/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/toolbox/syndicate/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/wirecutters(src, "red")
	new /obj/item/multitool(src)

/obj/item/storage/toolbox/artistic
	name = "artistic toolbox"
	desc = "A toolbox painted bright green. Why anyone would store art supplies in a toolbox is beyond you, but it has plenty of extra space."
	icon_state = "green"
	inhand_icon_state = "artistic_toolbox"
	w_class = WEIGHT_CLASS_GIGANTIC //Holds more than a regular toolbox!
	material_flags = NONE

/obj/item/storage/toolbox/artistic/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 20
	STR.max_items = 10

/obj/item/storage/toolbox/artistic/PopulateContents()
	new /obj/item/storage/crayons(src)
	new /obj/item/crowbar(src)

/obj/item/storage/toolbox/ammo
	name = "ammo box"
	desc = "It contains a few clips."
	icon_state = "ammobox"
	inhand_icon_state = "ammobox"
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound =  'sound/items/handling/ammobox_pickup.ogg'

/obj/item/storage/toolbox/ammo/PopulateContents()
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)
	new /obj/item/ammo_box/a762(src)

/obj/item/storage/toolbox/maint_kit
	name = "gun maintenance kit"
	desc = "It contains some gun maintenance supplies"
	icon_state = "maint_kit"
	inhand_icon_state = "ammobox"
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound = 'sound/items/handling/ammobox_pickup.ogg'

/obj/item/storage/toolbox/maint_kit/PopulateContents()
	new /obj/item/gun_maintenance_supplies(src)
	new /obj/item/gun_maintenance_supplies(src)
	new /obj/item/gun_maintenance_supplies(src)

/obj/item/storage/toolbox/infiltrator
	name = "insidious case"
	desc = "Bearing the emblem of the Syndicate, this case contains a full infiltrator stealth suit, and has enough room to fit weaponry if necessary."
	icon_state = "infiltrator_case"
	inhand_icon_state = "infiltrator_case"
	force = 15
	throwforce = 18
	w_class = WEIGHT_CLASS_NORMAL
	has_latches = FALSE

/obj/item/storage/toolbox/infiltrator/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box
		))


/obj/item/storage/toolbox/haunted
	name = "old toolbox"
	custom_materials = list(/datum/material/hauntium = 500)



