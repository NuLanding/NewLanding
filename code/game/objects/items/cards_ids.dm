/**
 * x1, y1, x2, y2 - Represents the bounding box for the ID card's non-transparent portion of its various icon_states.
 * Used to crop the ID card's transparency away when chaching the icon for better use in tgui chat.
 */
#define ID_ICON_BORDERS 1, 9, 32, 24

/// Fallback time if none of the config entries are set for USE_LOW_LIVING_HOUR_INTERN
#define INTERN_THRESHOLD_FALLBACK_HOURS 15

/* Cards
 * Contains:
 * DATA CARD
 * ID CARD
 * FINGERPRINT CARD HOLDER
 * FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the IC data card reader
 */

/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = WEIGHT_CLASS_TINY

	var/list/files = list()

/obj/item/card/suicide_act(mob/living/carbon/user)
	user.visible_message(SPAN_SUICIDE("[user] begins to swipe [user.p_their()] neck with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/card/data
	name = "data card"
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has a stripe running down the middle."
	icon_state = "data_1"
	obj_flags = UNIQUE_RENAME
	var/function = "storage"
	var/data = "null"
	var/special = null
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	var/detail_color = COLOR_ASSEMBLY_ORANGE

/obj/item/card/data/Initialize()
	.=..()
	update_appearance()

/obj/item/card/data/update_overlays()
	. = ..()
	if(detail_color == COLOR_FLOORTILE_GRAY)
		return
	var/mutable_appearance/detail_overlay = mutable_appearance('icons/obj/card.dmi', "[icon_state]-color")
	detail_overlay.color = detail_color
	. += detail_overlay

/obj/item/card/data/full_color
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has the entire card colored."
	icon_state = "data_2"

/obj/item/card/data/disk
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one inexplicibly looks like a floppy disk."
	icon_state = "data_3"

/*
 * ID CARDS
 */

/// "Retro" ID card that renders itself as the icon state with no overlays.
/obj/item/card/id
	name = "retro identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "card_grey"
	worn_icon_state = "card_retro"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	slot_flags = ITEM_SLOT_ID
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	/// Cached icon that has been built for this card. Intended for use in chat.
	var/icon/cached_flat_icon

	/// How many magical mining Disney Dollars this card has for spending at the mining equipment vendors.
	var/mining_points = 0
	/// The name registered on the card (for example: Dr Bryan See)
	var/registered_name = null
	/// Registered owner's age.
	var/registered_age = 30

	/// The job name registered on the card (for example: Assistant).
	var/assignment

	/// Trim datum associated with the card. Controls which job icon is displayed on the card and which accesses do not require wildcards.
	var/datum/id_trim/trim

	/// Access levels held by this card.
	var/list/access = list()

	/// List of wildcard slot names as keys with lists of wildcard data as values.
	var/list/wildcard_slots = list()

	/// Boolean value. If TRUE, the [Intern] tag gets prepended to this ID card when the label is updated.
	var/is_intern = FALSE

/obj/item/card/id/Initialize(mapload)
	. = ..()

	// Applying the trim updates the label and icon, so don't do this twice.
	if(ispath(trim))
		SSid_access.apply_trim_to_card(src, trim)
	else
		update_label()
		update_icon()

/obj/item/card/id/get_id_examine_strings(mob/user)
	. = ..()
	. += list("[icon2html(get_cached_flat_icon(), user, extra_classes = "bigicon")]")

/obj/item/card/id/update_overlays()
	. = ..()

	cached_flat_icon = null

/// If no cached_flat_icon exists, this proc creates it and crops it. This proc then returns the cached_flat_icon. Intended only for use displaying ID card icons in chat.
/obj/item/card/id/proc/get_cached_flat_icon()
	if(!cached_flat_icon)
		cached_flat_icon = getFlatIcon(src)
		cached_flat_icon.Crop(ID_ICON_BORDERS)
	return cached_flat_icon

/obj/item/card/id/get_examine_string(mob/user, thats = FALSE)
	return "[icon2html(get_cached_flat_icon(), user)] [thats? "That's ":""][get_examine_name(user)]"

/**
 * Helper proc, checks whether the ID card can hold any given set of wildcards.
 *
 * Returns TRUE if the card can hold the wildcards, FALSE otherwise.
 * Arguments:
 * * wildcard_list - List of accesses to check.
 * * try_wildcard - If not null, will attempt to add wildcards for this wildcard specifically and will return FALSE if the card cannot hold all wildcards in this slot.
 */
/obj/item/card/id/proc/can_add_wildcards(list/wildcard_list, try_wildcard = null)
	if(!length(wildcard_list))
		return TRUE

	var/list/new_wildcard_limits = list()

	for(var/flag_name in wildcard_slots)
		if(try_wildcard && !(flag_name == try_wildcard))
			continue
		var/list/wildcard_info = wildcard_slots[flag_name]
		new_wildcard_limits[flag_name] = wildcard_info["limit"] - length(wildcard_info["usage"])

	if(!length(new_wildcard_limits))
		return FALSE

	var/wildcard_allocated
	for(var/wildcard in wildcard_list)
		var/wildcard_flag = SSid_access.get_access_flag(wildcard)
		wildcard_allocated = FALSE
		for(var/flag_name in new_wildcard_limits)
			var/limit_flags = SSid_access.wildcard_flags_by_wildcard[flag_name]
			if(!(wildcard_flag & limit_flags))
				continue
			// Negative limits mean infinite slots. Positive limits mean limited slots still available. 0 slots means no slots.
			if(new_wildcard_limits[flag_name] == 0)
				continue
			new_wildcard_limits[flag_name]--
			wildcard_allocated = TRUE
			break
		if(!wildcard_allocated)
			return FALSE

	return TRUE

/**
 * Attempts to add the given wildcards to the ID card.
 *
 * Arguments:
 * * wildcard_list - List of accesses to add.
 * * try_wildcard - If not null, will attempt to add all wildcards to this wildcard slot only.
 * * mode - The method to use when adding wildcards. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/add_wildcards(list/wildcard_list, try_wildcard = null, mode = ERROR_ON_FAIL)
	var/wildcard_allocated
	// Iterate through each wildcard in our list. Get its access flag. Then iterate over wildcard slots and try to fit it in.
	for(var/wildcard in wildcard_list)
		var/wildcard_flag = SSid_access.get_access_flag(wildcard)
		wildcard_allocated = FALSE
		for(var/flag_name in wildcard_slots)
			if(flag_name == WILDCARD_NAME_FORCED)
				continue

			if(try_wildcard && !(flag_name == try_wildcard))
				continue

			var/limit_flags = SSid_access.wildcard_flags_by_wildcard[flag_name]

			if(!(wildcard_flag & limit_flags))
				continue

			var/list/wildcard_info = wildcard_slots[flag_name]
			var/wildcard_limit = wildcard_info["limit"]
			var/list/wildcard_usage = wildcard_info["usage"]

			var/wildcard_count = wildcard_limit - length(wildcard_usage)

			// Negative limits mean infinite slots. Positive limits mean limited slots still available. 0 slots means no slots.
			if(wildcard_count == 0)
				continue

			wildcard_usage |= wildcard
			access |= wildcard
			wildcard_allocated = TRUE
			break
		// Fallback for if we couldn't allocate the wildcard for some reason.
		if(!wildcard_allocated)
			if(mode == ERROR_ON_FAIL)
				CRASH("Wildcard ([wildcard]) could not be added to [src].")

			if(mode == TRY_ADD_ALL)
				continue

			// If the card has no info for historic forced wildcards, create the list.
			if(!wildcard_slots[WILDCARD_NAME_FORCED])
				wildcard_slots[WILDCARD_NAME_FORCED] = list(limit = 0, usage = list())

			var/list/wildcard_info = wildcard_slots[WILDCARD_NAME_FORCED]
			var/list/wildcard_usage = wildcard_info["usage"]
			wildcard_usage |= wildcard
			access |= wildcard
			wildcard_info["limit"] = length(wildcard_usage)

/**
 * Removes wildcards from the ID card.
 *
 * Arguments:
 * * wildcard_list - List of accesses to remove.
 */
/obj/item/card/id/proc/remove_wildcards(list/wildcard_list)
	var/wildcard_removed
	// Iterate through each wildcard in our list. Get its access flag. Then iterate over wildcard slots and try to remove it.
	for(var/wildcard in wildcard_list)
		wildcard_removed = FALSE
		for(var/flag_name in wildcard_slots)
			if(flag_name == WILDCARD_NAME_FORCED)
				continue

			var/list/wildcard_info = wildcard_slots[flag_name]
			var/wildcard_usage = wildcard_info["usage"]

			if(!(wildcard in wildcard_usage))
				continue

			wildcard_usage -= wildcard
			access -= wildcard
			wildcard_removed = TRUE
			break
		// Fallback to see if this was a force-added wildcard.
		if(!wildcard_removed)
			// If the card has no info for historic forced wildcards, that's an error state.
			if(!wildcard_slots[WILDCARD_NAME_FORCED])
				stack_trace("Wildcard ([wildcard]) could not be removed from [src]. This card has no forced wildcard data and the wildcard is not in this card's wildcard lists.")

			var/list/wildcard_info = wildcard_slots[WILDCARD_NAME_FORCED]
			var/wildcard_usage = wildcard_info["usage"]

			if(!(wildcard in wildcard_usage))
				stack_trace("Wildcard ([wildcard]) could not be removed from [src]. This access is not a wildcard on this card.")

			wildcard_usage -= wildcard
			access -= wildcard
			wildcard_info["limit"] = length(wildcard_usage)

			if(!wildcard_info["limit"])
				wildcard_slots -= WILDCARD_NAME_FORCED

/**
 * Attempts to add the given accesses to the ID card as non-wildcards.
 *
 * Depending on the mode, may add accesses as wildcards or error if it can't add them as non-wildcards.
 * Arguments:
 * * add_accesses - List of accesses to check.
 * * try_wildcard - If not null, will attempt to add all accesses that require wildcard slots to this wildcard slot only.
 * * mode - The method to use when adding accesses. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/add_access(list/add_accesses, try_wildcard = null, mode = ERROR_ON_FAIL)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(add_accesses, normal_access, wildcard_access)

	// Check if we can add the wildcards.
	if(mode == ERROR_ON_FAIL)
		if(!can_add_wildcards(wildcard_access, try_wildcard))
			CRASH("Cannot add wildcards from \[[add_accesses.Join(",")]\] to [src]")

	// All clear to add the accesses.
	access |= normal_access
	if(mode != TRY_ADD_ALL_NO_WILDCARD)
		add_wildcards(wildcard_access, try_wildcard, mode = mode)

	return TRUE

/**
 * Removes the given accesses from the ID Card.
 *
 * Will remove the wildcards if the accesses given are on the card as wildcard accesses.
 * Arguments:
 * * rem_accesses - List of accesses to remove.
 */
/obj/item/card/id/proc/remove_access(list/rem_accesses)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(rem_accesses, normal_access, wildcard_access)

	access -= normal_access
	remove_wildcards(wildcard_access)

/**
 * Attempts to set the card's accesses to the given accesses, clearing all accesses not in the given list.
 *
 * Depending on the mode, may add accesses as wildcards or error if it can't add them as non-wildcards.
 * Arguments:
 * * new_access_list - List of all accesses that this card should hold exclusively.
 * * mode - The method to use when setting accesses. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/set_access(list/new_access_list, mode = ERROR_ON_FAIL)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(new_access_list, normal_access, wildcard_access)

	// Check if we can add the wildcards.
	if(mode == ERROR_ON_FAIL)
		if(!can_add_wildcards(wildcard_access))
			CRASH("Cannot add wildcards from \[[new_access_list.Join(",")]\] to [src]")

	clear_access()

	access = normal_access.Copy()

	if(mode != TRY_ADD_ALL_NO_WILDCARD)
		add_wildcards(wildcard_access, mode = mode)

	return TRUE

/// Clears all accesses from the ID card - both wildcard and normal.
/obj/item/card/id/proc/clear_access()
	// Go through the wildcards and reset them.
	for(var/flag_name in wildcard_slots)
		var/list/wildcard_info = wildcard_slots[flag_name]
		var/list/wildcard_usage = wildcard_info["usage"]
		wildcard_usage.Cut()

	// Hard reset access
	access.Cut()


/**
 * Helper proc. Creates access lists for the access procs.
 *
 * Takes the accesses list and compares it with the trim. Any basic accesses that match the trim are
 * added to basic_access_list and the rest are added to wildcard_access_list.

 * This proc directly modifies the lists passed in as args. It expects these lists to be instantiated.
 * There is no return value.
 * Arguments:
 * * accesses - List of accesses you want to stort into basic_access_list and wildcard_access_list. Should not be null.
 * * basic_access_list - Mandatory argument. The proc modifies the list passed in this argument and adds accesses the trim supports to it.
 * * wildcard_access_list - Mandatory argument. The proc modifies the list passed in this argument and adds accesses the trim does not support to it.
 */
/obj/item/card/id/proc/build_access_lists(list/accesses, list/basic_access_list, list/wildcard_access_list)
	if(!length(accesses) || isnull(basic_access_list) || isnull(wildcard_access_list))
		CRASH("Invalid parameters passed to build_access_lists")

	var/list/trim_accesses = trim?.access

	// Populate the lists.
	for(var/new_access in accesses)
		if(new_access in trim_accesses)
			basic_access_list |= new_access
			continue

		wildcard_access_list |= new_access

/obj/item/card/id/attack_self(mob/user)
	if(Adjacent(user))
		var/minor
		if(registered_name && registered_age && registered_age < AGE_MINOR)
			minor = " <b>(MINOR)</b>"
		user.visible_message(SPAN_NOTICE("[user] shows you: [icon2html(src, viewers(user))] [src.name][minor]."), SPAN_NOTICE("You show \the [src.name][minor]."))
	add_fingerprint(user)

/obj/item/card/id/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, assignment), NAMEOF(src, registered_name), NAMEOF(src, registered_age))
				update_label()
				update_icon()
			if(NAMEOF(src, trim))
				if(ispath(trim))
					SSid_access.apply_trim_to_card(src, trim)

