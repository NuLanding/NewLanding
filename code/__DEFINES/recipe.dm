#define RECIPE_COMPONENT(type) GLOB.recipe_components[type]
#define RECIPE_RESULT(type) GLOB.recipe_results[type]
#define RECIPE(type) GLOB.recipes[type]

// Appliance types
// none yet

// Recipe priorities
#define RECIPE_PRIORITY_VERY_HIGH 5000
#define RECIPE_PRIORITY_HIGH 4000
#define RECIPE_PRIORITY_NORMAL 3000
#define RECIPE_PRIORITY_LOW 2000
#define RECIPE_PRIORITY_VERY_LOW 1000

// For recipes who want to squeeze themselves inbetween above grades, they can add those and multiply by 1-9
#define RECIPE_PRIORITY_GRADE 100
