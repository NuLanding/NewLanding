//NEVER USE THIS IT SUX -PETETHEGOAT
//IT SUCKS A BIT LESS -GIACOM

/obj/item/paint
	gender= PLURAL
	name = "paint"
	desc = "Used to recolor floors and walls. Can be removed by the janitor."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "paint_neutral"
	inhand_icon_state = "paintcan"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	max_integrity = 100
	/// With what color will we paint with
	var/paint_color = COLOR_WHITE
	/// How many uses are left
	var/paintleft = 10

/obj/item/paint/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Paint wall stripes by right clicking a walls.")

/obj/item/paint/red
	name = "red paint"
	paint_color = COLOR_RED
	icon_state = "paint_red"

/obj/item/paint/green
	name = "green paint"
	paint_color = COLOR_VIBRANT_LIME
	icon_state = "paint_green"

/obj/item/paint/blue
	name = "blue paint"
	paint_color = COLOR_BLUE
	icon_state = "paint_blue"

/obj/item/paint/yellow
	name = "yellow paint"
	paint_color = COLOR_YELLOW
	icon_state = "paint_yellow"

/obj/item/paint/violet
	name = "violet paint"
	paint_color = COLOR_MAGENTA
	icon_state = "paint_violet"

/obj/item/paint/black
	name = "black paint"
	paint_color = COLOR_ALMOST_BLACK
	icon_state = "paint_black"

/obj/item/paint/white
	name = "white paint"
	paint_color = COLOR_WHITE
	icon_state = "paint_white"

/obj/item/paint/anycolor
	gender = PLURAL
	name = "adaptive paint"
	icon_state = "paint_neutral"
	custom_price = PAYCHECK_HARD * 2 //200 bucks for premium paint

/obj/item/paint/anycolor/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Choose a basic color by using the paint.")
	. += SPAN_NOTICE("Choose any color by alt-clicking the paint.")

/obj/item/paint/anycolor/AltClick(mob/living/user)
	var/new_paint_color = input(user, "Choose new paint color", "Paint Color", paint_color) as color|null
	if(new_paint_color)
		paint_color = new_paint_color
		icon_state = "paint_neutral"

/obj/item/paint/anycolor/attack_self(mob/user)
	var/list/possible_colors = list(
		"black" = image(icon = src.icon, icon_state = "paint_black"),
		"blue" = image(icon = src.icon, icon_state = "paint_blue"),
		"green" = image(icon = src.icon, icon_state = "paint_green"),
		"red" = image(icon = src.icon, icon_state = "paint_red"),
		"violet" = image(icon = src.icon, icon_state = "paint_violet"),
		"white" = image(icon = src.icon, icon_state = "paint_white"),
		"yellow" = image(icon = src.icon, icon_state = "paint_yellow")
		)
	var/picked_color = show_radial_menu(user, src, possible_colors, custom_check = CALLBACK(src, .proc/check_menu, user), radius = 38, require_near = TRUE)
	switch(picked_color)
		if("black")
			paint_color = COLOR_ALMOST_BLACK
		if("blue")
			paint_color = COLOR_BLUE
		if("green")
			paint_color = COLOR_VIBRANT_LIME
		if("red")
			paint_color = COLOR_RED
		if("violet")
			paint_color = COLOR_MAGENTA
		if("white")
			paint_color = COLOR_WHITE
		if("yellow")
			paint_color = COLOR_YELLOW
		else
			return
	icon_state = "paint_[picked_color]"
	add_fingerprint(user)

/**
 * Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with the menu
 */
/obj/item/paint/anycolor/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(!user.is_holding(src))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/paint/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(.)
		return
	if(!proximity)
		return
	if(paintleft <= 0)
		icon_state = "paint_empty"
		return
	if(!isturf(target) || isspaceturf(target))
		return TRUE
	target.add_atom_colour(paint_color, WASHABLE_COLOUR_PRIORITY)

/obj/item/paint_remover
	gender =  PLURAL
	name = "paint remover"
	desc = "Used to remove color from anything."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "paint_neutral"
	inhand_icon_state = "paintcan"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	max_integrity = 100

/obj/item/paint_remover/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Remove wall stripe paint by right-clicking a wall.")

/obj/item/paint_remover/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(.)
		return
	if(!proximity)
		return
	if(!isturf(target) && !isobj(target))
		return
	if(target.color != initial(target.color))
		target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
