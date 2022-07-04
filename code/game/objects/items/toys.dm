/* Toys!
 * Contains
 * Balloons
 * Fake singularity
 * Toy gun
 * Toy crossbow
 * Toy swords
 * Crayons
 * Snap pops
 * AI core prizes
 * Toy codex gigas
 * Skeleton toys
 * Cards
 * Toy nuke
 * Fake meteor
 * Foam armblade
 * Toy big red button
 * Beach ball
 * Toy xeno
 *      Kitty toys!
 * Snowballs
 * Clockwork Watches
 * Toy Daggers
 * Squeaky Brain
 * Broken Radio
 * Fake heretic codex
 * Fake Pierced Reality
 * Intento
 */

/obj/item/toy
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "katana"
	inhand_icon_state = "katana"
	worn_icon_state = "katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices")
	attack_verb_simple = list("attack", "slash", "stab", "slice")
	hitsound = 'sound/weapons/bladeslice.ogg'

/*
|| A Deck of Cards for playing various games of chance ||
*/



/obj/item/toy/cards
	resistance_flags = FLAMMABLE
	max_integrity = 50
	var/parentdeck = null
	var/deckstyle = "nanotrasen"
	var/card_hitsound = null
	var/card_force = 0
	var/card_throwforce = 0
	var/card_throw_speed = 3
	var/card_throw_range = 7
	var/list/card_attack_verb_continuous = list("attacks")
	var/list/card_attack_verb_simple = list("attack")


/obj/item/toy/cards/Initialize()
	. = ..()
	if(card_attack_verb_continuous)
		card_attack_verb_continuous = string_list(card_attack_verb_continuous)
	if(card_attack_verb_simple)
		card_attack_verb_simple = string_list(card_attack_verb_simple)


/obj/item/toy/cards/suicide_act(mob/living/carbon/user)
	user.visible_message(SPAN_SUICIDE("[user] is slitting [user.p_their()] wrists with \the [src]! It looks like [user.p_they()] [user.p_have()] a crummy hand!"))
	playsound(src, 'sound/items/cardshuffle.ogg', 50, TRUE)
	return BRUTELOSS

/obj/item/toy/cards/proc/apply_card_vars(obj/item/toy/cards/newobj, obj/item/toy/cards/sourceobj) // Applies variables for supporting multiple types of card deck
	if(!istype(sourceobj))
		return

/obj/item/toy/cards/deck
	name = "deck of cards"
	desc = "A deck of space-grade playing cards."
	icon = 'icons/obj/toy.dmi'
	deckstyle = "nanotrasen"
	icon_state = "deck_nanotrasen_full"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	var/list/cards = list()

/obj/item/toy/cards/deck/Initialize()
	. = ..()
	populate_deck()

///Generates all the cards within the deck.
/obj/item/toy/cards/deck/proc/populate_deck()
	icon_state = "deck_[deckstyle]_full"
	for(var/suit in list("Hearts", "Spades", "Clubs", "Diamonds"))
		cards += "Ace of [suit]"
		for(var/i in 2 to 10)
			cards += "[i] of [suit]"
		for(var/person in list("Jack", "Queen", "King"))
			cards += "[person] of [suit]"

//ATTACK HAND IGNORING PARENT RETURN VALUE
//ATTACK HAND NOT CALLING PARENT
/obj/item/toy/cards/deck/attack_hand(mob/user, list/modifiers)
	draw_card(user)

/obj/item/toy/cards/deck/proc/draw_card(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	var/choice = null
	if(cards.len == 0)
		to_chat(user, SPAN_WARNING("There are no more cards to draw!"))
		return
	var/obj/item/toy/cards/singlecard/H = new/obj/item/toy/cards/singlecard(user.loc)
	choice = cards[1]
	H.cardname = choice
	H.parentdeck = src
	var/O = src
	H.apply_card_vars(H,O)
	popleft(cards)
	H.pickup(user)
	user.put_in_hands(H)
	user.visible_message(SPAN_NOTICE("[user] draws a card from the deck."), SPAN_NOTICE("You draw a card from the deck."))
	update_appearance()
	return H

/obj/item/toy/cards/deck/update_icon_state()
	switch(cards.len)
		if(27 to INFINITY)
			icon_state = "deck_[deckstyle]_full"
		if(11 to 27)
			icon_state = "deck_[deckstyle]_half"
		if(1 to 11)
			icon_state = "deck_[deckstyle]_low"
		else
			icon_state = "deck_[deckstyle]_empty"
	return ..()

/obj/item/toy/cards/deck/attack_self(mob/user)
	if(cooldown < world.time - 50)
		cards = shuffle(cards)
		playsound(src, 'sound/items/cardshuffle.ogg', 50, TRUE)
		user.visible_message(SPAN_NOTICE("[user] shuffles the deck."), SPAN_NOTICE("You shuffle the deck."))
		cooldown = world.time

/obj/item/toy/cards/deck/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard))
		var/obj/item/toy/cards/singlecard/SC = I
		if(SC.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(SC))
				to_chat(user, SPAN_WARNING("The card is stuck to your hand, you can't add it to the deck!"))
				return
			cards += SC.cardname
			user.visible_message(SPAN_NOTICE("[user] adds a card to the bottom of the deck."),SPAN_NOTICE("You add the card to the bottom of the deck."))
			qdel(SC)
		else
			to_chat(user, SPAN_WARNING("You can't mix cards from other decks!"))
		update_appearance()
	else if(istype(I, /obj/item/toy/cards/cardhand))
		var/obj/item/toy/cards/cardhand/CH = I
		if(CH.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(CH))
				to_chat(user, SPAN_WARNING("The hand of cards is stuck to your hand, you can't add it to the deck!"))
				return
			cards += CH.currenthand
			user.visible_message(SPAN_NOTICE("[user] puts [user.p_their()] hand of cards in the deck."), SPAN_NOTICE("You put the hand of cards in the deck."))
			qdel(CH)
		else
			to_chat(user, SPAN_WARNING("You can't mix cards from other decks!"))
		update_appearance()
	else
		return ..()

