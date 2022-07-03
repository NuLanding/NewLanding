/datum/species/vulpkanin
	name = "Vulpkanin"
	id = "vulpkanin"
	flavor_text = "A fully-furred bipedal fox. Most enjoy meats, and fried foods, but will eat just about anything."
	default_color = "444"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAS_FLESH,HAS_BONE,HAIR)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	liked_food = GROSS | MEAT | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_icon = 'icons/mob/species/mammal_parts_greyscale.dmi'
	limbs_id = "mammal"
	organs = list(
		ORGAN_SLOT_HAIR = /obj/item/organ/hair/head,
		ORGAN_SLOT_FACIAL_HAIR = /obj/item/organ/hair/facial,
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/vulpkanin,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/vulpkanin,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/vulpkanin,
		)
	organ_customizers = list(
		/datum/organ_customizer/eyes/humanoid,
		/datum/organ_customizer/hair/head/humanoid,
		/datum/organ_customizer/hair/facial/humanoid,
		/datum/organ_customizer/tail/vulpkanin,
		/datum/organ_customizer/snout/vulpkanin,
		/datum/organ_customizer/ears/vulpkanin,
		)

/datum/species/vulpkanin/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/random = rand(1,5)
	//Choose from a variety of mostly brightish, animal, matching colors
	switch(random)
		if(1)
			main_color = "FFAA00"
			second_color = "FFDD44"
		if(2)
			main_color = "FF8833"
			second_color = "FFAA33"
		if(3)
			main_color = "FFCC22"
			second_color = "FFDD88"
		if(4)
			main_color = "FF8800"
			second_color = "FFFFFF"
		if(5)
			main_color = "999999"
			second_color = "EEEEEE"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = second_color
	return returned

/datum/species/vulpkanin/get_random_body_markings(list/passed_features)
	var/name = pick("Fox", "Floof", "Floofer")
	var/datum/body_marking_set/BMS = GLOB.body_marking_sets[name]
	var/list/markings = list()
	if(BMS)
		markings = assemble_body_markings_from_set(BMS, passed_features, src)
	return markings

/datum/species/vulpkanin/random_name(gender,unique,lastname)
	var/randname
	if(gender == MALE)
		randname = pick(GLOB.first_names_male_vulp)
	else
		randname = pick(GLOB.first_names_female_vulp)

	if(lastname)
		randname += " [lastname]"
	else
		randname += " [pick(GLOB.last_names_vulp)]"

	return randname
