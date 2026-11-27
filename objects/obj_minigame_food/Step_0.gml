/// @desc Lógica de juego, física de Pou, caída de alimentos y detección de colisiones - Versión Pulida

anim_t += 2.0;

// Animación de nubes flotantes en el cielo
for (var _c = 0; _c < array_length(clouds); _c++) {
    clouds[_c].x += clouds[_c].spd;
    if (clouds[_c].x > room_width + 120) {
        clouds[_c].x = -150;
    }
}

// Sacudida de pantalla (Screen Shake)
if (shake_timer > 0) {
    shake_timer--;
    shake_x = choose(-4, 4, -2, 2);
    shake_y = choose(-3, 3, -1, 1);
} else {
    shake_x = 0;
    shake_y = 0;
}

// Actualización de partículas
for (var _p = array_length(particles) - 1; _p >= 0; _p--) {
    var _part = particles[_p];
    _part.x += _part.vx;
    _part.y += _part.vy;
    _part.vy += 0.25;
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
// 1. BOTONES SUPERIORES: SALIR Y PAUSA
// ========================================================
var _btn_exit = point_in_rectangle(mouse_x, mouse_y, 20, 20, 135, 68);
if (mouse_check_button_pressed(mb_left) && _btn_exit) {
    audio_play_sound(snd_click, 1, false);
    room_goto(rm_sala);
    exit;
}

// ========================================================
// 2. ESTADO: PANTALLA DE INSTRUCCIONES / LISTO (STATE_READY)
// ========================================================
if (game_state == state_ready) {
    var _btn_start = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 780, 360 + 150, 850);
    var _key_start = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("D"));
    
    if ((mouse_check_button_pressed(mb_left) && _btn_start) || _key_start) {
        game_state = state_playing;
        spawn_timer = 20; // Primer item rápido
        audio_play_sound(snd_click, 1, false);
        exit;
    }
}