/obj/item/toy/cards/deck/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || !(M.mobility_flags & MOBILITY_PICKUP))
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			to_chat(usr, SPAN_NOTICE("You pick up the deck."))

		else if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				to_chat(usr, SPAN_NOTICE("You pick up the deck."))

	else
		to_chat(usr, SPAN_WARNING("You can't reach it from here!"))



/obj/item/toy/cards/cardhand
	name = "hand of cards"
	desc = "A number of cards not in a deck, customarily held in ones hand."
	icon = 'icons/obj/toy.dmi'
	icon_state = "none"
	w_class = WEIGHT_CLASS_TINY
	var/list/currenthand = list()
	var/choice = null

/obj/item/toy/cards/cardhand/attack_self(mob/user)
	var/list/handradial = list()
	interact(user)

	for(var/t in currenthand)
		handradial[t] = image(icon = src.icon, icon_state = "sc_[t]_[deckstyle]")

	if(usr.stat || !ishuman(usr))
		return
	var/mob/living/carbon/human/cardUser = usr
	if(!(cardUser.mobility_flags & MOBILITY_USE))
		return
	var/O = src
	var/choice = show_radial_menu(usr,src, handradial, custom_check = CALLBACK(src, .proc/check_menu, user), radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE
	var/obj/item/toy/cards/singlecard/C = new/obj/item/toy/cards/singlecard(cardUser.loc)
	currenthand -= choice
	handradial -= choice
	C.parentdeck = parentdeck
	C.cardname = choice
	C.apply_card_vars(C,O)
	C.pickup(cardUser)
	cardUser.put_in_hands(C)
	cardUser.visible_message(SPAN_NOTICE("[cardUser] draws a card from [cardUser.p_their()] hand."), SPAN_NOTICE("You take the [C.cardname] from your hand."))

	interact(cardUser)
	update_sprite()
	if(length(currenthand) == 1)
		var/obj/item/toy/cards/singlecard/N = new/obj/item/toy/cards/singlecard(loc)
		N.parentdeck = parentdeck
		N.cardname = currenthand[1]
		N.apply_card_vars(N,O)
		qdel(src)
		N.pickup(cardUser)
		cardUser.put_in_hands(N)
		to_chat(cardUser, SPAN_NOTICE("You also take [currenthand[1]] and hold it."))

/obj/item/toy/cards/cardhand/attackby(obj/item/toy/cards/singlecard/C, mob/living/user, params)
	if(istype(C))
		if(C.parentdeck == src.parentdeck)
			src.currenthand += C.cardname
			user.visible_message(SPAN_NOTICE("[user] adds a card to [user.p_their()] hand."), SPAN_NOTICE("You add the [C.cardname] to your hand."))
			qdel(C)
			interact(user)
			update_sprite(src)
		else
			to_chat(user, SPAN_WARNING("You can't mix cards from other decks!"))
	else
		return ..()

/obj/item/toy/cards/cardhand/apply_card_vars(obj/item/toy/cards/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	update_sprite()
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.card_attack_verb_continuous = sourceobj.card_attack_verb_continuous //null or unique list made by string_list()
	newobj.card_attack_verb_simple = sourceobj.card_attack_verb_simple //null or unique list made by string_list()
	newobj.resistance_flags = sourceobj.resistance_flags

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/item/toy/cards/cardhand/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/**
 * This proc updates the sprite for when you create a hand of cards
 */
/obj/item/toy/cards/cardhand/proc/update_sprite()
	cut_overlays()
	var/overlay_cards = currenthand.len

	var/k = overlay_cards == 2 ? 1 : overlay_cards - 2
	for(var/i = k; i <= overlay_cards; i++)
		var/card_overlay = image(icon=src.icon,icon_state="sc_[currenthand[i]]_[deckstyle]",pixel_x=(1-i+k)*3,pixel_y=(1-i+k)*3)
		add_overlay(card_overlay)

/obj/item/toy/cards/singlecard
	name = "card"
	desc = "A playing card used to play card games like poker."
	icon = 'icons/obj/toy.dmi'
	icon_state = "singlecard_down_nanotrasen"
	w_class = WEIGHT_CLASS_TINY
	var/cardname = null
	var/flipped = 0
	pixel_x = -5


/obj/item/toy/cards/singlecard/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/cardUser = user
		if(cardUser.is_holding(src))
			cardUser.visible_message(SPAN_NOTICE("[cardUser] checks [cardUser.p_their()] card."), SPAN_NOTICE("The card reads: [cardname]."))
		else
			. += SPAN_WARNING("You need to have the card in your hand to check it!")


/obj/item/toy/cards/singlecard/verb/Flip()
	set name = "Flip Card"
	set category = "Object"
	set src in range(1)
	if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return
	if(!flipped)
		src.flipped = 1
		if (cardname)
			src.icon_state = "sc_[cardname]_[deckstyle]"
			src.name = src.cardname
		else
			src.icon_state = "sc_Ace of Spades_[deckstyle]"
			src.name = "What Card"
		src.pixel_x = 5
	else if(flipped)
		src.flipped = 0
		src.icon_state = "singlecard_down_[deckstyle]"
		src.name = "card"
		src.pixel_x = -5

/obj/item/toy/cards/singlecard/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard/))
		var/obj/item/toy/cards/singlecard/C = I
		if(C.parentdeck == src.parentdeck)
			var/obj/item/toy/cards/cardhand/H = new/obj/item/toy/cards/cardhand(user.loc)
			H.currenthand += C.cardname
			H.currenthand += src.cardname
			H.parentdeck = C.parentdeck
			H.apply_card_vars(H,C)
			to_chat(user, SPAN_NOTICE("You combine the [C.cardname] and the [src.cardname] into a hand."))
			qdel(C)
			qdel(src)
			H.pickup(user)
			user.put_in_active_hand(H)
		else
			to_chat(user, SPAN_WARNING("You can't mix cards from other decks!"))

	if(istype(I, /obj/item/toy/cards/cardhand/))
		var/obj/item/toy/cards/cardhand/H = I
		if(H.parentdeck == parentdeck)
			H.currenthand += cardname
			user.visible_message(SPAN_NOTICE("[user] adds a card to [user.p_their()] hand."), SPAN_NOTICE("You add the [cardname] to your hand."))
			qdel(src)
			H.interact(user)
			H.update_sprite()
		else
			to_chat(user, SPAN_WARNING("You can't mix cards from other decks!"))
	else
		return ..()

