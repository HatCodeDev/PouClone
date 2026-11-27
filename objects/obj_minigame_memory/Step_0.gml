/// @desc Lógica de juego, interacción táctil fluida, animaciones de cartas y victoria - Versión Pulida

anim_t += 2.0;

// Animación de salto alegre de Pou
if (pou_jump_vy != 0 || pou_jump_y < 0) {
    pou_jump_y += pou_jump_vy;
    pou_jump_vy += 0.85;
    if (pou_jump_y >= 0) {
        pou_jump_y = 0;
        pou_jump_vy = 0;
    }
}

// Actualización de partículas
for (var _p = array_length(particles) - 1; _p >= 0; _p--) {
    var _part = particles[_p];
    _part.x += _part.vx;
    _part.y += _part.vy;
    _part.alpha -= 0.035;
    if (_part.alpha <= 0) {
        array_delete(particles, _p, 1);
    }
}

// Actualización de textos flotantes
for (var _t = array_length(floating_texts) - 1; _t >= 0; _t--) {
    var _txt = floating_texts[_t];
    _txt.y += _txt.vy;
    _txt.alpha -= 0.025;
    if (_txt.alpha <= 0) {
        array_delete(floating_texts, _t, 1);
    }
}

// Suavizado elástico de escala de cartas
for (var _c = 0; _c < array_length(cards); _c++) {
    cards[_c].scale_x = lerp(cards[_c].scale_x, 1.0, 0.22);
    cards[_c].scale_y = lerp(cards[_c].scale_y, 1.0, 0.22);
    if (cards[_c].glow > 0) cards[_c].glow -= 0.035;
}

// ========================================================
// 1. BOTÓN SALIR / VOLVER A LA SALA (Superior Izquierda)
// ========================================================
var _btn_exit = point_in_rectangle(mouse_x, mouse_y, 24, 20, 145, 68);
if (mouse_check_button_pressed(mb_left) && _btn_exit) {
    audio_play_sound(snd_click, 1, false);
    room_goto(rm_sala);
    exit;
}

// ========================================================
// 2. ESTADO: INSTRUCCIONES / LISTO (STATE_READY)
// ========================================================
if (game_state == state_ready) {
    var _btn_start = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 780, 360 + 150, 850);
    var _key_start = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
    
    if ((mouse_check_button_pressed(mb_left) && _btn_start) || _key_start) {
        game_state = state_playing;
        audio_play_sound(snd_shuffle, 1, false);
        exit;
    }
}

