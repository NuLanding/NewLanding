/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 80
	damage_type = BRUTE
	nodamage = FALSE
	flag = BULLET
	hitsound_wall = "ricochet"
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=20, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	wound_falloff_tile = -5
	embed_falloff_tile = -3

/obj/projectile/bullet/lead_ball
	name = "lead ball"
	icon_state = "lead_ball"
	shrapnel_type = /obj/item/stack/lead_ball

/obj/projectile/arrow
	name = "arrow"
	icon_state = "bullet"
	damage = 35
	damage_type = BRUTE
	nodamage = FALSE
	flag = BULLET
	hitsound_wall = "ricochet"
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/stack/arrow
	embedding = list(embed_chance=20, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	wound_falloff_tile = -5
	embed_falloff_tile = -3
