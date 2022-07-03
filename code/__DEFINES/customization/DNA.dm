//We start from 30 to not interfere with TG species defines, should they add more
/// We're using all three mutcolor features for our skin coloration
#define MUTCOLOR_MATRIXED	30
#define MUTCOLORS2			31
#define MUTCOLORS3			32
// Defines for whether an accessory should have one or three colors to choose for
#define USE_ONE_COLOR		31
#define USE_MATRIXED_COLORS	32
// Defines for some extra species traits
#define REVIVES_BY_HEALING	33
#define ROBOTIC_LIMBS		34
#define ROBOTIC_DNA_ORGANS	35
//Also.. yes for some reason specie traits and accessory defines are together

//Defines for processing reagents, for synths, IPC's and Vox
#define PROCESS_ORGANIC 1		//Only processes reagents with "ORGANIC" or "ORGANIC | SYNTHETIC"
#define PROCESS_SYNTHETIC 2		//Only processes reagents with "SYNTHETIC" or "ORGANIC | SYNTHETIC"

#define REAGENT_ORGANIC 1
#define REAGENT_SYNTHETIC 2	

//Some defines for sprite accessories
// Which color source we're using when the accessory is added
#define DEFAULT_PRIMARY		1
#define DEFAULT_SECONDARY	2
#define DEFAULT_TERTIARY	3
#define DEFAULT_MATRIXED	4 //uses all three colors for a matrix
#define DEFAULT_SKIN_OR_PRIMARY	5 //Uses skin tone color if the character uses one, otherwise primary

// Defines for extra bits of accessories
#define COLOR_SRC_PRIMARY	1
#define COLOR_SRC_SECONDARY	2
#define COLOR_SRC_TERTIARY	3
#define COLOR_SRC_MATRIXED	4

// Defines for mutant bodyparts indexes
#define MUTANT_INDEX_NAME		"name"
#define MUTANT_INDEX_COLOR_LIST	"color"

#define MAXIMUM_MARKINGS_PER_LIMB 3

#define PREVIEW_PREF_JOB "Job"
#define PREVIEW_PREF_LOADOUT "Loadout"
#define PREVIEW_PREF_NAKED "Naked"

#define BODY_SIZE_NORMAL 		1.00
#define BODY_SIZE_MAX			1.5
#define BODY_SIZE_MIN			0.8

//In inches
#define PENIS_MAX_GIRTH 		15
#define PENIS_MIN_LENGTH 		1
#define PENIS_MAX_LENGTH 		20

#define SHEATH_NONE			"None"
#define SHEATH_NORMAL		"Sheath"
#define SHEATH_SLIT			"Slit"
#define SHEATH_MODES list(SHEATH_NONE, SHEATH_NORMAL, SHEATH_SLIT)

#define MANDATORY_FEATURE_LIST list("mcolor" = "FFFFBB","mcolor2" = "FFFFBB","mcolor3" = "FFFFBB","ethcolor" = "FCC","skin_color" = "FED","flavor_text" = "","breasts_size" = 1,"breasts_lactation" = FALSE,"penis_size" = 13,"penis_girth" = 9,"penis_taur_mode" = TRUE,"penis_sheath" = SHEATH_NONE ,"balls_size" = 1, "body_size" = BODY_SIZE_NORMAL, "custom_species" = null, "uses_skintones" = FALSE)

#define UNDERWEAR_HIDE_SOCKS		(1<<0)
#define UNDERWEAR_HIDE_SHIRT		(1<<1)
#define UNDERWEAR_HIDE_UNDIES		(1<<2)

#define AROUSAL_CANT		0
#define AROUSAL_NONE		1
#define AROUSAL_PARTIAL		2
#define AROUSAL_FULL		3

