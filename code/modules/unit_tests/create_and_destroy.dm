///Delete one of every type, sleep a while, then check to see if anything has gone fucky
/datum/unit_test/create_and_destroy
	//You absolutely must run last
	priority = TEST_DEL_WORLD

/datum/unit_test/create_and_destroy/Run()
	//We'll spawn everything here
	var/turf/spawn_at = run_loc_floor_bottom_left
	var/list/ignore = list(
		//Never meant to be created, errors out the ass for mobcode reasons
		/mob/living/carbon,
		//Nother template type, doesn't like being created with no seed
		/obj/item/food/grown,
		//Say it with me now, type template
		/obj/effect/mapping_helpers/component_injector,
		//template type
		/obj/effect/mapping_helpers/trait_injector,
		//Singleton
		/mob/dview,
		//Template,
		/obj/effect/mapping_helpers/custom_icon,
		//Is initialized with a trauma
		/mob/camera/imaginary_friend,
		//Created and managed by a projector
		/obj/structure/projected_forcefield,
		//Deepfrying logic manages this
		/obj/item/food/deepfryholder,
	)
	//This turf existing is an error in and of itself
	ignore += typesof(/turf/baseturf_skipover)
	ignore += typesof(/turf/baseturf_bottom)
	//Needs special input, let's be nice
	ignore += typesof(/obj/effect/abstract/proximity_checker)
	//Very finiky, blacklisting to make things easier
	ignore += typesof(/obj/item/poster/wanted)
	//We can't pass a mind into this
	ignore += typesof(/obj/item/phylactery)
	//This expects a seed, we can't pass it
	ignore += typesof(/obj/item/food/grown)
	//Nothing to hallucinate if there's nothing to hallicinate
	ignore += typesof(/obj/effect/hallucination)
	//These want fried food to take on the shape of, we can't pass that in
	ignore += typesof(/obj/item/food/deepfryholder)
	//Can't pass in a thing to glow
	ignore += typesof(/obj/effect/abstract/eye_lighting)
	//It wants a lot more context then we have
	ignore += typesof(/obj/effect/buildmode_line)
	//We don't have a pod
	ignore += typesof(/obj/effect/pod_landingzone_effect)
	ignore += typesof(/obj/effect/pod_landingzone)
	//There's no shapeshift to hold
	ignore += typesof(/obj/shapeshift_holder)
	//No tauma to pass in
	ignore += typesof(/mob/camera/imaginary_friend)
	//Our system doesn't support it without warning spam from unregister calls on things that never registered
	ignore += typesof(/obj/docking_port)
	//Asks for a shuttle that may not exist, let's leave it alone
	ignore += typesof(/obj/item/pinpointer/shuttle)
	//Leads to errors as a consequence of the logic behind moving back to a tile that's moving you somewhere else
	ignore += typesof(/obj/effect/mapping_helpers/component_injector/areabound)
	//Expects a mob to holderize, we have nothing to give
	ignore += typesof(/obj/item/clothing/head/mob_holder)
	//Mold structures expect to be managed by a controller
	ignore += typesof(/obj/structure/mold)
	//Screen objects have all sorts of dependencies
	ignore += typesof(/atom/movable/screen)
	//Plane master controllers expect to be managed by huds
	ignore += typesof(/atom/movable/plane_master_controller)
	//Spews warnings about not causing a change as there is no wall
	ignore += typesof(/obj/effect/mapping_helpers/paint_wall)

	var/list/cached_contents = spawn_at.contents.Copy()

	//Change the turf for consistency
	spawn_at.ChangeTurf(/turf/open/floor/grass, /turf/baseturf_skipover)
	var/baseturf_count = length(spawn_at.baseturfs)

	for(var/type_path in typesof(/atom/movable, /turf) - ignore) //No areas please
		if(ispath(type_path, /turf))
			spawn_at.ChangeTurf(type_path, /turf/baseturf_skipover)
			//We change it back to prevent pain, please don't ask
			spawn_at.ChangeTurf(/turf/open/floor/grass, /turf/baseturf_skipover)
			if(baseturf_count != length(spawn_at.baseturfs))
				Fail("[type_path] changed the amount of baseturfs we have [baseturf_count] -> [length(spawn_at.baseturfs)]")
				baseturf_count = length(spawn_at.baseturfs)
		else
			var/atom/creation = new type_path(spawn_at)
			if(QDELETED(creation))
				continue
			//Go all in
			qdel(creation, force = TRUE)
			//This will hold a ref to the last thing we process unless we set it to null
			//Yes byond is fucking sinful
			creation = null

		//There's a lot of stuff that either spawns stuff in on create, or removes stuff on destroy. Let's cut it all out so things are easier to deal with
		var/list/to_del = spawn_at.contents - cached_contents
		if(length(to_del))
			for(var/atom/to_kill in to_del)
				qdel(to_kill)

	//Hell code, we're bound to have ended the round somehow so let's stop if from ending while we work
	SSticker.delay_end = TRUE
	//Prevent the garbage subsystem from harddeling anything, if only to save time
	SSgarbage.collection_timeout[GC_QUEUE_HARDDELETE] = 10000 HOURS
	//Clear it, just in case
	cached_contents.Cut()

	//Now that we've qdel'd everything, let's sleep until the gc has processed all the shit we care about
	var/time_needed = SSgarbage.collection_timeout[GC_QUEUE_CHECK]
	var/start_time = world.time
	var/garbage_queue_processed = FALSE

	sleep(time_needed)
	while(!garbage_queue_processed)
		var/list/queue_to_check = SSgarbage.queues[GC_QUEUE_CHECK]
		//How the hell did you manage to empty this? Good job!
		if(!length(queue_to_check))
			garbage_queue_processed = TRUE
			break

		var/list/oldest_packet = queue_to_check[1]
		//Pull out the time we deld at
		var/qdeld_at = oldest_packet[1]
		//If we've found a packet that got del'd later then we finished, then all our shit has been processed
		if(qdeld_at > start_time)
			garbage_queue_processed = TRUE
			break

		if(world.time > start_time + time_needed + 8 MINUTES)
			Fail("Something has gone horribly wrong, the garbage queue has been processing for well over 10 minutes. What the hell did you do")
			break

		//Immediately fire the gc right after
		SSgarbage.next_fire = 1
		//Unless you've seriously fucked up, queue processing shouldn't take "that" long. Let her run for a bit, see if anything's changed
		sleep(20 SECONDS)

	//Alright, time to see if anything messed up
	var/list/cache_for_sonic_speed = SSgarbage.items
	for(var/path in cache_for_sonic_speed)
		var/datum/qdel_item/item = cache_for_sonic_speed[path]
		if(item.failures)
			Fail("[item.name] hard deleted [item.failures] times out of a total del count of [item.qdels]")
		if(item.no_respect_force)
			Fail("[item.name] failed to respect force deletion [item.no_respect_force] times out of a total del count of [item.qdels]")
		if(item.no_hint)
			Fail("[item.name] failed to return a qdel hint [item.no_hint] times out of a total del count of [item.qdels]")

	cache_for_sonic_speed = SSatoms.BadInitializeCalls
	for(var/path in cache_for_sonic_speed)
		var/fails = cache_for_sonic_speed[path]
		if(fails & BAD_INIT_NO_HINT)
			Fail("[path] didn't return an Initialize hint")
		if(fails & BAD_INIT_QDEL_BEFORE)
			Fail("[path] qdel'd in New()")
		if(fails & BAD_INIT_SLEPT)
			Fail("[path] slept during Initialize()")

	SSticker.delay_end = FALSE
	//This shouldn't be needed, but let's be polite
	SSgarbage.collection_timeout[GC_QUEUE_HARDDELETE] = 10 SECONDS