// ========================================================
// 3. ESTADO: EN JUEGO (STATE_PLAYING)
// ========================================================
if (game_state == state_playing) {
    // Si se encontraron todas las parejas y está corriendo el breve retraso de celebración
    if (victory_delay > 0) {
        victory_delay--;
        if (victory_delay == 0) {
            game_state = state_victory;
            coins_earned += 10;
            global.pou_monedas += 10;
            global.pou_diversion = 100;
            
            // Verificar mejor récord
            if (global.memory_best_moves == 0 || moves_count < global.memory_best_moves) {
                global.memory_best_moves = moves_count;
                is_new_record = true;
            }
            audio_play_sound(snd_acierto, 1, false);
        }
        exit;
    }
    
    // Contador de tiempo transcurrido
    timer_frames++;
    if (timer_frames >= 60) {
        timer_frames = 0;
        timer_seconds++;
    }
    
    // Manejo ultra reactivo de desacierto: si el jugador hace clic, se descarta la espera de inmediato
    if (mismatch_timer > 0) {
        mismatch_timer--;
        if (mouse_check_button_pressed(mb_left) || mismatch_timer == 0) {
            if (first_card != -1) cards[first_card].is_face_up = false;
            if (second_card != -1) cards[second_card].is_face_up = false;
            first_card = -1;
            second_card = -1;
            mismatch_timer = 0;
            audio_play_sound(snd_click, 1, false);
        }
    }
    
    // Si no hay desacierto bloqueando, permitir voltear cartas
    if (mismatch_timer == 0 && mouse_check_button_pressed(mb_left)) {
        for (var _i = 0; _i < array_length(cards); _i++) {
            var _cd = cards[_i];
            
            if (!_cd.is_matched && !_cd.is_face_up) {
                var _x1 = _cd.x - _cd.w * 0.5;
                var _y1 = _cd.y - _cd.h * 0.5;
                var _x2 = _cd.x + _cd.w * 0.5;
                var _y2 = _cd.y + _cd.h * 0.5;
                
                if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)) {
                    if (first_card == -1) {
                        // Primera carta volteada
                        first_card = _i;
                        _cd.is_face_up = true;
                        _cd.scale_x = 0.65;
                        _cd.scale_y = 1.25;
                        audio_play_sound(snd_click, 1, false);
                    } else if (second_card == -1 && _i != first_card) {
                        // Segunda carta volteada
                        second_card = _i;
                        _cd.is_face_up = true;
                        _cd.scale_x = 0.65;
                        _cd.scale_y = 1.25;
                        moves_count++;
                        
                        // Comprobar coincidencia
                        if (cards[first_card].pair_id == cards[second_card].pair_id) {
                            // ¡PAREJA ENCONTRADA!
                            cards[first_card].is_matched = true;
                            cards[second_card].is_matched = true;
                            cards[first_card].scale_x = 1.25;
                            cards[first_card].scale_y = 1.25;
                            cards[second_card].scale_x = 1.25;
                            cards[second_card].scale_y = 1.25;
                            cards[first_card].glow = 1.0;
                            cards[second_card].glow = 1.0;
                            
                            pairs_found++;
                            coins_earned += 5;
                            global.pou_monedas += 5;
                            global.pou_diversion = min(100, global.pou_diversion + 8);
                            
                            audio_play_sound(snd_match, 1, false);
                            
                            // Reacción alegre de Pou
                            pou_jump_vy = -9.0;
                            
                            // Textos flotantes
                            array_push(floating_texts, {
                                x: cards[first_card].x,
                                y: cards[first_card].y - 32,
                                text: "+5 Monedas",
                                color: make_color_rgb(240, 190, 40),
                                alpha: 1.0,
                                vy: -2.4,
                                scale: 1.15
                            });
                            array_push(floating_texts, {
                                x: cards[second_card].x,
                                y: cards[second_card].y - 32,
                                text: "+5 Monedas",
                                color: make_color_rgb(240, 190, 40),
                                alpha: 1.0,
                                vy: -2.4,
                                scale: 1.15
                            });
                            
                            // Estrellitas brillantes
                            for (var _k = 0; _k < 7; _k++) {
                                array_push(particles, {
                                    x: cards[first_card].x + random_range(-25, 25),
                                    y: cards[first_card].y + random_range(-25, 25),
                                    vx: random_range(-3, 3),
                                    vy: random_range(-3, 3),
                                    color: choose(c_yellow, c_white, c_aqua),
                                    size: random_range(4, 7),
                                    alpha: 1.0
                                });
                                array_push(particles, {
                                    x: cards[second_card].x + random_range(-25, 25),
                                    y: cards[second_card].y + random_range(-25, 25),
                                    vx: random_range(-3, 3),
                                    vy: random_range(-3, 3),
                                    color: choose(c_yellow, c_white, c_aqua),
                                    size: random_range(4, 7),
                                    alpha: 1.0
                                });
                            }
                            
                            first_card = -1;
                            second_card = -1;
                            
                            // Si se completaron las 8 parejas, dar breve respiro antes del modal
                            if (pairs_found >= total_pairs) {
                                victory_delay = 25;
                            }
                        } else {
                            // ¡NO COINCIDEN!
                            audio_play_sound(snd_no, 1, false);
                            mismatch_timer = 30; // Tiempo para memorizar
                        }
                    }
                    break;
                }
            }
        }
    }
}

// ========================================================
// 4. ESTADO: VICTORIA / TABLERO COMPLETADO (STATE_VICTORY)
// ========================================================
if (game_state == state_victory) {
    // Botón Jugar Otra Vez
    var _h_retry = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 780, 360 + 150, 845);
    if (mouse_check_button_pressed(mb_left) && _h_retry) {
        setup_deck();
        game_state = state_playing;
        audio_play_sound(snd_shuffle, 1, false);
        exit;
    }
    
    // Botón Volver a la Sala
    var _h_back = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 865, 360 + 150, 930);
    if (mouse_check_button_pressed(mb_left) && _h_back) {
        audio_play_sound(snd_click, 1, false);
        room_goto(rm_sala);
        exit;
    }
}