#define EYE_COLORS_LIST list("#5c3600", "#004fd6", "#a8a8a8", "#663b07", "#036310")
#define HAIR_COLOR_LIST list("#4f2102", "#331a09", "#2b1a0e", "#171412", "#fae04b", "#b5b5b5", "#666666")
#define RANDOM_HAIR_STYLES list(/datum/sprite_accessory/hair/head/bald,\
		/datum/sprite_accessory/hair/head/shorthaireighties,\
		/datum/sprite_accessory/hair/head/afro,\
		/datum/sprite_accessory/hair/head/afro2,\
		/datum/sprite_accessory/hair/head/afro_large,\
		/datum/sprite_accessory/hair/head/antenna,\
		/datum/sprite_accessory/hair/head/balding,\
		/datum/sprite_accessory/hair/head/bedhead,\
		/datum/sprite_accessory/hair/head/bedhead2,\
		/datum/sprite_accessory/hair/head/bedhead3,\
		/datum/sprite_accessory/hair/head/bedheadlong,\
		/datum/sprite_accessory/hair/head/bedheadfloorlength,\
		/datum/sprite_accessory/hair/head/beehive,\
		/datum/sprite_accessory/hair/head/beehive2,\
		/datum/sprite_accessory/hair/head/bob,\
		/datum/sprite_accessory/hair/head/bob2,\
		/datum/sprite_accessory/hair/head/bob3,\
		/datum/sprite_accessory/hair/head/bob4,\
		/datum/sprite_accessory/hair/head/bobcurl,\
		/datum/sprite_accessory/hair/head/boddicker,\
		/datum/sprite_accessory/hair/head/bowlcut,\
		/datum/sprite_accessory/hair/head/bowlcut2,\
		/datum/sprite_accessory/hair/head/braid,\
		/datum/sprite_accessory/hair/head/front_braid,\
		/datum/sprite_accessory/hair/head/not_floorlength_braid,\
		/datum/sprite_accessory/hair/head/lowbraid,\
		/datum/sprite_accessory/hair/head/shortbraid,\
		/datum/sprite_accessory/hair/head/braided,\
		/datum/sprite_accessory/hair/head/braidtail,\
		/datum/sprite_accessory/hair/head/bun,\
		/datum/sprite_accessory/hair/head/bun2,\
		/datum/sprite_accessory/hair/head/bun3,\
		/datum/sprite_accessory/hair/head/largebun,\
		/datum/sprite_accessory/hair/head/manbun,\
		/datum/sprite_accessory/hair/head/tightbun,\
		/datum/sprite_accessory/hair/head/business,\
		/datum/sprite_accessory/hair/head/business2,\
		/datum/sprite_accessory/hair/head/business3,\
		/datum/sprite_accessory/hair/head/business4,\
		/datum/sprite_accessory/hair/head/buzz,\
		/datum/sprite_accessory/hair/head/cia,\
		/datum/sprite_accessory/hair/head/coffeehouse,\
		/datum/sprite_accessory/hair/head/combover,\
		/datum/sprite_accessory/hair/head/comet,\
		/datum/sprite_accessory/hair/head/cornrows1,\
		/datum/sprite_accessory/hair/head/cornrows2,\
		/datum/sprite_accessory/hair/head/cornrowbraid,\
		/datum/sprite_accessory/hair/head/cornrowbun,\
		/datum/sprite_accessory/hair/head/cornrowdualtail,\
		/datum/sprite_accessory/hair/head/crew,\
		/datum/sprite_accessory/hair/head/cut,\
		/datum/sprite_accessory/hair/head/dandpompadour,\
		/datum/sprite_accessory/hair/head/devillock,\
		/datum/sprite_accessory/hair/head/doublebun,\
		/datum/sprite_accessory/hair/head/dreadlocks,\
		/datum/sprite_accessory/hair/head/drillhair,\
		/datum/sprite_accessory/hair/head/drillhairextended,\
		/datum/sprite_accessory/hair/head/emo,\
		/datum/sprite_accessory/hair/head/emo2,\
		/datum/sprite_accessory/hair/head/emofringe,\
		/datum/sprite_accessory/hair/head/longemo,\
		/datum/sprite_accessory/hair/head/nofade,\
		/datum/sprite_accessory/hair/head/lowfade,\
		/datum/sprite_accessory/hair/head/medfade,\
		/datum/sprite_accessory/hair/head/highfade,\
		/datum/sprite_accessory/hair/head/baldfade,\
		/datum/sprite_accessory/hair/head/father,\
		/datum/sprite_accessory/hair/head/feather,\
		/datum/sprite_accessory/hair/head/flair,\
		/datum/sprite_accessory/hair/head/flattop,\
		/datum/sprite_accessory/hair/head/flattop_big,\
		/datum/sprite_accessory/hair/head/flow_hair,\
		/datum/sprite_accessory/hair/head/gelled,\
		/datum/sprite_accessory/hair/head/gentle,\
		/datum/sprite_accessory/hair/head/halfbang,\
		/datum/sprite_accessory/hair/head/halfbang2,\
		/datum/sprite_accessory/hair/head/halfshaved,\
		/datum/sprite_accessory/hair/head/hedgehog,\
		/datum/sprite_accessory/hair/head/himecut,\
		/datum/sprite_accessory/hair/head/himecut2,\
		/datum/sprite_accessory/hair/head/shorthime,\
		/datum/sprite_accessory/hair/head/himeup,\
		/datum/sprite_accessory/hair/head/hitop,\
		/datum/sprite_accessory/hair/head/jade,\
		/datum/sprite_accessory/hair/head/jensen,\
		/datum/sprite_accessory/hair/head/joestar,\
		/datum/sprite_accessory/hair/head/keanu,\
		/datum/sprite_accessory/hair/head/kusangi,\
		/datum/sprite_accessory/hair/head/long,\
		/datum/sprite_accessory/hair/head/long2,\
		/datum/sprite_accessory/hair/head/long3,\
		/datum/sprite_accessory/hair/head/long_over_eye,\
		/datum/sprite_accessory/hair/head/longbangs,\
		/datum/sprite_accessory/hair/head/longfringe,\
		/datum/sprite_accessory/hair/head/sidepartlongalt,\
		/datum/sprite_accessory/hair/head/megaeyebrows,\
		/datum/sprite_accessory/hair/head/messy,\
		/datum/sprite_accessory/hair/head/modern,\
		/datum/sprite_accessory/hair/head/mohawk,\
		/datum/sprite_accessory/hair/head/reversemohawk,\
		/datum/sprite_accessory/hair/head/shavedmohawk,\
		/datum/sprite_accessory/hair/head/unshavenmohawk,\
		/datum/sprite_accessory/hair/head/mulder,\
		/datum/sprite_accessory/hair/head/nitori,\
		/datum/sprite_accessory/hair/head/odango,\
		/datum/sprite_accessory/hair/head/ombre,\
		/datum/sprite_accessory/hair/head/oneshoulder,\
		/datum/sprite_accessory/hair/head/over_eye,\
		/datum/sprite_accessory/hair/head/oxton,\
		/datum/sprite_accessory/hair/head/parted,\
		/datum/sprite_accessory/hair/head/partedside,\
		/datum/sprite_accessory/hair/head/pigtails,\
		/datum/sprite_accessory/hair/head/pigtails2,\
		/datum/sprite_accessory/hair/head/pigtails3,\
		/datum/sprite_accessory/hair/head/kagami,\
		/datum/sprite_accessory/hair/head/pixie,\
		/datum/sprite_accessory/hair/head/pompadour,\
		/datum/sprite_accessory/hair/head/bigpompadour,\
		/datum/sprite_accessory/hair/head/ponytail1,\
		/datum/sprite_accessory/hair/head/ponytail2,\
		/datum/sprite_accessory/hair/head/ponytail3,\
		/datum/sprite_accessory/hair/head/ponytail4,\
		/datum/sprite_accessory/hair/head/ponytail5,\
		/datum/sprite_accessory/hair/head/ponytail6,\
		/datum/sprite_accessory/hair/head/ponytail7,\
		/datum/sprite_accessory/hair/head/highponytail,\
		/datum/sprite_accessory/hair/head/longponytail,\
		/datum/sprite_accessory/hair/head/stail,\
		/datum/sprite_accessory/hair/head/countryponytail,\
		/datum/sprite_accessory/hair/head/fringetail,\
		/datum/sprite_accessory/hair/head/sidetail,\
		/datum/sprite_accessory/hair/head/sidetail2,\
		/datum/sprite_accessory/hair/head/sidetail3,\
		/datum/sprite_accessory/hair/head/sidetail4,\
		/datum/sprite_accessory/hair/head/spikyponytail,\
		/datum/sprite_accessory/hair/head/poofy,\
		/datum/sprite_accessory/hair/head/quiff,\
		/datum/sprite_accessory/hair/head/ronin,\
		/datum/sprite_accessory/hair/head/shaved,\
		/datum/sprite_accessory/hair/head/shavedpart,\
		/datum/sprite_accessory/hair/head/shortbangs,\
		/datum/sprite_accessory/hair/head/short,\
		/datum/sprite_accessory/hair/head/shorthair2,\
		/datum/sprite_accessory/hair/head/shorthair3,\
		/datum/sprite_accessory/hair/head/shorthair7,\
		/datum/sprite_accessory/hair/head/rosa,\
		/datum/sprite_accessory/hair/head/shoulderlength,\
		/datum/sprite_accessory/hair/head/sidecut,\
		/datum/sprite_accessory/hair/head/skinhead,\
		/datum/sprite_accessory/hair/head/protagonist,\
		/datum/sprite_accessory/hair/head/spiky,\
		/datum/sprite_accessory/hair/head/spiky2,\
		/datum/sprite_accessory/hair/head/spiky3,\
		/datum/sprite_accessory/hair/head/swept,\
		/datum/sprite_accessory/hair/head/swept2,\
		/datum/sprite_accessory/hair/head/thinning,\
		/datum/sprite_accessory/hair/head/thinningfront,\
		/datum/sprite_accessory/hair/head/thinningrear,\
		/datum/sprite_accessory/hair/head/topknot,\
		/datum/sprite_accessory/hair/head/tressshoulder,\
		/datum/sprite_accessory/hair/head/trimmed,\
		/datum/sprite_accessory/hair/head/trimflat,\
		/datum/sprite_accessory/hair/head/twintails,\
		/datum/sprite_accessory/hair/head/undercut,\
		/datum/sprite_accessory/hair/head/undercutleft,\
		/datum/sprite_accessory/hair/head/undercutright,\
		/datum/sprite_accessory/hair/head/unkept,\
		/datum/sprite_accessory/hair/head/updo,\
		/datum/sprite_accessory/hair/head/longer,\
		/datum/sprite_accessory/hair/head/longest,\
		/datum/sprite_accessory/hair/head/longest2,\
		/datum/sprite_accessory/hair/head/veryshortovereye,\
		/datum/sprite_accessory/hair/head/longestalt,\
		/datum/sprite_accessory/hair/head/volaju,\
		/datum/sprite_accessory/hair/head/wisp,\
		/datum/sprite_accessory/hair/head/hyenamane,\
		)

