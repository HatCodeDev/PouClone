/// @desc Gestión e interacción de comida en la Cocina (estilo Pou original)

// Lista de comidas disponibles con todas sus propiedades (ASCII seguro para GameMaker)
foods = [
    { name: "Manzana",      sprite: spr_food_apple,      nutrition: 20, is_drink: false, count: 5, price: 10, crumbs: [c_red, c_white, c_yellow] },
    { name: "Platano",      sprite: spr_food_banana,     nutrition: 22, is_drink: false, count: 4, price: 12, crumbs: [c_yellow, c_white] },
    { name: "Cerezas",      sprite: spr_food_cherries,   nutrition: 15, is_drink: false, count: 6, price: 8,  crumbs: [c_maroon, c_red] },
    { name: "Zanahoria",    sprite: spr_food_carrot,     nutrition: 18, is_drink: false, count: 5, price: 10, crumbs: [c_orange, c_lime] },
    { name: "Brocoli",      sprite: spr_food_broccoli,   nutrition: 25, is_drink: false, count: 3, price: 15, crumbs: [c_green, c_lime] },
    { name: "Hamburguesa",  sprite: spr_food_burger,     nutrition: 40, is_drink: false, count: 2, price: 25, crumbs: [c_orange, c_yellow, c_maroon] },
    { name: "Pollo",        sprite: spr_food_chicken,    nutrition: 35, is_drink: false, count: 3, price: 20, crumbs: [c_orange, c_yellow] },
    { name: "Dona",         sprite: spr_food_donut,      nutrition: 20, is_drink: false, count: 4, price: 12, crumbs: [c_fuchsia, c_aqua, c_yellow] },
    { name: "Pastel",       sprite: spr_food_cheesecake, nutrition: 28, is_drink: false, count: 2, price: 18, crumbs: [c_red, c_white, c_yellow] },
    { name: "Jugo",         sprite: spr_food_juice,      nutrition: 20, is_drink: true,  count: 4, price: 12, crumbs: [c_orange, c_yellow] }
];

// Preservar inventario global entre cambios de sala
if (!variable_global_exists("pou_food_counts")) {
    global.pou_food_counts = array_create(array_length(foods));
    for (var _i = 0; _i < array_length(foods); _i++) {
        global.pou_food_counts[_i] = foods[_i].count;
    }
} else {
    for (var _i = 0; _i < array_length(foods); _i++) {
        foods[_i].count = global.pou_food_counts[_i];
    }
}

food_index = 0;
bites_total = 3;
bites_remaining = 3;

// Posiciones del plato y la comida (en la parte inferior)
plate_x = 410;
plate_y = 1075;
food_x = plate_x;
food_y = plate_y;
food_target_x = plate_x;
food_target_y = plate_y;

// Arrastre y animación física
is_dragging = false;
drag_offset_x = 0;
drag_offset_y = 0;
food_angle = 0;
food_scale = 1.3;
food_punch = 1.0;
bite_cooldown = 0;
float_t = 0;
prev_mouse_x = mouse_x;

// Interfaz de Nevera / Menú de alimentos
fridge_open = false;
depth = 10;

// Partículas de migas / mordisco
crumbs = [];

// Botones UI de navegación de comida
arrow_left_x = 280;
arrow_left_y = 1075;
arrow_right_x = 540;
arrow_right_y = 1075;
arrow_radius = 32;

// Nevera en la parte inferior izquierda (donde antes iba la puerta)
nevera_x = 125;
nevera_y = 1095;

btn_buy_w = 160;
btn_buy_h = 42;

// Sonidos de mordiscos
bite_sounds = [snd_comer, snd_comer2, snd_comer3];
