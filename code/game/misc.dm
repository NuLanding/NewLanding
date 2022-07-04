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

// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH 0
#define SCANMODE_WOUND 1
#define SCANMODE_COUNT 2 // Update this to be the number of scan modes if you add more
#define SCANNER_CONDENSED 0
#define SCANNER_VERBOSE 1

// Used by the PDA medical scanner too
/proc/healthscan(mob/user, mob/living/M, mode = SCANNER_VERBOSE, advanced = FALSE)
	if(user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, SPAN_WARNING("You realize that your scanner has no accessibility support for the blind!"))
		return

	// the final list of strings to render
	var/render_list = list()

	// Damage specifics
	var/oxy_loss = M.getOxyLoss()
	var/tox_loss = M.getToxLoss()
	var/fire_loss = M.getFireLoss()
	var/brute_loss = M.getBruteLoss()
	var/mob_status = (M.stat == DEAD ? SPAN_ALERT("<b>Deceased</b>") : "<b>[round(M.health/M.maxHealth,0.01)*100]% healthy</b>")

	if(HAS_TRAIT(M, TRAIT_FAKEDEATH) && !advanced)
		mob_status = SPAN_ALERT("<b>Deceased</b>")
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.undergoing_cardiac_arrest() && H.stat != DEAD)
			render_list += "[SPAN_ALERT("Subject suffering from heart attack: Apply defibrillation or other electric shock immediately!")]\n"
		if(H.has_reagent(/datum/reagent/inverse/technetium))
			advanced = TRUE

	render_list += "[SPAN_INFO("Analyzing results for [M]:")]\n<span class='info ml-1'>Overall status: [mob_status]</span>\n"

	// Husk detection
	if(advanced && HAS_TRAIT_FROM(M, TRAIT_HUSK, BURN))
		render_list += "<span class='alert ml-1'>Subject has been husked by severe burns.</span>\n"
	else if (advanced && HAS_TRAIT_FROM(M, TRAIT_HUSK, CHANGELING_DRAIN))
		render_list += "<span class='alert ml-1'>Subject has been husked by dessication.</span>\n"
	else if(HAS_TRAIT(M, TRAIT_HUSK))
		render_list += "<span class='alert ml-1'>Subject has been husked.</span>\n"

	// Damage descriptions
	if(brute_loss > 10)
		render_list += "<span class='alert ml-1'>[brute_loss > 50 ? "Severe" : "Minor"] tissue damage detected.</span>\n"
	if(fire_loss > 10)
		render_list += "<span class='alert ml-1'>[fire_loss > 50 ? "Severe" : "Minor"] burn damage detected.</span>\n"
	if(oxy_loss > 10)
		render_list += "<span class='info ml-1'>[SPAN_ALERT("[oxy_loss > 50 ? "Severe" : "Minor"] oxygen deprivation detected.")]\n"
	if(tox_loss > 10)
		render_list += "<span class='alert ml-1'>[tox_loss > 50 ? "Severe" : "Minor"] amount of toxin damage detected.</span>\n"
	if(M.getStaminaLoss())
		render_list += "<span class='alert ml-1'>Subject appears to be suffering from fatigue.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Fatigue Level: [M.getStaminaLoss()]%.</span>\n"
	if (M.getCloneLoss())
		render_list += "<span class='alert ml-1'>Subject appears to have [M.getCloneLoss() > 30 ? "Severe" : "Minor"] cellular damage.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Cellular Damage Level: [M.getCloneLoss()].</span>\n"
	if (!M.getorganslot(ORGAN_SLOT_BRAIN)) // brain not added to carbon/human check because it's funny to get to bully simple mobs
		render_list += "<span class='alert ml-1'>Subject lacks a brain.</span>\n"
	if(ishuman(M))
		var/mob/living/carbon/human/the_dude = M
		var/datum/species/the_dudes_species = the_dude.dna.species
		if (!(NOBLOOD in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_HEART))
			render_list += "<span class='alert ml-1'>Subject lacks a heart.</span>\n"
		if (!(TRAIT_NOBREATH in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_LUNGS))
			render_list += "<span class='alert ml-1'>Subject lacks lungs.</span>\n"
		if (!(TRAIT_NOMETABOLISM in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_LIVER))
			render_list += "<span class='alert ml-1'>Subject lacks a liver.</span>\n"
		if (!(NOSTOMACH in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_STOMACH))
			render_list += "<span class='alert ml-1'>Subject lacks a stomach.</span>\n"

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(LAZYLEN(C.get_traumas()))
			var/list/trauma_text = list()
			for(var/datum/brain_trauma/B in C.get_traumas())
				var/trauma_desc = ""
				switch(B.resilience)
					if(TRAUMA_RESILIENCE_SURGERY)
						trauma_desc += "severe "
					if(TRAUMA_RESILIENCE_LOBOTOMY)
						trauma_desc += "deep-rooted "
					if(TRAUMA_RESILIENCE_WOUND)
						trauma_desc += "fracture-derived "
					if(TRAUMA_RESILIENCE_MAGIC, TRAUMA_RESILIENCE_ABSOLUTE)
						trauma_desc += "permanent "
				trauma_desc += B.scan_desc
				trauma_text += trauma_desc
			render_list += "<span class='alert ml-1'>Cerebral traumas detected: subject appears to be suffering from [english_list(trauma_text)].</span>\n"
		if(C.quirks.len)
			render_list += "<span class='info ml-1'>Subject Major Disabilities: [C.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY)].</span>\n"
			if(advanced)
				render_list += "<span class='info ml-1'>Subject Minor Disabilities: [C.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY)].</span>\n"
	if(advanced)
		render_list += "<span class='info ml-1'>Brain Activity Level: [(200 - M.getOrganLoss(ORGAN_SLOT_BRAIN))/2]%.</span>\n"

	if (M.radiation)
		render_list += "<span class='alert ml-1'>Subject is irradiated.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Radiation Level: [M.radiation]%.</span>\n"

	if(advanced && M.hallucinating())
		render_list += "<span class='info ml-1'>Subject is hallucinating.</span>\n"

	// Body part damage report
	if(iscarbon(M) && mode == SCANNER_VERBOSE)
		var/mob/living/carbon/C = M
		var/list/damaged = C.get_damaged_bodyparts(1,1)
		if(length(damaged)>0 || oxy_loss>0 || tox_loss>0 || fire_loss>0)
			var/dmgreport = "<span class='info ml-1'>General status:</span>\
							<table class='ml-2'><tr><font face='Verdana'>\
							<td style='width:7em;'><font color='#ff0000'><b>Damage:</b></font></td>\
							<td style='width:5em;'><font color='#ff3333'><b>Brute</b></font></td>\
							<td style='width:4em;'><font color='#ff9933'><b>Burn</b></font></td>\
							<td style='width:4em;'><font color='#00cc66'><b>Toxin</b></font></td>\
							<td style='width:8em;'><font color='#00cccc'><b>Suffocation</b></font></td></tr>\
							<tr><td><font color='#ff3333'><b>Overall:</b></font></td>\
							<td><font color='#ff3333'><b>[CEILING(brute_loss,1)]</b></font></td>\
							<td><font color='#ff9933'><b>[CEILING(fire_loss,1)]</b></font></td>\
							<td><font color='#00cc66'><b>[CEILING(tox_loss,1)]</b></font></td>\
							<td><font color='#33ccff'><b>[CEILING(oxy_loss,1)]</b></font></td></tr>"

			for(var/o in damaged)
				var/obj/item/bodypart/org = o //head, left arm, right arm, etc.
				dmgreport += "<tr><td><font color='#cc3333'>[capitalize(org.name)]:</font></td>\
								<td><font color='#cc3333'>[(org.brute_dam > 0) ? "[CEILING(org.brute_dam,1)]" : "0"]</font></td>\
								<td><font color='#ff9933'>[(org.burn_dam > 0) ? "[CEILING(org.burn_dam,1)]" : "0"]</font></td></tr>"
			dmgreport += "</font></table>"
			render_list += dmgreport // tables do not need extra linebreak

	//Eyes and ears
	if(advanced && iscarbon(M))
		var/mob/living/carbon/C = M

		// Ear status
		var/obj/item/organ/ears/ears = C.getorganslot(ORGAN_SLOT_EARS)
		var/message = "\n<span class='alert ml-2'>Subject does not have ears.</span>"
		if(istype(ears))
			message = ""
			if(HAS_TRAIT_FROM(C, TRAIT_DEAF, GENETIC_MUTATION))
				message = "\n<span class='alert ml-2'>Subject is genetically deaf.</span>"
			else if(HAS_TRAIT_FROM(C, TRAIT_DEAF, EAR_DAMAGE))
				message = "\n<span class='alert ml-2'>Subject is deaf from ear damage.</span>"
			else if(HAS_TRAIT(C, TRAIT_DEAF))
				message = "\n<span class='alert ml-2'>Subject is deaf.</span>"
			else
				if(ears.damage)
					message += "\n<span class='alert ml-2'>Subject has [ears.damage > ears.maxHealth ? "permanent ": "temporary "]hearing damage.</span>"
				if(ears.deaf)
					message += "\n<span class='alert ml-2'>Subject is [ears.damage > ears.maxHealth ? "permanently ": "temporarily "] deaf.</span>"
		render_list += "<span class='info ml-1'>Ear status:</span>[message == "" ? "\n<span class='info ml-2'>Healthy.</span>" : message]\n"

		// Eye status
		var/obj/item/organ/eyes/eyes = C.getorganslot(ORGAN_SLOT_EYES)
		message = "\n<span class='alert ml-2'>Subject does not have eyes.</span>"
		if(istype(eyes))
			message = ""
			if(C.is_blind())
				message += "\n<span class='alert ml-2'>Subject is blind.</span>"
			if(HAS_TRAIT(C, TRAIT_NEARSIGHT))
				message += "\n<span class='alert ml-2'>Subject is nearsighted.</span>"
			if(eyes.damage > 30)
				message += "\n<span class='alert ml-2'>Subject has severe eye damage.</span>"
			else if(eyes.damage > 20)
				message += "\n<span class='alert ml-2'>Subject has significant eye damage.</span>"
			else if(eyes.damage)
				message += "\n<span class='alert ml-2'>Subject has minor eye damage.</span>"
		render_list += "<span class='info ml-1'>Eye status:</span>[message == "" ? "\n<span class='info ml-2'>Healthy.</span>" : message]\n"

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		// Organ damage
		if (H.internal_organs && H.internal_organs.len)
			var/render = FALSE
			var/toReport = "<span class='info ml-1'>Organs:</span>\
				<table class='ml-2'><tr>\
				<td style='width:6em;'><font color='#ff0000'><b>Organ:</b></font></td>\
				[advanced ? "<td style='width:3em;'><font color='#ff0000'><b>Dmg</b></font></td>" : ""]\
				<td style='width:12em;'><font color='#ff0000'><b>Status</b></font></td>"

			for(var/obj/item/organ/organ in H.internal_organs)
				var/status = ""
				if(H.has_reagent(/datum/reagent/inverse/technetium))
					if(organ.damage)
						status = "<font color='#E42426'> organ is [round((organ.damage/organ.maxHealth)*100, 1)]% damaged.</font>"
				else
					if (organ.organ_flags & ORGAN_FAILING)
						status = "<font color='#cc3333'>Non-Functional</font>"
					else if (organ.damage > organ.high_threshold)
						status = "<font color='#ff9933'>Severely Damaged</font>"
					else if (organ.damage > organ.low_threshold)
						status = "<font color='#ffcc33'>Mildly Damaged</font>"
				if (status != "")
					render = TRUE
					toReport += "<tr><td><font color='#cc3333'>[organ.name]:</font></td>\
						[advanced ? "<td><font color='#ff3333'>[CEILING(organ.damage,1)]</font></td>" : ""]\
						<td>[status]</td></tr>"

			if (render)
				render_list += toReport + "</table>" // tables do not need extra linebreak

		//Genetic damage
		if(advanced && H.has_dna())
			render_list += "<span class='info ml-1'>Genetic Stability: [H.dna.stability]%.</span>\n"

		// Species and body temperature
		var/datum/species/S = H.dna.species
		var/mutant = FALSE // wtf was this

		render_list += "<span class='info ml-1'>Species: [S.name][mutant ? "-derived mutant" : ""]</span>\n"
		render_list += "<span class='info ml-1'>Core temperature: [round(H.coretemperature-T0C,0.1)] &deg;C ([round(H.coretemperature*1.8-459.67,0.1)] &deg;F)</span>\n"
	render_list += "<span class='info ml-1'>Body temperature: [round(M.bodytemperature-T0C,0.1)] &deg;C ([round(M.bodytemperature*1.8-459.67,0.1)] &deg;F)</span>\n"

	// Time of death
	if(M.tod && (M.stat == DEAD || ((HAS_TRAIT(M, TRAIT_FAKEDEATH)) && !advanced)))
		render_list += "<span class='info ml-1'>Time of Death: [M.tod]</span>\n"
		var/tdelta = round(world.time - M.timeofdeath)
		render_list += "<span class='alert ml-1'><b>Subject died [DisplayTimeText(tdelta)] ago.</b></span>\n"

	// Wounds
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/list/wounded_parts = C.get_wounded_bodyparts()
		for(var/i in wounded_parts)
			var/obj/item/bodypart/wounded_part = i
			render_list += "<span class='alert ml-1'><b>Warning: Physical trauma[LAZYLEN(wounded_part.wounds) > 1? "s" : ""] detected in [wounded_part.name]</b>"
			for(var/k in wounded_part.wounds)
				var/datum/wound/W = k
				render_list += "<div class='ml-2'>Type: [W.name]\nSeverity: [W.severity_text()]\nRecommended Treatment: [W.treat_text]</div>\n" // less lines than in woundscan() so we don't overload people trying to get basic med info
			render_list += "</span>"

	// Blood Level
	if(M.has_dna())
		var/mob/living/carbon/C = M
		var/blood_id = C.get_blood_id()
		if(blood_id)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				if(H.is_bleeding())
					render_list += "<span class='alert ml-1'><b>Subject is bleeding!</b></span>\n"
			var/blood_percent =  round((C.blood_volume / BLOOD_VOLUME_NORMAL)*100)
			var/blood_type = C.dna.blood_type
			if(blood_id != /datum/reagent/blood) // special blood substance
				var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
				blood_type = R ? R.name : blood_id
			if(C.blood_volume <= BLOOD_VOLUME_SAFE && C.blood_volume > BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Blood level: LOW [blood_percent] %, [C.blood_volume] cl,</span> [SPAN_INFO("type: [blood_type]")]\n"
			else if(C.blood_volume <= BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Blood level: <b>CRITICAL [blood_percent] %</b>, [C.blood_volume] cl,</span> [SPAN_INFO("type: [blood_type]")]\n"
			else
				render_list += "<span class='info ml-1'>Blood level: [blood_percent] %, [C.blood_volume] cl, type: [blood_type]</span>\n"

		var/cyberimp_detect
		for(var/obj/item/organ/cyberimp/CI in C.internal_organs)
			if(CI.status == ORGAN_ROBOTIC && !CI.syndicate_implant)
				cyberimp_detect += "[!cyberimp_detect ? "[CI.get_examine_string(user)]" : ", [CI.get_examine_string(user)]"]"
		if(cyberimp_detect)
			render_list += "<span class='notice ml-1'>Detected cybernetic modifications:</span>\n"
			render_list += "<span class='notice ml-2'>[cyberimp_detect]</span>\n"

	to_chat(user, jointext(render_list, ""), trailing_newline = FALSE) // we handled the last <br> so we don't need handholding

/proc/chemscan(mob/living/user, mob/living/M)
	if(user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, SPAN_WARNING("You realize that your scanner has no accessibility support for the blind!"))
		return

	if(istype(M) && M.reagents)
		var/render_list = list()
		if(M.reagents.reagent_list.len)
			render_list += "<span class='notice ml-1'>Subject contains the following reagents in their blood:</span>\n"
			for(var/r in M.reagents.reagent_list)
				var/datum/reagent/reagent = r
				if(reagent.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
					continue
				render_list += "<span class='notice ml-2'>[round(reagent.volume, 0.001)] units of [reagent.name][reagent.overdosed ? "</span> - [SPAN_BOLDANNOUNCE("OVERDOSING")]" : ".</span>"]\n"
		else
			render_list += "<span class='notice ml-1'>Subject contains no reagents in their blood.</span>\n"
		var/obj/item/organ/stomach/belly = M.getorganslot(ORGAN_SLOT_STOMACH)
		if(belly)
			if(belly.reagents.reagent_list.len)
				render_list += "<span class='notice ml-1'>Subject contains the following reagents in their stomach:</span>\n"
				for(var/bile in belly.reagents.reagent_list)
					var/datum/reagent/bit = bile
					if(bit.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
						continue
					if(!belly.food_reagents[bit.type])
						render_list += "<span class='notice ml-2'>[round(bit.volume, 0.001)] units of [bit.name][bit.overdosed ? "</span> - [SPAN_BOLDANNOUNCE("OVERDOSING")]" : ".</span>"]\n"
					else
						var/bit_vol = bit.volume - belly.food_reagents[bit.type]
						if(bit_vol > 0)
							render_list += "<span class='notice ml-2'>[round(bit_vol, 0.001)] units of [bit.name][bit.overdosed ? "</span> - [SPAN_BOLDANNOUNCE("OVERDOSING")]" : ".</span>"]\n"
			else
				render_list += "<span class='notice ml-1'>Subject contains no reagents in their stomach.</span>\n"

		if(LAZYLEN(M.mind?.active_addictions))
			render_list += "<span class='boldannounce ml-1'>Subject is addicted to the following types of drug:</span>\n"
			for(var/datum/addiction/addiction_type as anything in M.mind.active_addictions)
				render_list += "<span class='alert ml-2'>[initial(addiction_type.name)]</span>\n"
		else
			render_list += "<span class='notice ml-1'>Subject is not addicted to any types of drug.</span>\n"

		to_chat(user, jointext(render_list, ""), trailing_newline = FALSE) // we handled the last <br> so we don't need handholding
	
/proc/rename_area(a, new_name)
	var/area/A = get_area(a)
	var/prevname = "[A.name]"
	set_area_machinery_title(A, new_name, prevname)
	A.name = new_name
	A.update_areasize()
	return TRUE


/proc/set_area_machinery_title(area/A, title, oldtitle)
	if(!oldtitle) // or replacetext goes to infinite loop
		return
	//TODO: much much more. Unnamed airlocks, cameras, etc.
