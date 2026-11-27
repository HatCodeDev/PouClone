/// @desc Inicialización del Dormitorio (Lámpara, Sueño, Armario y Accesorios)
depth = 10;

// Posiciones de los objetos en la parte inferior
lamp_x = 180;
lamp_y = 1110;

closet_x = 540;
closet_y = 1110;

closet_open = false;
closet_tab = 0; // 0: Sombreros, 1: Lentes, 2: Ropa, 3: Bigotes
closet_page = 0;
preview_bounce = 0;

// Asegurar existencia de variables globales
if (!variable_global_exists("pou_sombrero")) global.pou_sombrero = -1;
if (!variable_global_exists("pou_lentes")) global.pou_lentes = -1;
if (!variable_global_exists("pou_ropa")) global.pou_ropa = -1;
if (!variable_global_exists("pou_bigote")) global.pou_bigote = -1;
if (!variable_global_exists("pou_lamp_on")) global.pou_lamp_on = true;

// Partículas Zzz al dormir con la lámpara apagada
zzz_particles = [];
zzz_timer = 0;

// Catálogo de Sombreros
sombreros = [
    { name: "Ninguno",         sprite: -1,                  y_off: 330, scale: 0.78 },
    { name: "Galera Copa",     sprite: spr_sombrero_copa,   y_off: 320, scale: 0.76 },
    { name: "Gorro Fiesta",    sprite: spr_sombrero_fiesta, y_off: 345, scale: 0.80 },
    { name: "Gorro Lana",      sprite: spr_sombrero_lana,   y_off: 325, scale: 0.78 },
    { name: "Gorra Azul",      sprite: spr_sombrero_azul,   y_off: 330, scale: 0.76 },
    { name: "Sombrero Bruja",  sprite: spr_sombrero_bruja,  y_off: 345, scale: 0.80 },
    { name: "Sombrero Negro",  sprite: spr_sombrero_negro,  y_off: 330, scale: 0.78 }
];

// Catálogo de Lentes
lentes = [
    { name: "Ninguno",         sprite: -1 },
    { name: "Lentes Oro",      sprite: spr_lentes_oro },
    { name: "Lentes Sol Azul", sprite: spr_lentes_sol_azul },
    { name: "Rojo Clasico",    sprite: spr_lentes_1 },
    { name: "Gafas Negras",    sprite: spr_lentes_2 }
];

// Catálogo de Ropa (Pajaritas elegantes de Pou)
ropas = [
    { name: "Ninguno",        sprite: -1 },
    { name: "Pajarita Roja",  sprite: spr_ropa_pajarita_roja },
    { name: "Pajarita Negra", sprite: spr_ropa_pajarita_negra },
    { name: "Pajarita Azul",  sprite: spr_ropa_pajarita_azul },
    { name: "Pajarita Oro",   sprite: spr_ropa_pajarita_oro }
];

// Catálogo de Bigotes
bigotes = [
    { name: "Ninguno",        sprite: -1 },
    { name: "Bigote Clasico", sprite: spr_bigote_clasico },
    { name: "Bigote Rizado",  sprite: spr_bigote_rizado }
];
