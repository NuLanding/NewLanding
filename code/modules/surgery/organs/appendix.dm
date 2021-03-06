/obj/item/organ/appendix
	name = "appendix"
	icon_state = "appendix"
	base_icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_APPENDIX
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/toxin/bad_food = 5)
	grind_results = list(/datum/reagent/toxin/bad_food = 5)
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	now_failing = SPAN_WARNING("An explosion of pain erupts in your lower right abdomen!")
	now_fixed = SPAN_INFO("The pain in your abdomen has subsided.")


/obj/item/organ/appendix/on_life(delta_time, times_fired)
	..()
	if(!(organ_flags & ORGAN_FAILING))
		return
	var/mob/living/carbon/organ_owner = owner
	if(organ_owner)
		organ_owner.adjustToxLoss(2 * delta_time, TRUE, TRUE) //forced to ensure people don't use it to gain tox as slime person

/obj/item/organ/appendix/get_availability(datum/species/owner_species)
	return !(TRAIT_NOHUNGER in owner_species.inherent_traits)

/obj/item/organ/appendix/Remove(mob/living/carbon/organ_owner, special = 0)
	update_appearance()
	..()

/obj/item/organ/appendix/Insert(mob/living/carbon/organ_owner, special = 0)
	..()
