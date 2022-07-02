/datum/job
	/// The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title = "NOPE"

	/// Determines who can demote this position
	var/department_head = list()

	/// Tells the given channels that the given mob is the new department head. See communications.dm for valid channels.
	var/list/head_announce = null

	/// Bitflags for the job
	var/auto_deadmin_role_flags = NONE

	/// Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = FACTION_NONE

	/// How many players can be this job
	var/total_positions = 0

	/// How many players can spawn in as this job
	var/spawn_positions = 0

	/// How many players have this job
	var/current_positions = 0

	/// Supervisors, who this person answers to directly
	var/supervisors = ""

	/// Selection screen color
	var/selection_color = "#ffffff"

	/// What kind of mob type joining players with this job as their assigned role are spawned as.
	var/spawn_type = /mob/living/carbon/human

	/// If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	/// If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/outfit = null

	/// The job's outfit that will be assigned for plasmamen.
	var/plasmaman_outfit = null

	/// Minutes of experience-time required to play in this job. The type is determined by [exp_required_type] and [exp_required_type_department] depending on configs.
	var/exp_requirements = 0
	/// Experience required to play this job, if the config is enabled, and `exp_required_type_department` is not enabled with the proper config.
	var/exp_required_type = ""
	/// Department experience required to play this job, if the config is enabled.
	var/exp_required_type_department = ""
	/// Experience type granted by playing in this job.
	var/exp_granted_type = ""

	var/display_order = JOB_DISPLAY_ORDER_DEFAULT

	/// Goodies that can be received via the mail system.
	// this is a weighted list.
	/// Keep the _job definition for this empty and use /obj/item/mail to define general gifts.
	var/list/mail_goodies = list()

	/// If this job's mail goodies compete with generic goodies.
	var/exclusive_mail_goodies = FALSE

	/// Bitfield of departments this job belongs to. These get setup when adding the job into the department, on job datum creation.
	var/departments_bitflags = NONE
	/// Lazy list with the departments this job belongs to.
	var/list/departments_list = null

	/// Should this job be allowed to be picked for the bureaucratic error event?
	var/allow_bureaucratic_error = TRUE

	/// List of family heirlooms this job can get with the family heirloom quirk. List of types.
	var/list/family_heirlooms

	/// With this set to TRUE, the loadout will be applied before a job clothing will be
	var/no_dresscode
	/// Whether the job can use the loadout system
	var/loadout = TRUE
	/// List of banned quirks in their names(dont blame me, that's how they're stored), players can't join as the job if they have the quirk. Associative for the purposes of performance
	var/list/banned_quirks
	/// A list of slots that can't have loadout items assigned to them if no_dresscode is applied, used for important items such as ID, PDA, backpack and headset
	var/list/blacklist_dresscode_slots
	/// Whitelist of allowed species for this job. If not specified then all roundstart races can be used. Associative with TRUE
	var/list/species_whitelist
	/// Blacklist of species for this job.
	var/list/species_blacklist
	/// Which languages does the job require, associative to LANGUAGE_UNDERSTOOD or LANGUAGE_SPOKEN
	var/list/required_languages = list(/datum/language/common = LANGUAGE_SPOKEN)
	/// All values = (JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT)
	var/job_flags = NONE

	/// Multiplier for general usage of the voice of god.
	var/voice_of_god_power = 1
	/// Multiplier for the silence command of the voice of god.
	var/voice_of_god_silence_power = 1

	/// String. If set to a non-empty one, it will be the key for the policy text value to show this role on spawn.
	var/policy_index = ""
	/// The job listing that the job belongs to
	var/datum/job_listing/job_listing


/datum/job/New(datum/job_listing/passed_job_listing)
	. = ..()
	job_listing = passed_job_listing
	var/list/jobs_changes = get_map_changes()
	if(!jobs_changes)
		return
	if(isnum(jobs_changes["spawn_positions"]))
		spawn_positions = jobs_changes["spawn_positions"]
	if(isnum(jobs_changes["total_positions"]))
		total_positions = jobs_changes["total_positions"]

