/obj/item/organ/ears
	name = "ears"
	icon_state = "ears"
	desc = "There are three parts to the ear. Inner, middle and outer. Only one of these parts should be normally visible."
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EARS
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = SPAN_INFO("Your ears begin to resonate with an internal ring sometimes.")
	now_failing = SPAN_WARNING("You are unable to hear at all!")
	now_fixed = SPAN_INFO("Noise slowly begins filling your ears once more.")
	low_threshold_cleared = SPAN_INFO("The ringing in your ears has died down.")

	// `deaf` measures "ticks" of deafness. While > 0, the person is unable
	// to hear anything.
	var/deaf = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	//Resistance against loud noises
	var/bang_protect = 0
	// Multiplier for both long term and short term ear damage
	var/damage_multiplier = 1

/obj/item/organ/ears/on_life(delta_time, times_fired)
	// only inform when things got worse, needs to happen before we heal
	if((damage > low_threshold && prev_damage < low_threshold) || (damage > high_threshold && prev_damage < high_threshold))
		to_chat(owner, SPAN_WARNING("The ringing in your ears grows louder, blocking out any external noises for a moment."))

	. = ..()
	// if we have non-damage related deafness like mutations, quirks or clothing (earmuffs), don't bother processing here. Ear healing from earmuffs or chems happen elsewhere
	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		return

	if((damage < maxHealth) && (organ_flags & ORGAN_FAILING)) //ear damage can be repaired from the failing condition
		organ_flags &= ~ORGAN_FAILING

	if((organ_flags & ORGAN_FAILING))
		deaf = max(deaf, 1) // if we're failing we always have at least 1 deaf stack (and thus deafness)
	else // only clear deaf stacks if we're not failing
		deaf = max(deaf - (0.5 * delta_time), 0)
		if((damage > low_threshold) && DT_PROB(damage / 60, delta_time))
			adjustEarDamage(0, 4)
			SEND_SOUND(owner, sound('sound/weapons/flash_ring.ogg'))

	if(deaf)
		ADD_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)
	else
		REMOVE_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)

/obj/item/organ/ears/proc/adjustEarDamage(ddmg, ddeaf)
	damage = max(damage + (ddmg*damage_multiplier), 0)
	deaf = max(deaf + (ddeaf*damage_multiplier), 0)

/obj/item/organ/ears/is_visible_on_owner()
	if(owner.head && (owner.head.flags_inv & HIDEEARS) || (owner.wear_mask && (owner.wear_mask.flags_inv & HIDEEARS)))
		return FALSE
	return TRUE

/obj/item/organ/ears/mammal
	name = "mammal ears"
	accessory_type = /datum/sprite_accessory/ears/fox
	accessory_colors = "#FFAA00#FFDD44"

/obj/item/organ/ears/vulpkanin
	name = "vulpkanin ears"
	accessory_type = /datum/sprite_accessory/ears/fox
	accessory_colors = "#FFAA00#FFDD44"

/obj/item/organ/ears/tajaran
	name = "tajaran ears"
	accessory_type = /datum/sprite_accessory/ears/cat_big
	accessory_colors = "#BBAA88#AAAA99"

/obj/item/organ/ears/cat
	name = "felinid ears"

/obj/item/organ/ears/akula
	name = "akula ears"
	accessory_type = /datum/sprite_accessory/ears/sergal
	accessory_colors = "#668899#BBCCDD"
