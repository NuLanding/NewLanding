/obj/item/food/icecreamsandwich
	name = "icecream sandwich"
	desc = "Portable Ice-cream in its own packaging."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "icecreamsandwich"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/ice = 4)
	tastes = list("ice cream" = 1)
	foodtypes = GRAIN | DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/strawberryicecreamsandwich
	name = "strawberry ice cream sandwich"
	desc = "Portable ice-cream in its own packaging of the strawberry variety."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "strawberryicecreamsandwich"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/ice = 4)
	tastes = list("ice cream" = 2, "berry" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD


/obj/item/food/spacefreezy
	name = "space freezy"
	desc = "The best icecream in space."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "spacefreezy"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(/datum/reagent/consumable/nutriment = 8, /datum/reagent/consumable/bluecherryjelly = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("blue cherries" = 2, "ice cream" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/spacefreezy/MakeEdible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder)

/obj/item/food/sundae
	name = "sundae"
	desc = "A classic dessert."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "sundae"
	w_class = WEIGHT_CLASS_SMALL
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/banana = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("ice cream" = 1, "banana" = 1)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/sundae/MakeEdible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder, y_offset = -2, sweetener = /datum/reagent/consumable/caramel)

/obj/item/food/honkdae
	name = "honkdae"
	desc = "The clown's favorite dessert."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "honkdae"
	w_class = WEIGHT_CLASS_SMALL
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/banana = 10, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("ice cream" = 1, "banana" = 1, "a bad joke" = 1)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/honkdae/MakeEdible()
	. = ..()
	AddComponent(/datum/component/ice_cream_holder, y_offset = -2) //The sugar will react with the banana forming laughter. Honk!

/obj/item/food/popsicle
	name = "bug popsicle"
	desc = "Mmmm, this should not exist."
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "popsicle_stick_s"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 2, /datum/reagent/consumable/sugar = 4)
	tastes = list("beetlejuice")
	trash_type = /obj/item/popsicle_stick
	w_class = WEIGHT_CLASS_SMALL
	var/overlay_state = "creamsicle_o" //This is the edible part of the popsicle.
	var/bite_states = 4 //This value value is used for correctly setting the bite_consumption to ensure every bite changes the sprite. Do not set to zero.
	var/bitecount = 0
	foodtypes = DAIRY | SUGAR
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/popsicle/Initialize()
	. = ..()
	bite_consumption = reagents.total_volume / bite_states
	update_icon() // make sure the popsicle overlay is primed so it's not just a stick until you start eating it

/obj/item/food/popsicle/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				microwaved_type = microwaved_type,\
				junkiness = junkiness,\
				after_eat = CALLBACK(src, .proc/after_bite))


/obj/item/food/popsicle/update_overlays()
	. = ..()
	if(!bitecount)
		. += initial(overlay_state)
		return
	. += "[initial(overlay_state)]_[min(bitecount, 3)]"

/obj/item/food/popsicle/proc/after_bite(mob/living/eater, mob/living/feeder, bitecount)
	src.bitecount = bitecount
	update_appearance()

/obj/item/popsicle_stick
	name = "popsicle stick"
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "popsicle_stick"
	desc = "This humble little stick usually carries a frozen treat, at the moment it seems freed from this Atlassian burden."
	custom_materials = list(/datum/material/wood=20)
	w_class = WEIGHT_CLASS_TINY
	force = 0

/obj/item/food/popsicle/creamsicle_orange
	name = "orange creamsicle"
	desc = "A classic orange creamsicle. A sunny frozen treat."
	food_reagents = list(/datum/reagent/consumable/orangejuice = 4, /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 2, /datum/reagent/consumable/sugar = 4)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/popsicle/creamsicle_berry
	name = "berry creamsicle"
	desc = "A vibrant berry creamsicle. A berry good frozen treat."
	food_reagents = list(/datum/reagent/consumable/berryjuice = 4, /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 2, /datum/reagent/consumable/sugar = 4)
	overlay_state = "creamsicle_m"
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/popsicle/jumbo
	name = "jumbo icecream"
	desc = "A luxurious icecream covered in rich chocolate. It seems smaller than you remember it being."
	food_reagents = list(/datum/reagent/consumable/hot_coco = 4, /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 3, /datum/reagent/consumable/sugar = 2)
	overlay_state = "jumbo"

/obj/item/food/popsicle/nogga_black
	name = "nogga black"
	desc = "A salty licorice icecream recently reintroduced due to all records of the controversy being lost to time. Those who cannot remember the past are doomed to repeat it."
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/salt = 1,  /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)
	tastes = list("salty liquorice")
	overlay_state = "nogga_black"

/obj/item/food/cornuto
	name = "cornuto"
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/food/frozen_treats.dmi'
	icon_state = "cornuto"
	desc = "A neapolitan vanilla and chocolate icecream cone. It menaces with a sprinkling of caramelized nuts."
	tastes = list("chopped hazelnuts", "waffle")
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/hot_coco = 4, /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 4, /datum/reagent/consumable/sugar = 2)
	foodtypes = DAIRY | SUGAR
