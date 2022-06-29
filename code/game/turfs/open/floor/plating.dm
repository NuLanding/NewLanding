/* In this file:
 *
 * Plating
 * Airless
 * Airless plating
 * Engine floor
 * Foam plating
 */

/turf/open/floor/plating
	name = "plating"
	icon_state = "plating"
	base_icon_state = "plating"
	intact = FALSE
	baseturfs = /turf/baseturf_bottom
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	var/attachment_holes = TRUE

/turf/open/floor/plating/setup_broken_states()
	return list("platingdmg1", "platingdmg2", "platingdmg3")

/turf/open/floor/plating/setup_burnt_states()
	return list("panelscorched")

/turf/open/floor/plating/examine(mob/user)
	. = ..()
	if(broken || burnt)
		. += SPAN_NOTICE("It looks like the dents could be <i>welded</i> smooth.")
		return
	if(attachment_holes)
		. += SPAN_NOTICE("There are a few attachment holes for a new <i>tile</i> or reinforcement <i>rods</i>.")
	else
		. += SPAN_NOTICE("You might be able to build ontop of it with some <i>tiles</i>...")

/turf/open/floor/plating/welder_act(mob/living/user, obj/item/I)
	..()
	if((broken || burnt) && I.use_tool(src, user, 0, volume=80))
		to_chat(user, SPAN_DANGER("You fix some dents on the broken plating."))
		icon_state = base_icon_state
		burnt = FALSE
		broken = FALSE

	return TRUE

/turf/open/floor/plating/make_plating(force = FALSE)
	return
