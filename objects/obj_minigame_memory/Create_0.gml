/// @desc Inicialización del Minijuego "Juego de Memoria" (Memory Match) - Versión Pulida 100%

// Variables globales de seguridad
if (!variable_global_exists("pou_monedas")) global.pou_monedas = 250;
if (!variable_global_exists("pou_diversion")) global.pou_diversion = 80;
if (!variable_global_exists("pou_sombrero")) global.pou_sombrero = -1;
if (!variable_global_exists("pou_lentes")) global.pou_lentes = -1;
if (!variable_global_exists("memory_best_moves")) global.memory_best_moves = 0;

// Ajuste de ventana para escritorio
if (os_type == os_windows) {
    var _scale = min(0.75, (display_get_height() - 140) / 1280);
    window_set_size(round(720 * _scale), round(1280 * _scale));
    window_center();
}

// Estados del juego
state_ready = 0;
state_playing = 1;
state_victory = 2;
game_state = state_ready;

// Estadísticas de la partida
pairs_found = 0;
total_pairs = 8;
moves_count = 0;
timer_seconds = 0;
timer_frames = 0;
coins_earned = 0;
anim_t = 0;
is_new_record = false;
victory_delay = 0;

// Variables de interacción de cartas
first_card = -1;
second_card = -1;
mismatch_timer = 0;

// Partículas y textos flotantes
particles = [];
floating_texts = [];

// Pou supervisor en la parte superior (perfectamente proporcionado sin desbordes)
pou_x = 360;
pou_y = 290;
pou_scale = 0.52;
pou_emotion = 0; // 0 = Normal, 1 = Feliz, 2 = Serio
pou_jump_y = 0;
pou_jump_vy = 0;
mismatch_emotion_timer = 0;

// Catálogo de iconos para las 8 parejas (imágenes oficiales)
pair_icons = [
    spr_game_avion,
    spr_game_cd,
    spr_game_herradura,
    spr_game_tenis,
    spr_food_apple,
    spr_food_cherries,
    spr_food_donut,
    spr_sombrero_azul
];

// Función para inicializar y barajar el tablero de 16 cartas (4x4)
setup_deck = function() {
    cards = [];
    first_card = -1;
    second_card = -1;
    mismatch_timer = 0;
    pairs_found = 0;
    moves_count = 0;
    timer_seconds = 0;
    timer_frames = 0;
    coins_earned = 0;
    is_new_record = false;
    victory_delay = 0;
    pou_emotion = 0;
    
    // Crear lista de 16 identificadores (8 parejas duplicadas)
    var _deck_ids = [];
    for (var _p = 0; _p < 8; _p++) {
        array_push(_deck_ids, _p);
        array_push(_deck_ids, _p);
    }
    
    // Barajado aleatorio algorítmico (Fisher-Yates)
    for (var _i = array_length(_deck_ids) - 1; _i > 0; _i--) {
        var _j = irandom(_i);
        var _temp = _deck_ids[_i];
        _deck_ids[_i] = _deck_ids[_j];
        _deck_ids[_j] = _temp;
    }
    
    // Dimensiones y posiciones de la cuadrícula 4x4 (optimizada 130x130, centrada y sin desbordes)
    var _card_size = 130;
    var _spacing = 18;
    var _start_x = 73;
    var _start_y = 448;
    
    for (var _row = 0; _row < 4; _row++) {
        for (var _col = 0; _col < 4; _col++) {
            var _idx = _row * 4 + _col;
            var _pid = _deck_ids[_idx];
            var _cx = _start_x + _col * (_card_size + _spacing) + _card_size * 0.5;
            var _cy = _start_y + _row * (_card_size + _spacing) + _card_size * 0.5;
            
            var _c = {
                index: _idx,
                pair_id: _pid,
                icon: pair_icons[_pid],
                x: _cx,
                y: _cy,
                w: _card_size,
                h: _card_size,
                scale_x: 1.0,
                scale_y: 1.0,
                flip_phase: 0, // 0: reposo, 1: encogiéndose al voltear, 2: expandiéndose, -1: encogiéndose al tapar, -2: expandiéndose
                is_face_up: false,
                is_matched: false,
                glow: 0.0
            };
            array_push(cards, _c);
        }
    }
};

// Crear tablero inicial
setup_deck();

