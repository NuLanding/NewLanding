//Vars that will not be copied when using /DuplicateObject
GLOBAL_LIST_INIT(duplicate_forbidden_vars,list(
	"tag", "datum_components", "area", "type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key",
	"power_supply", "contents", "reagents", "stat", "x", "y", "z", "group", "atmos_adjacent_turfs", "comp_lookup",
	"client_mobs_in_contents", "bodyparts", "internal_organs", "hand_bodyparts", "overlays_standing", "hud_list",
	"actions", "AIStatus", "appearance", "managed_overlays", "managed_vis_overlays", "computer_id", "lastKnownIP", "implants",
	"tgui_shared_states"
	))

/proc/DuplicateObject(atom/original, perfectcopy = TRUE, sameloc, atom/newloc = null, nerf, holoitem)
	RETURN_TYPE(original.type)
	if(!original)
		return
	var/atom/O

	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(newloc)

	if(perfectcopy && O && original)
		for(var/V in original.vars - GLOB.duplicate_forbidden_vars)
			if(islist(original.vars[V]))
				var/list/L = original.vars[V]
				O.vars[V] = L.Copy()
			else if(istype(original.vars[V], /datum) || ismob(original.vars[V]))
				continue // this would reference the original's object, that will break when it is used or deleted.
			else
				O.vars[V] = original.vars[V]

	if(isobj(O))
		var/obj/N = O
		if(holoitem)
			N.resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF // holoitems do not burn

		if(nerf && isitem(O))
			var/obj/item/I = O
			I.damtype = STAMINA // thou shalt not

		N.update_appearance()

	if(ismob(O)) //Overlays are carried over despite disallowing them, if a fix is found remove this.
		var/mob/M = O
		M.cut_overlays()
		M.regenerate_icons()
	return O

/// Does the MGS ! animation
/atom/proc/do_alert_animation()
	var/image/alert_image = image('icons/obj/structures/closet.dmi', src, "cardboard_special", layer+1)
	alert_image.plane = ABOVE_LIGHTING_PLANE
	flick_overlay_view(alert_image, src, 8)
	alert_image.alpha = 0
	animate(alert_image, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)
