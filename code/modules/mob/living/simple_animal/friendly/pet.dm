/mob/living/simple_animal/pet
	icon = 'icons/mob/pets.dmi'
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	blood_volume = BLOOD_VOLUME_NORMAL
	var/unique_pet = FALSE // if the mob can be renamed

/mob/living/simple_animal/pet/Destroy()
	QDEL_NULL(access_card)
	return ..()

/mob/living/simple_animal/pet/gib()
	if(access_card)
		access_card.forceMove(drop_location())
		access_card = null
	return ..()
