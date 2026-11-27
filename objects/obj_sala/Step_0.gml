/// @desc Lógica de interacción del botón de juegos y modal de minijuegos
anim_t += 2.5;

if (feedback_timer > 0) {
    feedback_timer--;
}

// ========================================================
// 1. INTERACCIÓN CUANDO EL MENÚ ESTÁ CERRADO
// ========================================================
if (!games_menu_open) {
    depth = 10;
    
    if (mouse_check_button_pressed(mb_left)) {
        // Clic en el botón "Juegos" del suelo
        var _bx1 = games_btn_x - games_btn_w * 0.5;
        var _by1 = games_btn_y - games_btn_h * 0.5;
        var _bx2 = games_btn_x + games_btn_w * 0.5;
        var _by2 = games_btn_y + games_btn_h * 0.5;
        
        if (point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2)) {
            games_menu_open = true;
            selected_game = -1;
            feedback_msg = "";
            feedback_timer = 0;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
    }
}

// ========================================================
// 2. INTERACCIÓN CUANDO EL MENÚ DE MINIJUEGOS ESTÁ ABIERTO
// ========================================================
if (games_menu_open) {
    depth = -1000;
    
    if (mouse_check_button_pressed(mb_left)) {
        // 2.1 Botón Cerrar "X" superior
        if (point_distance(mouse_x, mouse_y, 642, 80) <= 28) {
            games_menu_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // 2.2 Botón inferior "Volver a la Sala"
        if (point_in_rectangle(mouse_x, mouse_y, 360 - 170, 1005, 360 + 170, 1065)) {
            games_menu_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // 2.3 Tarjeta 1: Atrapar Comida (Food Drop) - Iniciar Minijuego
        var _c1_x1 = 55;
        var _c1_y1 = 145;
        var _c1_x2 = 665;
        var _c1_y2 = 410;
        if (point_in_rectangle(mouse_x, mouse_y, _c1_x1, _c1_y1, _c1_x2, _c1_y2)) {
            selected_game = 0;
            games_menu_open = false;
            audio_play_sound(snd_click, 1, false);
            room_goto(rm_minigame_food);
            exit;
        }
        
        // 2.4 Tarjeta 2: Juego de Memoria (Memory Match)
        var _c2_x1 = 55;
        var _c2_y1 = 430;
        var _c2_x2 = 665;
        var _c2_y2 = 695;
        if (point_in_rectangle(mouse_x, mouse_y, _c2_x1, _c2_y1, _c2_x2, _c2_y2)) {
            selected_game = 1;
            feedback_msg = "Minijuego de Memoria en desarrollo!";
            feedback_timer = 120;
            audio_play_sound(snd_aviso, 1, false);
            exit;
        }
    }
}