// ========================================================
// 3. ESTADO: EN JUEGO (STATE_PLAYING)
// ========================================================
if (game_state == state_playing) {
    // 3.1 Pausa opcional con tecla P o ESC
    if (keyboard_check_pressed(ord("P")) || keyboard_check_pressed(vk_escape)) {
        game_state = state_paused;
        audio_play_sound(snd_click, 1, false);
        exit;
    }
    
    // 3.2 Controles de movimiento de Pou (Soporte simultáneo Teclado + Mouse/Touch)
    var _mouse_moved = (abs(mouse_x - prev_mouse_x) > 1.5);
    
    // Si se mueven teclas
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        pou_target_x -= 16;
        using_mouse = false;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        pou_target_x += 16;
        using_mouse = false;
    }
    
    // Si se mueve o toca el mouse en el área de juego
    if (point_in_rectangle(mouse_x, mouse_y, 0, 80, room_width, 1200)) {
        if (_mouse_moved || mouse_check_button(mb_left)) {
            pou_target_x = mouse_x;
            using_mouse = true;
        }
    }
    prev_mouse_x = mouse_x;
    
    // Suavizado e interpolación fluida de Pou
    pou_target_x = clamp(pou_target_x, 85, room_width - 85);
    pou_x = lerp(pou_x, pou_target_x, 0.40);
    
    // Animación elástica de Pou
    pou_scale_x = lerp(pou_scale_x, pou_base_scale, 0.15);
    pou_scale_y = lerp(pou_scale_y, pou_base_scale, 0.15);
    
    // Timers de reacción y de invulnerabilidad tras ser golpeado
    if (eat_timer > 0) eat_timer--;
    if (invulnerable_timer > 0) invulnerable_timer--;
    
    if (hurt_timer > 0) {
        hurt_timer--;
        head_shake_x = dsin(hurt_timer * 40) * 12;
        pou_emotion = 5; // Enfermo / Aturdido
    } else {
        head_shake_x = 0;
        pou_emotion = (eat_timer > 0) ? 1 : 1; // Feliz
    }
    
    // 3.3 Spawner inteligente de alimentos y obstáculos
    spawn_timer++;
    var _cur_interval = max(24, spawn_interval_base - floor(score_food * 0.65));
    if (spawn_timer >= _cur_interval) {
        spawn_timer = 0;
        
        // 18% probabilidad de zapato u herradura, 82% comida deliciosa
        var _is_hazard = (random(100) < 18);
        var _spr = -1;
        if (_is_hazard) {
            _spr = hazard_sprites[irandom(array_length(hazard_sprites) - 1)];
        } else {
            _spr = food_sprites[irandom(array_length(food_sprites) - 1)];
        }
        
        // Evitar que dos items caigan en la misma columna exacta
        var _spawn_x = irandom_range(90, room_width - 90);
        if (abs(_spawn_x - last_spawn_x) < 120) {
            if (_spawn_x > room_width * 0.5) _spawn_x -= 140;
            else _spawn_x += 140;
            _spawn_x = clamp(_spawn_x, 90, room_width - 90);
        }
        last_spawn_x = _spawn_x;
        
        var _fall_spd = fall_speed_base + min(7.5, score_food * 0.12) + random_range(-0.3, 0.6);
        var _new_item = {
            x: _spawn_x,
            y: -35,
            vy: _fall_spd,
            rot: random(360),
            rot_spd: random_range(-2.5, 2.5),
            sprite: _spr,
            is_hazard: _is_hazard,
            scale: 0.85
        };
        array_push(falling_items, _new_item);
    }
    
    // 3.4 Movimiento y detección de colisiones de los items cayendo
    for (var _i = array_length(falling_items) - 1; _i >= 0; _i--) {
        var _it = falling_items[_i];
        _it.y += _it.vy;
        _it.rot += _it.rot_spd;
        
        // Detección de colisión amplia y sin efecto túnel con la boca de Pou (pou_x, pou_y - 25)
        var _dx = abs(_it.x - pou_x);
        var _dy = _it.y - (pou_y - 28);
        
        if (_dx <= 82 && _dy >= -38 && _dy <= 42) {
            if (!_it.is_hazard) {
                // ¡Comida atrapada con éxito!
                score_food++;
                combo++;
                if (combo > max_combo) max_combo = combo;
                
                coins_earned++;
                global.pou_monedas++;
                global.pou_diversion = min(100, global.pou_diversion + 2.5);
                
                audio_play_sound(eat_sounds[irandom(array_length(eat_sounds) - 1)], 1, false);
                
                // Efecto de rebote elástico de Pou
                pou_scale_x = pou_base_scale * 1.35;
                pou_scale_y = pou_base_scale * 0.82;
                eat_timer = 18;
                
                // Bonificación especial por Combo cada 5 comidas consecutivas
                if (combo mod 5 == 0) {
                    coins_earned += 2;
                    global.pou_monedas += 2;
                    audio_play_sound(snd_moneda, 1, false);
                    array_push(floating_texts, {
                        x: pou_x,
                        y: pou_y - 95,
                        text: "COMBO x" + string(combo) + "! +2 Monedas",
                        color: make_color_rgb(255, 215, 40),
                        alpha: 1.0,
                        vy: -2.8,
                        scale: 1.25
                    });
                }
                
                // Texto flotante "+1"
                array_push(floating_texts, {
                    x: pou_x,
                    y: pou_y - 60,
                    text: "+1",
                    color: make_color_rgb(60, 180, 50),
                    alpha: 1.0,
                    vy: -2.6,
                    scale: 1.35
                });
                
                // Partículas de comida saltando
                for (var _k = 0; _k < 6; _k++) {
                    array_push(particles, {
                        x: pou_x + random_range(-25, 25),
                        y: pou_y - 25 + random_range(-15, 15),
                        vx: random_range(-4, 4),
                        vy: random_range(-6, -2),
                        color: choose(c_orange, c_yellow, c_red, c_white),
                        size: random_range(4, 7),
                        alpha: 1.0
                    });
                }
                
                array_delete(falling_items, _i, 1);
                continue;
            } else {
                // Comió basura / zapato / herradura
                if (invulnerable_timer <= 0) {
                    lives_count--;
                    combo = 0; // Rompe racha
                    invulnerable_timer = 45; // 45 frames de gracia para no morir en cadena
                    hurt_timer = 32;
                    shake_timer = 15;
                    audio_play_sound(snd_no, 1, false);
                    
                    array_push(floating_texts, {
                        x: pou_x,
                        y: pou_y - 65,
                        text: "-1 VIDA",
                        color: make_color_rgb(225, 45, 45),
                        alpha: 1.0,
                        vy: -2.8,
                        scale: 1.35
                    });
                    
                    if (lives_count <= 0) {
                        game_state = state_gameover;
                        if (score_food > global.food_drop_highscore) {
                            global.food_drop_highscore = score_food;
                            is_new_record = true;
                        }
                        audio_play_sound(snd_gameover, 1, false);
                    }
                }
                array_delete(falling_items, _i, 1);
                continue;
            }
        }
        
        // Item toca el suelo (y >= 1130)
        if (_it.y >= 1130) {
            if (!_it.is_hazard) {
                // Comida que cayó sin atrapar
                lives_count--;
                combo = 0; // Rompe racha
                audio_play_sound(snd_caida, 1, false);
                shake_timer = 10;
                
                array_push(floating_texts, {
                    x: _it.x,
                    y: 1100,
                    text: "FALLO!",
                    color: make_color_rgb(230, 50, 50),
                    alpha: 1.0,
                    vy: -2.2,
                    scale: 1.15
                });
                
                array_delete(falling_items, _i, 1);
                
                if (lives_count <= 0) {
                    game_state = state_gameover;
                    if (score_food > global.food_drop_highscore) {
                        global.food_drop_highscore = score_food;
                        is_new_record = true;
                    }
                    audio_play_sound(snd_gameover, 1, false);
                }
                continue;
            } else {
                // Obstáculo esquivado con éxito
                array_delete(falling_items, _i, 1);
                continue;
            }
        }
    }
}

