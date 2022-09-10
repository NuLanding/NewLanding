// Banana
/obj/item/seeds/banana
	name = "pack of banana seeds"
	desc = "They're seeds that grow into banana trees. When grown, keep away from clown."
	icon_state = "seed-banana"
	species = "banana"
	plantname = "Banana Tree"
	product = /obj/item/food/grown/banana
	lifespan = 50
	endurance = 30
	instability = 10
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "banana-dead"
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/banana = 0.1, /datum/reagent/potassium = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.02)
	graft_gene = /datum/plant_gene/trait/slip

/obj/item/food/grown/banana
	seed = /obj/item/seeds/banana
	name = "banana"
	desc = "It's an excellent prop for a clown."
	icon_state = "banana"
	inhand_icon_state = "banana"
	trash_type = /obj/item/grown/bananapeel
	bite_consumption_mod = 3
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/banana = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/bananahonk

/obj/item/food/grown/banana/generate_trash(atom/location)
	. = ..()
	var/obj/item/grown/bananapeel/peel = .
	if(istype(peel))
		peel.grind_results = list(/datum/reagent/medicine/coagulant/banana_peel = seed.potency * 0.2)
		peel.juice_results = list(/datum/reagent/medicine/coagulant/banana_peel = seed.potency * 0.2)

/obj/item/food/grown/banana/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] is aiming [src] at [user.p_them()]self! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
	sleep(25)
	if(!user)
		return (OXYLOSS)
	user.say("BANG!", forced = /datum/reagent/consumable/banana)
	sleep(25)
	if(!user)
		return (OXYLOSS)
	user.visible_message("<B>[user]</B> laughs so hard they begin to suffocate!")
	return (OXYLOSS)

//Banana Peel
/obj/item/grown/bananapeel
	seed = /obj/item/seeds/banana
	name = "banana peel"
	desc = "A peel from a banana."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	icon_state = "banana_peel"
	inhand_icon_state = "banana_peel"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/grown/bananapeel/Initialize(mapload)
	. = ..()
	if(prob(40))
		if(prob(60))
			icon_state = "[icon_state]_2"
		else
			icon_state = "[icon_state]_3"

/obj/item/grown/bananapeel/suicide_act(mob/user)
	user.visible_message(SPAN_SUICIDE("[user] is deliberately slipping on [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/misc/slip.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

// Other
/obj/item/grown/bananapeel/specialpeel     //used by /obj/item/clothing/shoes/clown_shoes/banana_shoes
	name = "synthesized banana peel"
	desc = "A synthetic banana peel."

/obj/item/grown/bananapeel/specialpeel/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 40)
