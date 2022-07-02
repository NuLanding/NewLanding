/obj/effect/proc_holder/spell/aoe_turf/knock
	name = "Knock"
	desc = "This spell opens nearby doors and closets."

	school = SCHOOL_TRANSMUTATION
	charge_max = 100
	clothes_req = FALSE
	invocation = "AULIE OXIN FIERA"
	invocation_type = INVOCATION_WHISPER
	range = 3
	cooldown_min = 20 //20 deciseconds reduction per rank

	action_icon_state = "knock"

/obj/effect/proc_holder/spell/aoe_turf/knock/cast(list/targets,mob/user = usr)
	SEND_SOUND(user, sound('sound/magic/knock.ogg'))
	return

/obj/effect/proc_holder/spell/aoe_turf/knock/proc/open_door()
	return

/obj/effect/proc_holder/spell/aoe_turf/knock/proc/open_closet(obj/structure/closet/C)
	if(C.lock)
		C.lock.set_locked_state(FALSE)
	C.open()
