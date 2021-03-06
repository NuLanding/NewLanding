/datum/surgery/implant_removal
	name = "Implant removal"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/close)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)


//extract implant
/datum/surgery_step/extract_implant
	name = "extract implant"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CROWBAR = 65,
		/obj/item/kitchen/fork = 35)
	time = 64
	var/obj/item/implant/implant

/datum/surgery_step/extract_implant/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	for(var/obj/item/object in target.implants)
		implant = object
		break
	if(implant)
		display_results(user, target, SPAN_NOTICE("You begin to extract [implant] from [target]'s [target_zone]..."),
			SPAN_NOTICE("[user] begins to extract [implant] from [target]'s [target_zone]."),
			SPAN_NOTICE("[user] begins to extract something from [target]'s [target_zone]."))
	else
		display_results(user, target, SPAN_NOTICE("You look for an implant in [target]'s [target_zone]..."),
			SPAN_NOTICE("[user] looks for an implant in [target]'s [target_zone]."),
			SPAN_NOTICE("[user] looks for something in [target]'s [target_zone]."))

/datum/surgery_step/extract_implant/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(implant)
		display_results(user, target, SPAN_NOTICE("You successfully remove [implant] from [target]'s [target_zone]."),
			SPAN_NOTICE("[user] successfully removes [implant] from [target]'s [target_zone]!"),
			SPAN_NOTICE("[user] successfully removes something from [target]'s [target_zone]!"))
		implant.removed(target)

		qdel(implant)

	else
		to_chat(user, SPAN_WARNING("You can't find anything in [target]'s [target_zone]!"))
	return ..()

/datum/surgery/implant_removal/mechanic
	name = "implant removal"
	requires_bodypart_type = BODYPART_ROBOTIC
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/extract_implant,
		/datum/surgery_step/mechanic_wrench,
		/datum/surgery_step/mechanic_close)
