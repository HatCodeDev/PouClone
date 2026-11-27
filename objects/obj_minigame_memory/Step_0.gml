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

// Suavizado elástico y animación de volteo 3D de cartas
for (var _c = 0; _c < array_length(cards); _c++) {
    var _cd = cards[_c];
    if (_cd.flip_phase == 1) {
        // Fase 1: Encogiéndose hacia el centro para voltearse boca arriba
        _cd.scale_x -= 0.22;
        if (_cd.scale_x <= 0) {
            _cd.scale_x = 0;
            _cd.is_face_up = true;
            _cd.flip_phase = 2;
        }
    } else if (_cd.flip_phase == 2) {
        // Fase 2: Expandiéndose boca arriba
        _cd.scale_x += 0.22;
        if (_cd.scale_x >= 1.0) {
            _cd.scale_x = 1.0;
            _cd.flip_phase = 0;
        }
    } else if (_cd.flip_phase == -1) {
        // Fase -1: Encogiéndose para voltearse boca abajo
        _cd.scale_x -= 0.22;
        if (_cd.scale_x <= 0) {
            _cd.scale_x = 0;
            _cd.is_face_up = false;
            _cd.flip_phase = -2;
        }
    } else if (_cd.flip_phase == -2) {
        // Fase -2: Expandiéndose boca abajo
        _cd.scale_x += 0.22;
        if (_cd.scale_x >= 1.0) {
            _cd.scale_x = 1.0;
            _cd.flip_phase = 0;
        }
    } else {
        _cd.scale_x = lerp(_cd.scale_x, 1.0, 0.22);
        _cd.scale_y = lerp(_cd.scale_y, 1.0, 0.22);
    }
    if (_cd.glow > 0) _cd.glow -= 0.035;
}

// Emoción temporal de Pou en desacierto
if (mismatch_emotion_timer > 0) {
    mismatch_emotion_timer--;
    if (mismatch_emotion_timer == 0 && game_state == state_playing) {
        pou_emotion = 0; // Vuelve a Normal
    }
}

// ========================================================
// 1. BOTÓN SALIR / VOLVER A LA SALA (Superior Izquierda)
// ========================================================
var _btn_exit = point_in_rectangle(mouse_x, mouse_y, 24, 20, 155, 72);
if (mouse_check_button_pressed(mb_left) && _btn_exit) {
    audio_play_sound(snd_click, 1, false);
    room_goto(rm_sala);
    exit;
}