/obj/item/toy/cards/singlecard/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user) || !(user.mobility_flags & MOBILITY_USE))
		return
	Flip()

/obj/item/toy/cards/singlecard/apply_card_vars(obj/item/toy/cards/singlecard/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "singlecard_down_[deckstyle]" // Without this the card is invisible until flipped. It's an ugly hack, but it works.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.hitsound = newobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.force = newobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.throwforce = newobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.throw_speed = newobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.throw_range = newobj.card_throw_range
	newobj.attack_verb_continuous = newobj.card_attack_verb_continuous = sourceobj.card_attack_verb_continuous //null or unique list made by string_list()
	newobj.attack_verb_simple = newobj.card_attack_verb_simple = sourceobj.card_attack_verb_simple //null or unique list made by string_list()

/*
 * Snowballs
 */

/obj/item/toy/snowball
	name = "snowball"
	desc = "A compact ball of snow. Good for throwing at people."
	icon = 'icons/obj/toy.dmi'
	icon_state = "snowball"
	throwforce = 20 //the same damage as a disabler shot
	damtype = STAMINA //maybe someday we can add stuffing rocks (or perhaps ore?) into snowballs to make them deal brute damage

/obj/item/toy/snowball/afterattack(atom/target as mob|obj|turf|area, mob/user)
	. = ..()
	if(user.dropItemToGround(src))
		throw_at(target, throw_range, throw_speed)

/obj/item/toy/snowball/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		playsound(src, 'sound/effects/pop.ogg', 20, TRUE)
		qdel(src)

/*
 * Toy Dagger
 */

/obj/item/toy/toy_dagger
	name = "toy dagger"
	desc = "A cheap plastic replica of a dagger. Produced by THE ARM Toys, Inc."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	inhand_icon_state = "cultdagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

// TOY MOUSEYS :3 :3 :3

/obj/item/toy/cattoy
	name = "toy mouse"
	desc = "A colorful toy mouse!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_mouse"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	resistance_flags = FLAMMABLE

/obj/item/toy/seashell
	name = "seashell"
	desc = "May you always have a shell in your pocket and sand in your shoes. Whatever that's supposed to mean."
	icon = 'icons/misc/beach.dmi'
	icon_state = "shell1"
	var/static/list/possible_colors = list("" =  2, COLOR_PURPLE_GRAY = 1, COLOR_OLIVE = 1, COLOR_PALE_BLUE_GRAY = 1, COLOR_RED_GRAY = 1)

/obj/item/toy/seashell/Initialize()
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	icon_state = "shell[rand(1,3)]"
	color = pickweight(possible_colors)
	setDir(pick(GLOB.cardinals))
