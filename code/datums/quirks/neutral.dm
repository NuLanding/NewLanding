//traits with no real impact that can be taken freely
//MAKE SURE THESE DO NOT MAJORLY IMPACT GAMEPLAY. those should be positive or negative traits.

/datum/quirk/extrovert
	name = "Extrovert"
	desc = "You are energized by talking to others, and enjoy spending your free time in the bar."
	value = 0
	mob_trait = TRAIT_EXTROVERT
	gain_text = SPAN_NOTICE("You feel like hanging out with other people.")
	lose_text = SPAN_DANGER("You feel like you're over the bar scene.")
	medical_record_text = "Patient will not shut the hell up."

/datum/quirk/introvert
	name = "Introvert"
	desc = "You are energized by having time to yourself, and enjoy spending your free time in the library."
	value = 0
	mob_trait = TRAIT_INTROVERT
	gain_text = SPAN_NOTICE("You feel like reading a good book quietly.")
	lose_text = SPAN_DANGER("You feel like libraries are boring.")
	medical_record_text = "Patient doesn't seem to say much."

/datum/quirk/no_taste
	name = "Ageusia"
	desc = "You can't taste anything! Toxic food will still poison you."
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = SPAN_NOTICE("You can't taste anything!")
	lose_text = SPAN_NOTICE("You can taste again!")
	medical_record_text = "Patient suffers from ageusia and is incapable of tasting food or reagents."

/datum/quirk/vegetarian
	name = "Vegetarian"
	desc = "You find the idea of eating meat morally and physically repulsive."
	value = 0
	gain_text = SPAN_NOTICE("You feel repulsion at the idea of eating meat.")
	lose_text = SPAN_NOTICE("You feel like eating meat isn't that bad.")
	medical_record_text = "Patient reports a vegetarian diet."

/datum/quirk/vegetarian/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food &= ~MEAT
	species.disliked_food |= MEAT

/datum/quirk/vegetarian/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder

	var/datum/species/species = human_holder.dna.species
	if(initial(species.liked_food) & MEAT)
		species.liked_food |= MEAT
	if(!(initial(species.disliked_food) & MEAT))
		species.disliked_food &= ~MEAT

/datum/quirk/snob
	name = "Snob"
	desc = "You care about the finer things, if a room doesn't look nice its just not really worth it, is it?"
	value = 0
	gain_text = SPAN_NOTICE("You feel like you understand what things should look like.")
	lose_text = SPAN_NOTICE("Well who cares about deco anyways?")
	medical_record_text = "Patient seems to be rather stuck up."
	mob_trait = TRAIT_SNOB

/datum/quirk/pineapple_liker
	name = "Ananas Affinity"
	desc = "You find yourself greatly enjoying fruits of the ananas genus. You can't seem to ever get enough of their sweet goodness!"
	value = 0
	gain_text = SPAN_NOTICE("You feel an intense craving for pineapple.")
	lose_text = SPAN_NOTICE("Your feelings towards pineapples seem to return to a lukewarm state.")
	medical_record_text = "Patient demonstrates a pathological love of pineapple."

/datum/quirk/pineapple_liker/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food &= ~PINEAPPLE

/datum/quirk/pineapple_hater
	name = "Ananas Aversion"
	desc = "You find yourself greatly detesting fruits of the ananas genus. Serious, how the hell can anyone say these things are good? And what kind of madman would even dare putting it on a pizza!?"
	value = 0
	gain_text = SPAN_NOTICE("You find yourself pondering what kind of idiot actually enjoys pineapples...")
	lose_text = SPAN_NOTICE("Your feelings towards pineapples seem to return to a lukewarm state.")
	medical_record_text = "Patient is correct to think that pineapple is disgusting."

/datum/quirk/pineapple_hater/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.disliked_food |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.disliked_food &= ~PINEAPPLE

/datum/quirk/deviant_tastes
	name = "Deviant Tastes"
	desc = "You dislike food that most people enjoy, and find delicious what they don't."
	value = 0
	gain_text = SPAN_NOTICE("You start craving something that tastes strange.")
	lose_text = SPAN_NOTICE("You feel like eating normal food again.")
	medical_record_text = "Patient demonstrates irregular nutrition preferences."

/datum/quirk/deviant_tastes/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	var/liked = species.liked_food
	species.liked_food = species.disliked_food
	species.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/species/species = human_holder.dna.species
	species.liked_food = initial(species.liked_food)
	species.disliked_food = initial(species.disliked_food)

/datum/quirk/monochromatic
	name = "Monochromacy"
	desc = "You suffer from full colorblindness, and perceive nearly the entire world in blacks and whites."
	value = 0
	medical_record_text = "Patient is afflicted with almost complete color blindness."

/datum/quirk/monochromatic/add()
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/remove()
	quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/item_quirk/colorist
	name = "Colorist"
	desc = "You like carrying around a hair dye spray to quickly apply color patterns to your hair."
	value = 0
	medical_record_text = "Patient enjoys dyeing their hair with pretty colors."

/datum/quirk/item_quirk/colorist/add_unique()
	give_item_to_holder(/obj/item/dyespray, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
