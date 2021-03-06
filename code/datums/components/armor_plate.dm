/datum/component/armor_plate
	var/amount = 0
	var/maxamount = 3
	var/upgrade_item = /obj/item/stack/sheet/animalhide/goliath_hide
	var/datum/armor/added_armor = list(MELEE = 10)
	var/upgrade_name

/datum/component/armor_plate/Initialize(_maxamount,obj/item/_upgrade_item,datum/armor/_added_armor)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/examine)
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/applyplate)
	RegisterSignal(parent, COMSIG_PARENT_PREQDELETED, .proc/dropplates)

	if(_maxamount)
		maxamount = _maxamount
	if(_upgrade_item)
		upgrade_item = _upgrade_item
	if(_added_armor)
		if(islist(_added_armor))
			added_armor = getArmor(arglist(_added_armor))
		else if (istype(_added_armor, /datum/armor))
			added_armor = _added_armor
		else
			stack_trace("Invalid type [_added_armor.type] passed as _armor_item argument to armorplate component")
	else
		added_armor = getArmor(arglist(added_armor))
	var/obj/item/typecast = upgrade_item
	upgrade_name = initial(typecast.name)

/datum/component/armor_plate/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	//upgrade_item could also be typecast here instead
	if(amount)
		examine_list += SPAN_NOTICE("It has been strengthened with [amount]/[maxamount] [upgrade_name].")
	else
		examine_list += SPAN_NOTICE("It can be strengthened with up to [maxamount] [upgrade_name].")

/datum/component/armor_plate/proc/applyplate(datum/source, obj/item/I, mob/user, params)
	SIGNAL_HANDLER

	if(!istype(I,upgrade_item))
		return
	if(amount >= maxamount)
		to_chat(user, SPAN_WARNING("You can't improve [parent] any further!"))
		return

	if(istype(I,/obj/item/stack))
		I.use(1)
	else
		if(length(I.contents))
			to_chat(user, SPAN_WARNING("[I] cannot be used for armoring while there's something inside!"))
			return
		qdel(I)

	var/obj/O = parent
	amount++
	O.armor = O.armor.attachArmor(added_armor)

	SEND_SIGNAL(O, COMSIG_ARMOR_PLATED, amount, maxamount)
	to_chat(user, SPAN_INFO("You strengthen [O], improving its resistance against melee attacks."))


/datum/component/armor_plate/proc/dropplates(datum/source, force)
	SIGNAL_HANDLER
	return