#define RANDOM_FACEHAIR_STYLES list(\
		/datum/sprite_accessory/hair/facial/shaved,\
		/datum/sprite_accessory/hair/facial/abe,\
		/datum/sprite_accessory/hair/facial/brokenman,\
		/datum/sprite_accessory/hair/facial/chinstrap,\
		/datum/sprite_accessory/hair/facial/dwarf,\
		/datum/sprite_accessory/hair/facial/fullbeard,\
		/datum/sprite_accessory/hair/facial/croppedfullbeard,\
		/datum/sprite_accessory/hair/facial/gt,\
		/datum/sprite_accessory/hair/facial/hip,\
		/datum/sprite_accessory/hair/facial/jensen,\
		/datum/sprite_accessory/hair/facial/neckbeard,\
		/datum/sprite_accessory/hair/facial/vlongbeard,\
		/datum/sprite_accessory/hair/facial/muttonmus,\
		/datum/sprite_accessory/hair/facial/martialartist,\
		/datum/sprite_accessory/hair/facial/chinlessbeard,\
		/datum/sprite_accessory/hair/facial/moonshiner,\
		/datum/sprite_accessory/hair/facial/longbeard,\
		/datum/sprite_accessory/hair/facial/volaju,\
		/datum/sprite_accessory/hair/facial/threeoclock,\
		/datum/sprite_accessory/hair/facial/fiveoclock,\
		/datum/sprite_accessory/hair/facial/sevenoclock,\
		/datum/sprite_accessory/hair/facial/sevenoclockm,\
		/datum/sprite_accessory/hair/facial/moustache,\
		/datum/sprite_accessory/hair/facial/pencilstache,\
		/datum/sprite_accessory/hair/facial/smallstache,\
		/datum/sprite_accessory/hair/facial/walrus,\
		/datum/sprite_accessory/hair/facial/fu,\
		/datum/sprite_accessory/hair/facial/hogan,\
		/datum/sprite_accessory/hair/facial/selleck,\
		/datum/sprite_accessory/hair/facial/chaplin,\
		/datum/sprite_accessory/hair/facial/vandyke,\
		/datum/sprite_accessory/hair/facial/watson,\
		/datum/sprite_accessory/hair/facial/elvis,\
		/datum/sprite_accessory/hair/facial/mutton,\
		/datum/sprite_accessory/hair/facial/sideburn,\
		)
