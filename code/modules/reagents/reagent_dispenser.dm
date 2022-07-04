/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/chemical_tanks.dmi'
	icon_state = "water"
	density = TRUE
	anchored = FALSE
	max_integrity = 300
	///In units, how much the dispenser can hold
	var/tank_volume = 1000
	///The ID of the reagent that the dispenser uses
	var/reagent_id = /datum/reagent/water
	///Can you turn this into a plumbing tank?
	var/can_be_tanked = TRUE
	///Is this source self-replenishing?
	var/refilling = FALSE

/obj/structure/reagent_dispensers/examine(mob/user)
	. = ..()
	if(can_be_tanked)
		. += SPAN_NOTICE("Use a sheet of iron to convert this into a plumbing-compatible tank.")

/obj/structure/reagent_dispensers/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(. && obj_integrity > 0)
		if(tank_volume && (damage_flag == BULLET || damage_flag == LASER))
			boom()

/obj/structure/reagent_dispensers/attackby(obj/item/W, mob/user, params)
	if(W.is_refillable())
		return FALSE //so we can refill them via their afterattack.
	else
		return ..()

/obj/structure/reagent_dispensers/Initialize()
	create_reagents(tank_volume, DRAINABLE | AMOUNT_VISIBLE)
	if(reagent_id)
		reagents.add_reagent(reagent_id, tank_volume)
	. = ..()

/obj/structure/reagent_dispensers/proc/boom()
	visible_message(SPAN_DANGER("\The [src] ruptures!"))
	chem_splash(loc, 5, list(reagents))
	qdel(src)

/obj/structure/reagent_dispensers/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			boom()
	else
		qdel(src)

/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A water tank."
	icon_state = "water"
