/// @desc Inicialización del Minijuego "Atrapar Comida" (Food Drop) - Versión Pulida 100%

// Variables globales de seguridad
if (!variable_global_exists("pou_monedas")) global.pou_monedas = 250;
if (!variable_global_exists("pou_diversion")) global.pou_diversion = 80;
if (!variable_global_exists("pou_sombrero")) global.pou_sombrero = -1;
if (!variable_global_exists("pou_lentes")) global.pou_lentes = -1;
if (!variable_global_exists("food_drop_highscore")) global.food_drop_highscore = 0;

// Ajuste de ventana para escritorio
if (os_type == os_windows) {
    var _scale = min(0.75, (display_get_height() - 140) / 1280);
    window_set_size(round(720 * _scale), round(1280 * _scale));
    window_center();
}

// Estados del minijuego
state_ready = 0;
state_playing = 1;
state_paused = 2;
state_gameover = 3;
game_state = state_ready;

// Estadísticas de la partida
score_food = 0;
coins_earned = 0;
max_lives = 4;
lives_count = 4;
combo = 0;
max_combo = 0;
is_new_record = false;
anim_t = 0;

// Pou en el minijuego (Escala ágil y proporcionada 0.48)
pou_x = 360;
pou_y = 1140;
pou_target_x = 360;
pou_base_scale = 0.48;
pou_scale_x = pou_base_scale;
pou_scale_y = pou_base_scale;
pou_emotion = 1; // 1 = Feliz
eat_timer = 0;
hurt_timer = 0;
head_shake_x = 0;
invulnerable_timer = 0;
prev_mouse_x = mouse_x;
using_mouse = false;

// Efectos de cámara y pantalla
shake_timer = 0;
shake_x = 0;
shake_y = 0;

// Spawner inteligente de items (Ritmo inicial accesible y agradable)
spawn_timer = 0;
spawn_interval_base = 65;
fall_speed_base = 4.2;
last_spawn_x = 360;
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

// Sonidos de comida disponibles para variedad
eat_sounds = [snd_comer, snd_comer2, snd_comer3];