// ========================================================
// 2. ESTADO: INSTRUCCIONES / LISTO (STATE_READY)
// ========================================================
if (game_state == state_ready) {
    var _btn_start = point_in_rectangle(mouse_x, mouse_y, 200, 790, 520, 855);
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
    // Botón Inferior: Reiniciar Tablero / Barajar
    var _h_btn_restart = point_in_rectangle(mouse_x, mouse_y, 375, 1105, 675, 1175);
    if (mouse_check_button_pressed(mb_left) && _h_btn_restart) {
        setup_deck();
        audio_play_sound(snd_shuffle, 1, false);
        exit;
    }
    
    // Si se encontraron todas las parejas y está corriendo el breve retraso de celebración
    if (victory_delay > 0) {
        victory_delay--;
        if (victory_delay == 0) {
            game_state = state_victory;
            coins_earned += 10;
            global.pou_monedas += 10;
            global.pou_diversion = 100;
            pou_emotion = 1; // Feliz
            
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
            if (first_card != -1) cards[first_card].flip_phase = -1;
            if (second_card != -1) cards[second_card].flip_phase = -1;
            first_card = -1;
            second_card = -1;
            mismatch_timer = 0;
            pou_emotion = 0;
            mismatch_emotion_timer = 0;
            audio_play_sound(snd_click, 1, false);
        }
    }
    
    // Si no hay desacierto bloqueando, permitir voltear cartas
    if (mismatch_timer == 0 && mouse_check_button_pressed(mb_left)) {
        for (var _i = 0; _i < array_length(cards); _i++) {
            var _cd = cards[_i];
            
            if (!_cd.is_matched && !_cd.is_face_up && _cd.flip_phase == 0) {
                var _x1 = _cd.x - _cd.w * 0.5;
                var _y1 = _cd.y - _cd.h * 0.5;
                var _x2 = _cd.x + _cd.w * 0.5;
                var _y2 = _cd.y + _cd.h * 0.5;
                
                if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)) {
                    if (first_card == -1) {
                        // Primera carta volteada
                        first_card = _i;
                        _cd.flip_phase = 1;
                        audio_play_sound(snd_click, 1, false);
                    } else if (second_card == -1 && _i != first_card) {
                        // Segunda carta volteada
                        second_card = _i;
                        _cd.flip_phase = 1;
                        moves_count++;
                        
                        // Comprobar coincidencia
                        if (cards[first_card].pair_id == cards[second_card].pair_id) {
                            // ¡PAREJA ENCONTRADA!
                            cards[first_card].is_matched = true;
                            cards[second_card].is_matched = true;
                            cards[first_card].scale_y = 1.25;
                            cards[second_card].scale_y = 1.25;
                            cards[first_card].glow = 1.0;
                            cards[second_card].glow = 1.0;
                            
                            pairs_found++;
                            coins_earned += 5;
                            global.pou_monedas += 5;
                            global.pou_diversion = min(100, global.pou_diversion + 8);
                            
                            audio_play_sound(snd_match, 1, false);
                            
                            // Reacción alegre de Pou
                            pou_jump_vy = -8.5;
                            pou_emotion = 1; // Feliz
                            
                            // Textos flotantes
                            array_push(floating_texts, {
                                x: cards[first_card].x,
                                y: cards[first_card].y - 36,
                                text: "+5 Monedas",
                                color: make_color_rgb(240, 190, 40),
                                alpha: 1.0,
                                vy: -2.4,
                                scale: 1.15
                            });
                            array_push(floating_texts, {
                                x: cards[second_card].x,
                                y: cards[second_card].y - 36,
                                text: "+5 Monedas",
                                color: make_color_rgb(240, 190, 40),
                                alpha: 1.0,
                                vy: -2.4,
                                scale: 1.15
                            });
                            
                            // Estrellitas brillantes
                            for (var _k = 0; _k < 7; _k++) {
                                array_push(particles, {
                                    x: cards[first_card].x + random_range(-30, 30),
                                    y: cards[first_card].y + random_range(-30, 30),
                                    vx: random_range(-3.5, 3.5),
                                    vy: random_range(-3.5, 3.5),
                                    color: choose(c_yellow, c_white, c_aqua),
                                    size: random_range(4, 7),
                                    alpha: 1.0
                                });
                                array_push(particles, {
                                    x: cards[second_card].x + random_range(-30, 30),
                                    y: cards[second_card].y + random_range(-30, 30),
                                    vx: random_range(-3.5, 3.5),
                                    vy: random_range(-3.5, 3.5),
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
                            mismatch_timer = 28;
                            pou_emotion = 2; // Serio / Pensativo
                            mismatch_emotion_timer = 28;
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
    var _h_retry = point_in_rectangle(mouse_x, mouse_y, 200, 765, 520, 835);
    if (mouse_check_button_pressed(mb_left) && _h_retry) {
        setup_deck();
        game_state = state_playing;
        audio_play_sound(snd_shuffle, 1, false);
        exit;
    }
    
    // Botón Volver a la Sala
    var _h_back = point_in_rectangle(mouse_x, mouse_y, 200, 855, 520, 920);
    if (mouse_check_button_pressed(mb_left) && _h_back) {
        audio_play_sound(snd_click, 1, false);
        room_goto(rm_sala);
        exit;
    }
}
