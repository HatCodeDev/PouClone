/// @desc Lógica de juego, interacción táctil con cartas, detección de parejas y victoria

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
    // Contador de tiempo transcurrido
    timer_frames++;
    if (timer_frames >= 60) {
        timer_frames = 0;
        timer_seconds++;
    }
    
    // Desvanecimiento de brillo dorado en cartas acertadas
    for (var _g = 0; _g < array_length(cards); _g++) {
        if (cards[_g].glow > 0) {
            cards[_g].glow -= 0.035;
        }
    }
    
    // Si hay un desacierto esperando ocultarse
    if (mismatch_timer > 0) {
        mismatch_timer--;
        if (mismatch_timer == 0) {
            cards[first_card].is_face_up = false;
            cards[second_card].is_face_up = false;
            first_card = -1;
            second_card = -1;
            audio_play_sound(snd_click, 1, false);
        }
    } else if (mouse_check_button_pressed(mb_left)) {
        // Interacción con cartas del tablero
        for (var _i = 0; _i < array_length(cards); _i++) {
            var _c = cards[_i];
            
            // Si la carta no está emparejada ni boca arriba actualmente
            if (!_c.is_matched && !_c.is_face_up) {
                var _x1 = _c.x - _c.w * 0.5;
                var _y1 = _c.y - _c.h * 0.5;
                var _x2 = _c.x + _c.w * 0.5;
                var _y2 = _c.y + _c.h * 0.5;
                
                if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)) {
                    if (first_card == -1) {
                        // Primera carta volteada
                        first_card = _i;
                        _c.is_face_up = true;
                        audio_play_sound(snd_click, 1, false);
                    } else if (second_card == -1 && _i != first_card) {
                        // Segunda carta volteada
                        second_card = _i;
                        _c.is_face_up = true;
                        moves_count++;
                        
                        // Verificar coincidencia de pareja
                        if (cards[first_card].pair_id == cards[second_card].pair_id) {
                            // ¡PAREJA ENCONTRADA!
                            cards[first_card].is_matched = true;
                            cards[second_card].is_matched = true;
                            cards[first_card].glow = 1.0;
                            cards[second_card].glow = 1.0;
                            
                            pairs_found++;
                            coins_earned += 5;
                            global.pou_monedas += 5;
                            global.pou_diversion = min(100, global.pou_diversion + 8);
                            
                            audio_play_sound(snd_match, 1, false);
                            
                            // Reacción alegre de Pou
                            pou_jump_vy = -9.0;
                            
                            // Textos flotantes de recompensa
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
                            
                            // Partículas brillantes tipo estrellas
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
                            
                            // Verificar victoria completa (8 parejas encontradas)
                            if (pairs_found >= total_pairs) {
                                game_state = state_victory;
                                // Bonificación de victoria por completar el tablero
                                coins_earned += 10;
                                global.pou_monedas += 10;
                                global.pou_diversion = 100;
                                audio_play_sound(snd_acierto, 1, false);
                            }
                        } else {
                            // ¡NO COINCIDEN!
                            audio_play_sound(snd_no, 1, false);
                            mismatch_timer = 32; // Pausa breve para memorizar
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
