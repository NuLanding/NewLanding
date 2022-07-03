/obj/item/organ/eyes
	name = BODY_ZONE_PRECISE_EYES
	icon_state = "eyeballs"
	desc = "I see you!"
	zone = BODY_ZONE_PRECISE_EYES
	slot = ORGAN_SLOT_EYES
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY
	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD //half the normal health max since we go blind at 30, a permanent blindness at 50 therefore makes sense unless medicine is administered
	high_threshold = 0.3 * STANDARD_ORGAN_THRESHOLD //threshold at 30
	low_threshold = 0.2 * STANDARD_ORGAN_THRESHOLD //threshold at 20

	low_threshold_passed = SPAN_INFO("Distant objects become somewhat less tangible.")
	high_threshold_passed = SPAN_INFO("Everything starts to look a lot less clear.")
	now_failing = SPAN_WARNING("Darkness envelopes you, as your eyes go blind!")
	now_fixed = SPAN_INFO("Color and shapes are once again perceivable.")
	high_threshold_cleared = SPAN_INFO("Your vision functions passably once more.")
	low_threshold_cleared = SPAN_INFO("Your vision is cleared of any ailment.")

	visible_organ = TRUE
	accessory_type = /datum/sprite_accessory/eyes/humanoid
	accessory_colors = "#FFFFFF#FFFFFF"
	organ_dna_type = /datum/organ_dna/eyes

	var/sight_flags = 0
	/// changes how the eyes overlay is applied, makes it apply over the lighting layer
	var/overlay_ignore_lighting = FALSE
	var/see_in_dark = 2
	var/tint = 0
	var/eye_icon_state = "eyes"
	var/old_eye_color = "fff"
	var/flash_protect = FLASH_PROTECTION_NONE
	var/see_invisible = SEE_INVISIBLE_LIVING
	var/lighting_alpha
	var/no_glasses
	var/damaged = FALSE //damaged indicates that our eyes are undergoing some level of negative effect

	var/eye_color = "#FFFFFF"
	var/heterochromia = FALSE
	var/second_color = "#FFFFFF"

/obj/item/organ/eyes/randomize_appearance()
	eye_color = pick(EYE_COLORS_LIST)
	if(prob(5))
		heterochromia = TRUE
		second_color = pick(EYE_COLORS_LIST)
	update_accessory_colors()

/obj/item/organ/eyes/update_accessory_colors()
	var/list/colors_list = list()
	colors_list += eye_color
	if(heterochromia)
		colors_list += second_color
	else
		colors_list += eye_color
	accessory_colors = color_list_to_string(colors_list)

/obj/item/organ/eyes/imprint_organ_dna(datum/organ_dna/organ_dna)
	. = ..()
	var/datum/organ_dna/eyes/eyes_dna = organ_dna
	eyes_dna.eye_color = eye_color
	eyes_dna.heterochromia = heterochromia
	eyes_dna.second_color = second_color

/obj/item/organ/eyes/Insert(mob/living/carbon/eye_owner, special = FALSE, drop_if_replaced = FALSE, initialising)
	. = ..()
	if(ishuman(eye_owner))
		var/mob/living/carbon/human/human_owner = eye_owner
		if(HAS_TRAIT(human_owner, TRAIT_NIGHT_VISION) && !lighting_alpha)
			lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	eye_owner.update_tint()
	owner.update_sight()
	if(eye_owner.has_dna() && ishuman(eye_owner))
		eye_owner.dna.species.handle_body(eye_owner) //updates eye icon

/obj/item/organ/eyes/proc/refresh()
	if(ishuman(owner))
		var/mob/living/carbon/human/affected_human = owner
		if(HAS_TRAIT(affected_human, TRAIT_NIGHT_VISION) && !lighting_alpha)
			lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	owner.update_tint()
	owner.update_sight()
	if(owner.has_dna() && ishuman(owner))
		var/mob/living/carbon/human/affected_human = owner
		affected_human.dna.species.handle_body(affected_human) //updates eye icon


/obj/item/organ/eyes/Remove(mob/living/carbon/eye_owner, special = 0)
	..()
	if(ishuman(eye_owner) && eye_color)
		var/mob/living/carbon/human/human_owner = eye_owner
		human_owner.regenerate_icons()
	eye_owner.cure_blind(EYE_DAMAGE)
	eye_owner.cure_nearsighted(EYE_DAMAGE)
	eye_owner.set_blindness(0)
	eye_owner.set_blurriness(0)
	eye_owner.clear_fullscreen("eye_damage", 0)
	eye_owner.update_sight()


/obj/item/organ/eyes/on_life(delta_time, times_fired)
	..()
	var/mob/living/carbon/eye_owner = owner
	//since we can repair fully damaged eyes, check if healing has occurred
	if((organ_flags & ORGAN_FAILING) && (damage < maxHealth))
		organ_flags &= ~ORGAN_FAILING
		eye_owner.cure_blind(EYE_DAMAGE)
	//various degrees of "oh fuck my eyes", from "point a laser at your eye" to "staring at the Sun" intensities
	if(damage > 20)
		damaged = TRUE
		if((organ_flags & ORGAN_FAILING))
			eye_owner.become_blind(EYE_DAMAGE)
		else if(damage > 30)
			eye_owner.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, HUD_IMPAIRMENT_HALF_BLIND)
		else
			eye_owner.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, HUD_IMPAIRMENT_NEARSIGHT)
	//called once since we don't want to keep clearing the screen of eye damage for people who are below 20 damage
	else if(damaged)
		damaged = FALSE
		eye_owner.clear_fullscreen("eye_damage")
	return

