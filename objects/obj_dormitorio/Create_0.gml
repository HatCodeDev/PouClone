/// @desc Inicialización del Dormitorio (Lámpara, Sueño, Armario y Accesorios)
depth = 10;

// Posiciones de los objetos en la parte inferior (donde antes iban las puertas)
lamp_x = 180;
lamp_y = 1110;

closet_x = 540;
closet_y = 1110;

closet_open = false;
closet_tab = 0; // 0: Sombreros, 1: Lentes

// Partículas Zzz al dormir con la lámpara apagada
zzz_particles = [];
zzz_timer = 0;

// Catálogo de Sombreros
sombreros = [
    { name: "Ninguno", sprite: -1 },
    { name: "Azul",    sprite: spr_sombrero_azul },
    { name: "Bruja",   sprite: spr_sombrero_bruja },
    { name: "Negro",   sprite: spr_sombrero_negro }
];

// Catálogo de Lentes
lentes = [
    { name: "Ninguno",  sprite: -1 },
    { name: "Lentes 1", sprite: spr_lentes_1 },
    { name: "Lentes 2", sprite: spr_lentes_2 }
];
