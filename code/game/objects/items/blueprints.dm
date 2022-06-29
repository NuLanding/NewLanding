#define AREA_ERRNONE 0
#define AREA_STATION 1
#define AREA_SPACE 2
#define AREA_SPECIAL 3

/obj/item/areaeditor
	name = "area modification item"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "blueprints"
	attack_verb_continuous = list("attacks", "baps", "hits")
	attack_verb_simple = list("attack", "bap", "hit")
	var/fluffnotice = "Nobody's gonna read this stuff!"
	var/in_use = FALSE

/obj/item/areaeditor/attack_self(mob/user)
	add_fingerprint(user)
	. = "<BODY><HTML><head><title>[src]</title></head> \
				<h2>[station_name()] [src.name]</h2> \
				<small>[fluffnotice]</small><hr>"
	switch(get_area_type())
		if(AREA_SPACE)
			. += "<p>According to the [src.name], you are now in an unclaimed territory.</p>"
		if(AREA_SPECIAL)
			. += "<p>This place is not noted on the [src.name].</p>"
	. += "<p><a href='?src=[REF(src)];create_area=1'>Create or modify an existing area</a></p>"


/obj/item/areaeditor/Topic(href, href_list)
	if(..())
		return TRUE
	if(!usr.canUseTopic(src) || usr != loc)
		usr << browse(null, "window=blueprints")
		return TRUE
	if(href_list["create_area"])
		if(in_use)
			return
		var/area/A = get_area(usr)
		if(A.area_flags & NOTELEPORT)
			to_chat(usr, SPAN_WARNING("You cannot edit restricted areas."))
			return
		in_use = TRUE
		create_area(usr)
		in_use = FALSE
	updateUsrDialog()

/obj/item/areaeditor/proc/get_area_type(area/A)
	if (!A)
		A = get_area(usr)
	if(A.outdoors)
		return AREA_SPACE
	var/list/SPECIALS = list(
		/area/shuttle,
		/area/centcom,
		/area/asteroid,
		/area/tdome,
		/area/wizard_station
	)
	for (var/type in SPECIALS)
		if ( istype(A,type) )
			return AREA_SPECIAL
	return AREA_STATION

/obj/item/areaeditor/blueprints/proc/view_wire_devices(mob/user)
	var/message = "<br>You examine the wire legend.<br>"
	for(var/wireset in GLOB.wire_color_directory)
		message += "<br><a href='?src=[REF(src)];view_wireset=[wireset]'>[GLOB.wire_name_directory[wireset]]</a>"
	message += "</p>"
	return message

/obj/item/areaeditor/blueprints/proc/view_wire_set(mob/user, wireset)
	//for some reason you can't use wireset directly as a derefencer so this is the next best :/
	for(var/device in GLOB.wire_color_directory)
		if("[device]" == wireset) //I know... don't change it...
			var/message = "<p><b>[GLOB.wire_name_directory[device]]:</b>"
			for(var/Col in GLOB.wire_color_directory[device])
				var/wire_name = GLOB.wire_color_directory[device][Col]
				if(!findtext(wire_name, WIRE_DUD_PREFIX)) //don't show duds
					message += "<p><span style='color: [Col]'>[Col]</span>: [wire_name]</p>"
			message += "</p>"
			return message
	return ""

/obj/item/areaeditor/proc/edit_area()
	var/area/A = get_area(usr)
	var/prevname = "[A.name]"
	var/str = stripped_input(usr,"New area name:", "Area Creation", "", MAX_NAME_LEN)
	if(!str || !length(str) || str==prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, SPAN_WARNING("The given name is too long. The area's name is unchanged."))
		return

	rename_area(A, str)

	to_chat(usr, SPAN_NOTICE("You rename the '[prevname]' to '[str]'."))
	log_game("[key_name(usr)] has renamed [prevname] to [str]")
	A.update_areasize()
	interact()
	return TRUE

//Blueprint Subtypes

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
