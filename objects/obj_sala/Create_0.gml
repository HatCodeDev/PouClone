/// @desc Inicialización de la Sala de Juegos y Menú de Minijuegos
depth = 10;

// Estado del modal de minijuegos
games_menu_open = false;

// Posición del botón / consola de "Juegos" en el suelo de la sala (área inferior libre)
games_btn_x = 360;
games_btn_y = 1100;
games_btn_w = 240;
games_btn_h = 62;

// Variables de animación e interacción
anim_t = 0;
selected_game = -1;
feedback_msg = "";
feedback_timer = 0;

// Catálogo de minijuegos disponibles
minijuegos = [
    {
        id: "comida",
        name: "Atrapar Comida",
        subtitle: "Food Drop",
        tag: "Popular",
        desc: "Mueve a Pou para atrapar alimentos deliciosos que caen del cielo y ganar monedas.",
        reward: "+1 Moneda por comida",
        icon_spr: spr_food_apple,
        accent_color: make_color_rgb(220, 80, 50)
    },
    {
        id: "memoria",
        name: "Juego de Memoria",
        subtitle: "Memory Match",
        tag: "Mente",
        desc: "Voltea las cartas y encuentra las parejas de figuras identicas en el tablero.",
        reward: "+5 Monedas por par",
        icon_spr: spr_carta_frente,
        accent_color: make_color_rgb(60, 130, 200)
    }
];
