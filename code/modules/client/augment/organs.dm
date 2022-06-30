/datum/augment_item/organ
	category = AUGMENT_CATEGORY_ORGANS

/datum/augment_item/organ/apply(mob/living/carbon/human/H, character_setup = FALSE, datum/preferences/prefs)
	if(character_setup)
		return
	var/obj/item/organ/new_organ = new path()
	new_organ.Insert(H,FALSE,FALSE)

//HEARTS
/datum/augment_item/organ/heart
	slot = AUGMENT_SLOT_HEART

//LUNGS
/datum/augment_item/organ/lungs
	slot = AUGMENT_SLOT_LUNGS

//LIVERS
/datum/augment_item/organ/liver
	slot = AUGMENT_SLOT_LIVER

//STOMACHES
/datum/augment_item/organ/stomach
	slot = AUGMENT_SLOT_STOMACH

//EYES
/datum/augment_item/organ/eyes
	slot = AUGMENT_SLOT_EYES

//TONGUES
/datum/augment_item/organ/tongue
	slot = AUGMENT_SLOT_TONGUE

/datum/augment_item/organ/tongue/normal
	name = "Organic tongue"
	path = /obj/item/organ/tongue

/datum/augment_item/organ/tongue/forked
	name = "Forked tongue"
	path = /obj/item/organ/tongue/lizard