/// Loads up map configs if necessary and returns job changes for this job.
/datum/job/proc/get_map_changes()
	var/string_type = "[type]"
	var/list/splits = splittext(string_type, "/")
	var/endpart = splits[splits.len]

	var/list/job_changes = SSmapping.config.job_changes
	if(!(endpart in job_changes))
		return list()

	return job_changes[endpart]


/// Executes after the mob has been spawned in the map. Client might not be yet in the mob, and is thus a separate variable.
/datum/job/proc/after_spawn(mob/living/spawned, client/player_client)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_SPAWN, src, spawned, player_client)


/datum/job/proc/announce_job(mob/living/joining_mob)
	if(head_announce)
		announce_head(joining_mob, head_announce)


//Used for a special check of whether to allow a client to latejoin as this job.
/datum/job/proc/special_check_latejoin(client/C)
	return TRUE


/mob/living/proc/on_job_equipping(datum/job/equipping, apply_loadout = FALSE)
	return

/mob/living/carbon/human/on_job_equipping(datum/job/equipping, apply_loadout = FALSE, player_client)
	dress_up_as_job(equipping, apply_loadout = apply_loadout, player_client = player_client)


/mob/living/proc/dress_up_as_job(datum/job/equipping, visual_only = FALSE, apply_loadout = FALSE)
	return

/mob/living/carbon/human/dress_up_as_job(datum/job/equipping, visual_only = FALSE, apply_loadout = FALSE, player_client)
	var/list/packed_items
	var/loadout_asserted = FALSE
	var/client/used_client = player_client || client
	if(apply_loadout && equipping.loadout && used_client)
		loadout_asserted = TRUE
		if(equipping.no_dresscode)
			packed_items = used_client.prefs.equip_preference_loadout(src, FALSE, equipping, blacklist = equipping.blacklist_dresscode_slots, initial = TRUE)
	dna.species.pre_equip_species_outfit(equipping, src, visual_only)
	equipOutfit(equipping.outfit, visual_only)
	if(loadout_asserted && !equipping.no_dresscode)
		packed_items = used_client.prefs.equip_preference_loadout(src, FALSE, equipping, blacklist = equipping.blacklist_dresscode_slots, initial = TRUE)
	if(packed_items)
		used_client.prefs.add_packed_items(src, packed_items)


/datum/job/proc/announce_head(mob/living/carbon/human/H, channels) //tells the given channel that the given mob is the new department head. See communications.dm for valid channels.
	return

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return TRUE //Available in 0 days = available right now = player is old enough to play.
	return FALSE


/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!SSdbcore.Connect())
		return 0 //Without a database connection we can't get a player's age so we'll assume they're old enough for all jobs
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

/datum/job/proc/config_check()
	return TRUE

/datum/job/proc/map_check()
	var/list/job_changes = get_map_changes()
	if(!job_changes)
		return FALSE
	return TRUE

/datum/job/proc/radio_help_message(mob/M)
	to_chat(M, "<b>Prefix your message with :h to speak on your department's radio. To see other prefixes, look closely at your headset.</b>")

/datum/outfit/job
	name = "Standard Gear"


/// An overridable getter for more dynamic goodies.
/datum/job/proc/get_mail_goodies(mob/recipient)
	return mail_goodies

/datum/job/proc/get_captaincy_announcement(mob/living/captain)
	return "Due to extreme staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"


/// Returns an atom where the mob should spawn in.
/datum/job/proc/get_spawn_point(roundstart = TRUE)
	if(!job_listing)
		CRASH("Tried to get a spawn point of a job that has no job listing. Job: [type].")
	if(roundstart)
		if(length(job_listing.job_start_landmarks[type]))
			return evaluated_start_landmark(job_listing.job_start_landmarks[type], roundstart)
		if(length(job_listing.start_landmarks))
			return evaluated_start_landmark(job_listing.start_landmarks, roundstart)
	else
		if(length(job_listing.job_latejoin_landmarks[type]))
			return evaluated_start_landmark(job_listing.job_latejoin_landmarks[type], roundstart)
		if(length(job_listing.latejoin_landmarks))
			return evaluated_start_landmark(job_listing.latejoin_landmarks, roundstart)