/// Helper proc. Can the user alt-click the ID?
/obj/item/card/id/proc/alt_click_can_use_id(mob/living/user)
	if(!isliving(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	return TRUE

/obj/item/card/id/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("<i>There's more information below, you can look again to take a closer look...</i>")

/obj/item/card/id/examine_more(mob/user)
	var/list/msg = list(SPAN_NOTICE("<i>You examine [src] closer, and note the following...</i>"))

	if(registered_age)
		msg += "The card indicates that the holder is [registered_age] years old. [(registered_age < AGE_MINOR) ? "There's a holographic stripe that reads <b>[SPAN_DANGER("'MINOR: DO NOT SERVE ALCOHOL OR TOBACCO'")]</b> along the bottom of the card." : ""]"
	if(mining_points)
		msg += "There's [mining_points] mining equipment redemption point\s loaded onto this card."
	return msg

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/RemoveID()
	return src

/// Updates the name based on the card's vars and state.
/obj/item/card/id/proc/update_label()
	var/name_string = registered_name ? "[registered_name]'s ID Card" : initial(name)
	var/assignment_string

	if(is_intern)
		if(assignment)
			assignment_string = (assignment in SSjob.head_of_staff_jobs) ? " ([assignment]-in-Training)" : " (Intern [assignment])"
		else
			assignment_string = " (Intern)"
	else
		assignment_string = " ([assignment])"

	name = "[name_string][assignment_string]"

/obj/item/card/id/away
	name = "\proper a perfectly generic identification card"
	desc = "A perfectly generic identification card. Looks like it could use some flavor."
	trim = /datum/id_trim/away
	icon_state = "retro"
	registered_age = null

/obj/item/card/id/away/hotel
	name = "Staff ID"
	desc = "A staff ID used to access the hotel's doors."
	trim = /datum/id_trim/away/hotel

/obj/item/card/id/away/hotel/security
	name = "Officer ID"
	trim = /datum/id_trim/away/hotel/security

/obj/item/card/id/away/old
	name = "\proper a perfectly generic identification card"
	desc = "A perfectly generic identification card. Looks like it could use some flavor."

/obj/item/card/id/away/old/sec
	name = "Charlie Station Security Officer's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Security Officer\"."
	trim = /datum/id_trim/away/old/sec

/obj/item/card/id/away/old/sci
	name = "Charlie Station Scientist's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Scientist\"."
	trim = /datum/id_trim/away/old/sci

/obj/item/card/id/away/old/eng
	name = "Charlie Station Engineer's ID card"
	desc = "A faded Charlie Station ID card. You can make out the rank \"Station Engineer\"."
	trim = /datum/id_trim/away/old/eng

/obj/item/card/id/away/old/apc
	name = "APC Access ID"
	desc = "A special ID card that allows access to APC terminals."
	trim = /datum/id_trim/away/old/apc

/obj/item/card/id/away/deep_storage //deepstorage.dmm space ruin
	name = "bunker access ID"

/obj/item/card/id/advanced
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station. Has an integrated digital display and advanced microchips."
	icon_state = "card_grey"
	worn_icon_state = "card_grey"

	wildcard_slots = WILDCARD_LIMIT_GREY

	/// An overlay icon state for when the card is assigned to a name. Usually manifests itself as a little scribble to the right of the job icon.
	var/assigned_icon_state = "assigned"

	/// If this is set, will manually override the icon file for the trim. Intended for admins to VV edit and chameleon ID cards.
	var/trim_icon_override
	/// If this is set, will manually override the icon state for the trim. Intended for admins to VV edit and chameleon ID cards.
	var/trim_state_override
	/// If this is set, will manually override the trim's assignmment for SecHUDs. Intended for admins to VV edit and chameleon ID cards.
	var/trim_assignment_override

/obj/item/card/id/advanced/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, .proc/update_intern_status)
	RegisterSignal(src, COMSIG_ITEM_DROPPED, .proc/remove_intern_status)

/obj/item/card/id/advanced/Destroy()
	UnregisterSignal(src, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	return ..()

/obj/item/card/id/advanced/proc/update_intern_status(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!user?.client)
		return
	if(!CONFIG_GET(flag/use_exp_tracking))
		return
	if(!CONFIG_GET(flag/use_low_living_hour_intern))
		return
	if(!SSdbcore.Connect())
		return

	var/intern_threshold = (CONFIG_GET(number/use_low_living_hour_intern_hours) * 60) || (CONFIG_GET(number/use_exp_restrictions_heads_hours) * 60) || INTERN_THRESHOLD_FALLBACK_HOURS * 60
	var/playtime = user.client.get_exp_living(pure_numeric = TRUE)

	if((intern_threshold >= playtime) && (user.mind?.assigned_role.title in SSjob.station_jobs))
		is_intern = TRUE
		update_label()
		return

	if(!is_intern)
		return

	is_intern = FALSE
	update_label()

/obj/item/card/id/advanced/proc/remove_intern_status(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!is_intern)
		return

	is_intern = FALSE
	update_label()

/obj/item/card/id/advanced/Moved(atom/OldLoc, Dir)
	. = ..()

/obj/item/card/id/advanced/update_overlays()
	. = ..()

	if(registered_name && registered_name != "Captain")
		. += mutable_appearance(icon, assigned_icon_state)

	var/trim_icon_file = trim_icon_override ? trim_icon_override : trim?.trim_icon
	var/trim_icon_state = trim_state_override ? trim_state_override : trim?.trim_state

	if(!trim_icon_file || !trim_icon_state)
		return

	. += mutable_appearance(trim_icon_file, trim_icon_state)

/obj/item/card/id/advanced/silver
	name = "silver identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "card_silver"
	worn_icon_state = "card_silver"
	inhand_icon_state = "silver_id"
	wildcard_slots = WILDCARD_LIMIT_SILVER

/datum/id_trim/maint_reaper
	access = list(ACCESS_MAINT_TUNNELS)
	trim_state = "trim_janitor"
	assignment = "Reaper"

/obj/item/card/id/advanced/silver/reaper
	name = "Thirteen's ID Card (Reaper)"
	trim = /datum/id_trim/maint_reaper
	registered_name = "Thirteen"

/obj/item/card/id/advanced/gold
	name = "gold identification card"
	desc = "A golden card which shows power and might."
	icon_state = "card_gold"
	worn_icon_state = "card_gold"
	inhand_icon_state = "gold_id"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/gold/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	registered_name = "Captain"
	trim = /datum/id_trim/job/captain
	registered_age = null

/obj/item/card/id/advanced/gold/captains_spare/update_label() //so it doesn't change to Captain's ID card (Captain) on a sneeze
	if(registered_name == "Captain")
		name = "[initial(name)][(!assignment || assignment == "Captain") ? "" : " ([assignment])"]"
		update_appearance(UPDATE_ICON)
	else
		..()

/obj/item/card/id/advanced/centcom
	name = "\improper CentCom ID"
	desc = "An ID straight from Central Command."
	icon_state = "card_centcom"
	worn_icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	registered_name = "Central Command"
	registered_age = null
	trim = /datum/id_trim/centcom
	wildcard_slots = WILDCARD_LIMIT_CENTCOM

/obj/item/card/id/advanced/centcom/ert
	name = "\improper CentCom ID"
	desc = "An ERT ID card."
	registered_age = null
	registered_name = "Emergency Response Intern"
	trim = /datum/id_trim/centcom/ert

/obj/item/card/id/advanced/centcom/ert
	registered_name = "Emergency Response Team Commander"
	trim = /datum/id_trim/centcom/ert/commander

/obj/item/card/id/advanced/centcom/ert/security
	registered_name = "Security Response Officer"
	trim = /datum/id_trim/centcom/ert/security

/obj/item/card/id/advanced/centcom/ert/engineer
	registered_name = "Engineering Response Officer"
	trim = /datum/id_trim/centcom/ert/engineer

/obj/item/card/id/advanced/centcom/ert/medical
	registered_name = "Medical Response Officer"
	trim = /datum/id_trim/centcom/ert/medical

/obj/item/card/id/advanced/centcom/ert/chaplain
	registered_name = "Religious Response Officer"
	trim = /datum/id_trim/centcom/ert/chaplain

/obj/item/card/id/advanced/centcom/ert/janitor
	registered_name = "Janitorial Response Officer"
	trim = /datum/id_trim/centcom/ert/janitor

/obj/item/card/id/advanced/centcom/ert/clown
	registered_name = "Entertainment Response Officer"
	trim = /datum/id_trim/centcom/ert/clown

/obj/item/card/id/advanced/black
	name = "black identification card"
	desc = "This card is telling you one thing and one thing alone. The person holding this card is an utter badass."
	icon_state = "card_black"
	worn_icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/black/deathsquad
	name = "\improper Death Squad ID"
	desc = "A Death Squad ID card."
	registered_name = "Death Commando"
	trim = /datum/id_trim/centcom/deathsquad
	wildcard_slots = WILDCARD_LIMIT_DEATHSQUAD

/obj/item/card/id/advanced/black/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	registered_age = null
	trim = /datum/id_trim/syndicom
	wildcard_slots = WILDCARD_LIMIT_SYNDICATE

/obj/item/card/id/advanced/black/syndicate_command/crew_id
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	trim = /datum/id_trim/syndicom/crew

/obj/item/card/id/advanced/black/syndicate_command/captain_id
	name = "syndicate captain ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	trim = /datum/id_trim/syndicom/captain

/obj/item/card/id/advanced/debug
	name = "\improper Debug ID"
	desc = "A debug ID card. Has ALL the all access, you really shouldn't have this."
	icon_state = "card_centcom"
	worn_icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	trim = /datum/id_trim/admin
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/advanced/debug/fret
	name = "\improper FRET agent ID card"
	desc = "A fast response emergency tech ID card. Complete access."
	icon_state = "card_gold"
	worn_icon_state = "card_gold"
	inhand_icon_state = "gold_id"
	trim = /datum/id_trim/admin

/obj/item/card/id/advanced/prisoner
	name = "prisoner ID card"
	desc = "You are a number, you are not a free man."
	icon_state = "card_prisoner"
	worn_icon_state = "card_prisoner"
	inhand_icon_state = "orange-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	registered_name = "Scum"
	registered_age = null
	trim = /datum/id_trim/job/prisoner

	wildcard_slots = WILDCARD_LIMIT_PRISONER

	/// Number of gulag points required to earn freedom.
	var/goal = 0
	/// Number of gulag points earned.
	var/points = 0

/obj/item/card/id/advanced/prisoner/attack_self(mob/user)
	to_chat(usr, SPAN_NOTICE("You have accumulated [points] out of the [goal] points you need for freedom."))

/obj/item/card/id/advanced/prisoner/one
	name = "Prisoner #13-001"
	registered_name = "Prisoner #13-001"
	trim = /datum/id_trim/job/prisoner/one

/obj/item/card/id/advanced/prisoner/two
	name = "Prisoner #13-002"
	registered_name = "Prisoner #13-002"
	trim = /datum/id_trim/job/prisoner/two

/obj/item/card/id/advanced/prisoner/three
	name = "Prisoner #13-003"
	registered_name = "Prisoner #13-003"
	trim = /datum/id_trim/job/prisoner/three

/obj/item/card/id/advanced/prisoner/four
	name = "Prisoner #13-004"
	registered_name = "Prisoner #13-004"
	trim = /datum/id_trim/job/prisoner/four

/obj/item/card/id/advanced/prisoner/five
	name = "Prisoner #13-005"
	registered_name = "Prisoner #13-005"
	trim = /datum/id_trim/job/prisoner/five

/obj/item/card/id/advanced/prisoner/six
	name = "Prisoner #13-006"
	registered_name = "Prisoner #13-006"
	trim = /datum/id_trim/job/prisoner/six

/obj/item/card/id/advanced/prisoner/seven
	name = "Prisoner #13-007"
	registered_name = "Prisoner #13-007"
	trim = /datum/id_trim/job/prisoner/seven

/obj/item/card/id/advanced/mining
	name = "mining ID"
	trim = /datum/id_trim/job/shaft_miner/spare

/obj/item/card/id/advanced/highlander
	name = "highlander ID"
	registered_name = "Highlander"
	desc = "There can be only one!"
	icon_state = "card_black"
	worn_icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	trim = /datum/id_trim/highlander
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/advanced/engioutpost
	registered_name = "George 'Plastic' Miller"
	desc = "A card used to provide ID and determine access across the station. There's blood dripping from the corner. Ew."
	trim = /datum/id_trim/engioutpost
	registered_age = 47

/obj/item/card/id/advanced/simple_bot
	name = "simple bot ID card"
	desc = "An internal ID card used by the station's non-sentient bots. You should report this to a coder if you're holding it."
	wildcard_slots = WILDCARD_LIMIT_ADMIN

#undef INTERN_THRESHOLD_FALLBACK_HOURS
#undef ID_ICON_BORDERS
