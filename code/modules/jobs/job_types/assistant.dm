/*
Assistant
*/
/datum/job/assistant
	title = "Assistant"
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/assistant

	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	no_dresscode = TRUE
	blacklist_dresscode_slots = list(ITEM_SLOT_EARS,ITEM_SLOT_BELT,ITEM_SLOT_ID,ITEM_SLOT_BACK) //headset, PDA, ID, backpack are important items

	required_languages = null

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS


/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant
	id_trim = /datum/id_trim/job/assistant