#define LATEJOIN_SPAWN_COOLDOWN 3 MINUTES

/// Returns a landmark while respecting things like roundstart positions, latejoin cooldowns etc.
/datum/job/proc/evaluated_start_landmark(list/landmark_list, roundstart)
	for(var/obj/effect/landmark/start/mark as anything in shuffle(landmark_list))
		// Set the landmark in case all of them fail, we want to use one regardless of cooldown / being taken
		. = mark
		if(roundstart)
			if(mark.spawned_roundstart)
				continue
			mark.spawned_roundstart = TRUE
			return mark
		else
			if(mark.next_latejoin_spawn > world.time)
				continue
			mark.next_latejoin_spawn = world.time + LATEJOIN_SPAWN_COOLDOWN
			return mark

#undef LATEJOIN_SPAWN_COOLDOWN

/// Spawns the mob to be played as, taking into account preferences and the desired spawn point.
/datum/job/proc/get_spawn_mob(client/player_client, atom/spawn_point)
	var/mob/living/spawn_instance
	spawn_instance = new spawn_type(player_client.mob.loc)
	spawn_point.JoinPlayerHere(spawn_instance, TRUE)
	spawn_instance.apply_prefs_job(player_client, src)
	if(!player_client)
		qdel(spawn_instance)
		return // Disconnected while checking for the appearance ban.
	return spawn_instance


/// Applies the preference options to the spawning mob, taking the job into account. Assumes the client has the proper mind.
/mob/living/proc/apply_prefs_job(client/player_client, datum/job/job)


/mob/living/carbon/human/apply_prefs_job(client/player_client, datum/job/job)
	if(!player_client)
		return // Disconnected while checking for the appearance ban.
	if(GLOB.current_anonymous_theme)
		fully_replace_character_name(null, GLOB.current_anonymous_theme.anonymous_name(src))
	player_client.prefs.apply_prefs_to(src)
	dna.update_dna_identity()

/**
 * Called after a successful roundstart spawn.
 * Client is not yet in the mob.
 * This happens after after_spawn()
 */
/datum/job/proc/after_roundstart_spawn(mob/living/spawning, client/player_client)
	SHOULD_CALL_PARENT(TRUE)


/**
 * Called after a successful latejoin spawn.
 * Client is in the mob.
 * This happens after after_spawn()
 */
/datum/job/proc/after_latejoin_spawn(mob/living/spawning)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_LATEJOIN_SPAWN, src, spawning)

/datum/job/proc/has_banned_quirk(datum/preferences/pref)
	if(!pref) //No preferences? We'll let you pass, this time (just a precautionary check,you dont wanna mess up gamemode setting logic)
		return FALSE
	if(banned_quirks)
		for(var/Q in pref.all_quirks)
			if(banned_quirks[Q])
				return TRUE
	return FALSE

/datum/job/proc/has_banned_species(datum/preferences/pref)
	var/my_id = pref.pref_species.id
	if(species_whitelist && !species_whitelist[my_id])
		return TRUE
	else if(!GLOB.roundstart_races[my_id])
		return TRUE
	if(species_blacklist && species_blacklist[my_id])
		return TRUE
	return FALSE

/datum/job/proc/has_required_languages(datum/preferences/pref)
	if(!required_languages)
		return TRUE
	for(var/lang in required_languages)
		//Doesnt have language, or the required "level" is too low (understood, while needing spoken)
		if(!pref.languages[lang] || pref.languages[lang] < required_languages[lang])
			return FALSE
	return TRUE
