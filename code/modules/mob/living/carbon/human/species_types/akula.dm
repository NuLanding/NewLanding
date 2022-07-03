/datum/species/akula
	name = "Akula"
	id = "akula"
	flavor_text = "An aquatic species, most having a big similarity to sharks."
	default_color = "444"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAS_FLESH,HAS_BONE,HAIR)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = GROSS | MEAT | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_icon = 'icons/mob/species/akula_parts_greyscale.dmi'
	organs = list(
		ORGAN_SLOT_HAIR = /obj/item/organ/hair/head,
		ORGAN_SLOT_FACIAL_HAIR = /obj/item/organ/hair/facial,
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/akula,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/akula,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/akula,
		)
	organ_customizers = list(
		/datum/organ_customizer/eyes/humanoid,
		/datum/organ_customizer/hair/head/humanoid,
		/datum/organ_customizer/hair/facial/humanoid,
		/datum/organ_customizer/tail/akula,
		/datum/organ_customizer/snout/akula,
		/datum/organ_customizer/ears/akula,
		)

/datum/species/akula/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/random = rand(1,5)
	//Choose from a variety of sharkish colors, with a whiter secondary and tertiary
	switch(random)
		if(1)
			main_color = "668899"
			second_color = "BBCCDD"
		if(2)
			main_color = "334455"
			second_color = "DDDDEE"
		if(3)
			main_color = "445566"
			second_color = "DDDDEE"
		if(4)
			main_color = "666655"
			second_color = "DDDDEE"
		if(5)
			main_color = "444444"
			second_color = "DDDDEE"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = second_color
	return returned

/datum/species/akula/get_random_body_markings(list/passed_features)
	var/name = "Shark"
	var/datum/body_marking_set/BMS = GLOB.body_marking_sets[name]
	var/list/markings = list()
	if(BMS)
		markings = assemble_body_markings_from_set(BMS, passed_features, src)
	return markings
