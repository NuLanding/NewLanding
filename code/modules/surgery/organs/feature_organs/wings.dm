/obj/item/organ/wings
	name = "wings"
	desc = "A pair of wings. Those may or may not allow you to fly... or at the very least flap."
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_WINGS
	///Whether the wings should grant flight on insertion.
	var/unconditional_flight
	///What species get flights thanks to those wings. Important for moth wings
	var/list/flight_for_species
	///Whether a wing can be opened by the *wing emote. The sprite use a "_open" suffix, before their layer
	var/can_open
	///Whether an openable wing is currently opened
	var/is_open
	///Whether the owner of wings has flight thanks to the wings
	var/granted_flight

/obj/item/organ/wings/is_visible_on_owner()
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.wear_suit)
		if(human_owner.try_hide_mutant_parts)
			return FALSE
		if(human_owner.wear_suit.flags_inv & HIDEJUMPSUIT)
			return FALSE
	return TRUE

//TODO: Well you know what this flight stuff is a bit complicated and hardcoded, this is enough for now

/obj/item/organ/wings/moth
	name = "moth wings"
	desc = "A pair of fuzzy moth wings."
	flight_for_species = list("moth")

/obj/item/organ/wings/mammal
	name = "mammal wings"

/obj/item/organ/wings/flight
	unconditional_flight = TRUE
	can_open = TRUE

/obj/item/organ/wings/flight/angel
	name = "angel wings"
	desc = "A pair of magnificent, feathery wings. They look strong enough to lift you up in the air."

/obj/item/organ/wings/flight/dragon
	name = "dragon wings"
	desc = "A pair of intimidating, membranous wings. They look strong enough to lift you up in the air."

/obj/item/organ/wings/flight/megamoth
	name = "megamoth wings"
	desc = "A pair of horrifyingly large, fuzzy wings. They look strong enough to lift you up in the air."
