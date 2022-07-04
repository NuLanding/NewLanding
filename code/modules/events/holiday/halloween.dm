/datum/round_event_control/spooky
	name = "2 SPOOKY! (Halloween)"
	holidayID = HALLOWEEN
	typepath = /datum/round_event/spooky
	weight = -1 //forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/spooky/start()
	..()

/datum/round_event/spooky/announce(fake)
	priority_announce(pick("RATTLE ME BONES!","THE RIDE NEVER ENDS!", "A SKELETON POPS OUT!", "SPOOKY SCARY SKELETONS!", "CREWMEMBERS BEWARE, YOU'RE IN FOR A SCARE!") , "THE CALL IS COMING FROM INSIDE THE HOUSE")
