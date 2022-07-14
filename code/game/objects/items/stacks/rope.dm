/obj/item/stack/rope
	name = "rope"
	gender = PLURAL
	icon = 'icons/obj/items/stack/rope.dmi'
	icon_state = "rope"
	merge_type = /obj/item/stack/rope
	full_w_class = WEIGHT_CLASS_SMALL
	max_amount = 5
	singular_name = "rope"

#define ROPE_RESTRAINTS_COST 2

/obj/item/stack/rope/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("With [ROPE_RESTRAINTS_COST] lengths of rope, you can make a restraint by using the rope in hand.")

/obj/item/stack/rope/attack_self(mob/living/user)
	if(amount >= ROPE_RESTRAINTS_COST)
		to_chat(user, SPAN_NOTICE("You start crafting some rope restraints."))
		if(do_after(user, 2 SECONDS, target = user))
			if(QDELETED(src) || !use(ROPE_RESTRAINTS_COST))
				return
			to_chat(user, SPAN_NOTICE("You start crafting some rope restraints."))
			var/obj/item/restraints/handcuffs/rope/restraints = new
			user.put_in_hands(restraints)
		return TRUE
	return ..()

#undef ROPE_RESTRAINTS_COST

/obj/item/stack/rope/two
	amount = 2

/obj/item/stack/rope/three
	amount = 3

/obj/item/stack/rope/four
	amount = 4

/obj/item/stack/rope/five
	amount = 5
