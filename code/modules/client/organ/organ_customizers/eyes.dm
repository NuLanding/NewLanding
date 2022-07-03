/datum/organ_customizer/eyes
	abstract_type = /datum/organ_customizer/eyes
	name = "Eyes"

/datum/organ_choice/eyes
	abstract_type = /datum/organ_choice/eyes
	name = "Eyes"
	organ_type = /obj/item/organ/eyes
	organ_slot = ORGAN_SLOT_EYES
	organ_entry_type = /datum/organ_entry/eyes
	organ_dna_type = /datum/organ_dna/eyes
	allows_accessory_color_customization = FALSE //Customized through eye color
	var/allows_heterochromia = TRUE

/datum/organ_choice/eyes/validate_entry(datum/preferences/prefs, datum/organ_entry/entry)
	..()
	var/datum/organ_entry/eyes/eyes_entry = entry
	eyes_entry.eye_color = sanitize_hexcolor(eyes_entry.eye_color, 6, TRUE, initial(eyes_entry.eye_color))
	eyes_entry.second_color = sanitize_hexcolor(eyes_entry.second_color, 6, TRUE, initial(eyes_entry.second_color))
	eyes_entry.heterochromia = sanitize_integer(eyes_entry.heterochromia, FALSE, TRUE, initial(eyes_entry.heterochromia))

/datum/organ_choice/eyes/imprint_organ_dna(datum/organ_dna/organ_dna, datum/organ_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/eyes/eyes_dna = organ_dna
	var/datum/organ_entry/eyes/eyes_entry = entry
	eyes_dna.eye_color = eyes_entry.eye_color
	if(allows_heterochromia)
		eyes_dna.heterochromia  = eyes_entry.heterochromia
		eyes_dna.second_color = eyes_entry.second_color

/datum/organ_choice/eyes/generate_pref_choices(list/dat, datum/preferences/prefs, datum/organ_entry/entry, customizer_type)
	..()
	var/datum/organ_entry/eyes/eyes_entry = entry
	dat += "<br>Eye Color: <a href='?_src_=prefs;task=change_organ;customizer=[customizer_type];organ=eye_color''><span class='color_holder_box' style='background-color:[eyes_entry.eye_color]'></span></a>"
	if(allows_heterochromia)
		dat += "<br>Heterochromia: <a href='?_src_=prefs;task=change_organ;customizer=[customizer_type];organ=heterochromia'>[eyes_entry.heterochromia ? "Yes" : "No"]</a>"
		if(eyes_entry.heterochromia)
			dat += "<br>Second Color: <a href='?_src_=prefs;task=change_organ;customizer=[customizer_type];organ=second_eye_color''><span class='color_holder_box' style='background-color:[eyes_entry.second_color]'></span></a>"

/datum/organ_choice/eyes/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/organ_entry/entry, customizer_type)
	..()
	var/datum/organ_entry/eyes/eyes_entry = entry
	switch(href_list["organ"])
		if("eye_color")
			var/new_color = input(user, "Choose your eyes color:", "Character Preference", eyes_entry.eye_color) as color|null
			if(!new_color)
				return
			eyes_entry.eye_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("heterochromia")
			if(!allows_heterochromia)
				return
			eyes_entry.heterochromia = !eyes_entry.heterochromia
		if("second_eye_color")
			if(!allows_heterochromia)
				return
			var/new_color = input(user, "Choose your eyes' secondary color:", "Character Preference", eyes_entry.second_color) as color|null
			if(!new_color)
				return
			eyes_entry.second_color = sanitize_hexcolor(new_color, 6, TRUE)

/datum/organ_entry/eyes
	var/eye_color = "#FFFFFF"
	var/heterochromia = FALSE
	var/second_color = "#FFFFFF"

/datum/organ_customizer/eyes/humanoid
	organ_choices = list(/datum/organ_choice/eyes/humanoid)
	default_choice = /datum/organ_choice/eyes/humanoid

/datum/organ_choice/eyes/humanoid