// ========================================================
// 4. ESTADO: PAUSA (STATE_PAUSED)
// ========================================================
if (game_state == state_paused) {
    var _btn_resume = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 580, 360 + 150, 645);
    var _btn_quit   = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 665, 360 + 150, 730);
    
    if (keyboard_check_pressed(ord("P")) || keyboard_check_pressed(vk_escape)) {
        game_state = state_playing;
        audio_play_sound(snd_click, 1, false);
        exit;
    }
    
    if (mouse_check_button_pressed(mb_left)) {
        if (_btn_resume) {
            game_state = state_playing;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        if (_btn_quit) {
            audio_play_sound(snd_click, 1, false);
            room_goto(rm_sala);
            exit;
        }
    }
}

// ========================================================
// 5. ESTADO: JUEGO TERMINADO (STATE_GAMEOVER)
// ========================================================
if (game_state == state_gameover) {
    pou_emotion = 3; // Triste
    
    // Botón Reintentar
    var _h_retry = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 770, 360 + 150, 835);
    if (mouse_check_button_pressed(mb_left) && _h_retry) {
        score_food = 0;
        coins_earned = 0;
        lives_count = max_lives;
        combo = 0;
        falling_items = [];
        particles = [];
        floating_texts = [];
        is_new_record = false;
        pou_emotion = 1;
        game_state = state_playing;
        audio_play_sound(snd_click, 1, false);
        exit;
    }
    
    // Botón Volver a la Sala
    var _h_back = point_in_rectangle(mouse_x, mouse_y, 360 - 150, 855, 360 + 150, 920);
    if (mouse_check_button_pressed(mb_left) && _h_back) {
        audio_play_sound(snd_click, 1, false);
        room_goto(rm_sala);
        exit;
    }
}
