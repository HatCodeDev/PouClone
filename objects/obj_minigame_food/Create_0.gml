/// @desc Inicialización del Minijuego "Atrapar Comida" (Food Drop)

// Variables globales de seguridad
if (!variable_global_exists("pou_monedas")) global.pou_monedas = 250;
if (!variable_global_exists("pou_diversion")) global.pou_diversion = 80;
if (!variable_global_exists("pou_sombrero")) global.pou_sombrero = -1;
if (!variable_global_exists("pou_lentes")) global.pou_lentes = -1;

// Ajuste de ventana para escritorio
if (os_type == os_windows) {
    var _scale = min(0.75, (display_get_height() - 140) / 1280);
    window_set_size(round(720 * _scale), round(1280 * _scale));
    window_center();
}

// Estados del minijuego
// 0: Listo / Instrucciones, 1: En juego, 2: Fin de partida
state_ready = 0;
state_playing = 1;
state_gameover = 2;
game_state = state_ready;

// Estadísticas de la partida
score_food = 0;
coins_earned = 0;
lives_count = 3;
max_lives = 3;
anim_t = 0;

// Pou en el minijuego
pou_x = 360;
pou_y = 1080;
pou_target_x = 360;
pou_base_scale = 1.15;
pou_scale_x = pou_base_scale;
pou_scale_y = pou_base_scale;
pou_emotion = 1; // 1 = Feliz
pou_mouth_open = false;
eat_timer = 0;
hurt_timer = 0;
head_shake_x = 0;

// Efectos de cámara y pantalla
shake_timer = 0;
shake_x = 0;
shake_y = 0;

// Generador de items
spawn_timer = 0;
spawn_interval_base = 56;
fall_speed_base = 6.0;
falling_items = [];

// Catálogo de comidas deliciosas
food_sprites = [
    spr_food_apple,
    spr_food_cherries,
    spr_food_donut,
    spr_food_burger,
    spr_food_banana,
    spr_food_chicken,
    spr_food_broccoli,
    spr_food_carrot,
    spr_food_cheesecake
];

// Catálogo de objetos no comestibles / basura a esquivar
hazard_sprites = [
    spr_game_tenis,
    spr_game_herradura
];

// Partículas y textos flotantes
particles = [];
floating_texts = [];

// Nubes de fondo animadas
clouds = [
    { x: 90,  y: 160, spd: 0.45, w: 120, h: 45 },
    { x: 380, y: 240, spd: 0.32, w: 160, h: 55 },
    { x: 580, y: 130, spd: 0.55, w: 100, h: 38 },
    { x: 210, y: 320, spd: 0.38, w: 140, h: 50 }
];

// Sonidos disponibles para variedad
eat_sounds = [snd_comer, snd_comer2, snd_comer3];
