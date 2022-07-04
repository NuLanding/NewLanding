/datum/round_event_control/spider_infestation
	name = "Spider Infestation"
	typepath = /datum/round_event/spider_infestation
	weight = 10
	max_occurrences = 1
	min_players = 20

	track = EVENT_TRACK_MAJOR //Spiders on tg can be absolutely bonkers
	tags = list(TAG_COMBAT)
	min_sec_crew = 2

/datum/round_event/spider_infestation
	announceWhen = 400

/datum/round_event/spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)

/datum/round_event/spider_infestation/announce(fake)
	priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", ANNOUNCER_ALIENS)

/datum/round_event/spider_infestation/start()
	return
