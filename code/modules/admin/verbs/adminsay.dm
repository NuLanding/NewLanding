/client/proc/cmd_admin_say(msg as text)
	set category = "Admin"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = TRUE
	var/deadminned_asayer = (ckey in GLOB.asay_deadmins) ? TRUE : FALSE
	if(!deadminned_asayer && !check_rights(0))
		return

	msg = emoji_parse(copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)
		return

	mob.log_talk(msg, LOG_ASAY)
	msg = keywords_lookup(msg)
	var/custom_asay_color = (CONFIG_GET(flag/allow_admin_asaycolor) && prefs.asaycolor) ? "<font color=[prefs.asaycolor]>" : "<font color='#FF4500'>"
	msg = "[SPAN_ADMINSAY("[SPAN_PREFIX("ADMIN:")] <EM>[key_name(usr, 1)]</EM> [ADMIN_FLW(mob)][deadminned_asayer ? "(D)" : ""]: [custom_asay_color]<span class='message linkify'>[msg]")]</span>[custom_asay_color ? "</font>":null]"
	var/list/recipients = GLOB.admins.Copy()
	for(var/recipient_key in GLOB.asay_deadmins)
		var/client/recipient = get_client_by_ckey(recipient_key)
		if(recipient)
			recipients |= recipient
	to_chat(recipients,
		type = MESSAGE_TYPE_ADMINCHAT,
		html = msg,
		confidential = TRUE)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Asay") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text|null
	cmd_admin_say(msg)
