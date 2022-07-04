/datum/surgery/hepatectomy
	name = "Hepatectomy"
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_real_bodypart = TRUE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/hepatectomy,
		/datum/surgery_step/close)

/datum/surgery/hepatectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/liver/target_liver = target.getorganslot(ORGAN_SLOT_LIVER)
	if(target_liver?.damage > 50 && !(target_liver.organ_flags & ORGAN_FAILING))
		return TRUE

////hepatectomy, removes damaged parts of the liver so that the liver may regenerate properly
//95% chance of success, not 100 because organs are delicate
/datum/surgery_step/hepatectomy
	name = "remove damaged liver section"
	implements = list(
		TOOL_SCALPEL = 95,
		/obj/item/kitchen/knife = 45,
		/obj/item/shard = 35)
	time = 52

/datum/surgery_step/hepatectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, SPAN_NOTICE("You begin to cut out a damaged piece of [target]'s liver..."),
		SPAN_NOTICE("[user] begins to make an incision in [target]."),
		SPAN_NOTICE("[user] begins to make an incision in [target]."))

/datum/surgery_step/hepatectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/human_target = target
	human_target.setOrganLoss(ORGAN_SLOT_LIVER, 10) //not bad, not great
	display_results(user, target, SPAN_NOTICE("You successfully remove the damaged part of [target]'s liver."),
		SPAN_NOTICE("[user] successfully removes the damaged part of [target]'s liver."),
		SPAN_NOTICE("[user] successfully removes the damaged part of [target]'s liver."))
	return ..()

/datum/surgery_step/hepatectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery)
	var/mob/living/carbon/human/human_target = target
	human_target.adjustOrganLoss(ORGAN_SLOT_LIVER, 15)
	display_results(user, target, SPAN_WARNING("You cut the wrong part of [target]'s liver!"),
		SPAN_WARNING("[user] cuts the wrong part of [target]'s liver!"),
		SPAN_WARNING("[user] cuts the wrong part of [target]'s liver!"))
