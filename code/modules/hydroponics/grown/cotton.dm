/obj/item/seeds/cotton
	name = "pack of cotton seeds"
	desc = "A pack of seeds that'll grow into a cotton plant. Assistants make good free labor if neccesary."
	icon_state = "seed-cotton"
	species = "cotton"
	plantname = "Cotton"
	icon_harvest = "cotton-harvest"
	product = /obj/item/grown/cotton
	lifespan = 35
	endurance = 25
	maturation = 15
	production = 1
	yield = 2
	potency = 50
	instability = 15
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing.dmi'
	icon_dead = "cotton-dead"

/obj/item/grown/cotton
	seed = /obj/item/seeds/cotton
	name = "cotton bundle"
	desc = "A fluffy bundle of cotton."
	icon_state = "cotton"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 2
	throw_range = 3
	attack_verb_continuous = list("pomfs")
	attack_verb_simple = list("pomf")
	var/cotton_type = /obj/item/stack/sheet/cotton
	var/cotton_name = "raw cotton"

/obj/item/grown/cotton/attack_self(mob/user)
	user.show_message(SPAN_NOTICE("You pull some [cotton_name] out of the [name]!"), MSG_VISUAL)
	var/seed_modifier = 0
	if(seed)
		seed_modifier = round(seed.potency / 25)
	var/obj/item/stack/cotton = new cotton_type(user.loc, 1 + seed_modifier)
	var/old_cotton_amount = cotton.amount
	for(var/obj/item/stack/ST in user.loc)
		if(ST != cotton && istype(ST, cotton_type) && ST.amount < ST.max_amount)
			ST.attackby(cotton, user)
	if(cotton.amount > old_cotton_amount)
		to_chat(user, SPAN_NOTICE("You add the newly-formed [cotton_name] to the stack. It now contains [cotton.amount] [cotton_name]."))
	qdel(src)
