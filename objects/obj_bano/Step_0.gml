/// @desc Interacción física y lógica de baño (Jabón, Ducha, Agua, Burbujas y Limpieza)
float_t += 4;
if (rub_sound_cooldown > 0) rub_sound_cooldown--;
if (water_sound_cooldown > 0) water_sound_cooldown--;
if (soap_spawn_cooldown > 0) soap_spawn_cooldown--;
if (celebration_timer > 0) celebration_timer--;

var _pou = instance_find(obj_pou, 0);

// ========================================================
// 1. SELECCIÓN Y AGARRE DE HERRAMIENTAS (Jabón y Ducha)
// ========================================================
if (!is_dragging) {
    if (mouse_check_button_pressed(mb_left)) {
        // Agarrar Jabón
        if (point_distance(mouse_x, mouse_y, jabon_x, jabon_y) <= 60) {
            jabon_dragging = true;
            is_dragging = true;
            active_tool = "jabon";
            jabon_drag_ox = jabon_x - mouse_x;
            jabon_drag_oy = jabon_y - mouse_y;
            audio_play_sound(snd_pou_toque, 1, false);
        }
        // Agarrar Ducha
        else if (point_distance(mouse_x, mouse_y, ducha_x, ducha_y) <= 60) {
            ducha_dragging = true;
            is_dragging = true;
            active_tool = "ducha";
            ducha_drag_ox = ducha_x - mouse_x;
            ducha_drag_oy = ducha_y - mouse_y;
            audio_play_sound(snd_pou_toque, 1, false);
        }
        // Botón "¡Ensuciar!" (Permite probar el baño de nuevo)
        else if (point_in_rectangle(mouse_x, mouse_y, 480, 1115, 660, 1165)) {
            global.pou_suciedad = 100;
            if (variable_global_exists("pou_dirt_spots")) {
                for (var _i = 0; _i < array_length(global.pou_dirt_spots); _i++) {
                    global.pou_dirt_spots[_i].dirty = 1.0;
                }
            }
            bubbles = [];
            was_dirty = true;
            audio_play_sound(snd_caida, 1, false);
            if (_pou != noone) {
                _pou.cambiar_emocion(PouEmocion.Triste);
                _pou.jump_vy = -7;
            }
        }
    }
} else {
    // Soltar herramienta
    if (mouse_check_button_released(mb_left)) {
        jabon_dragging = false;
        ducha_dragging = false;
        is_dragging = false;
        active_tool = "";
    }
}

// ========================================================
// 2. LÓGICA DEL JABÓN (Enjabonar y frotar a Pou)
// ========================================================
if (jabon_dragging) {
    jabon_x = mouse_x + jabon_drag_ox;
    jabon_y = mouse_y + jabon_drag_oy;
    
    var _dx = mouse_x - prev_mouse_x;
    jabon_angle = lerp(jabon_angle, clamp(_dx * -1.5, -25, 25), 0.35);
    
    if (_pou != noone) {
        var _pou_cx = _pou.x;
        var _pou_cy = _pou.y - 170;
        var _in_pou = (sqr((jabon_x - _pou_cx) / 200) + sqr((jabon_y - _pou_cy) / 230) <= 1);
        
        if (_in_pou) {
            var _moved = point_distance(mouse_x, mouse_y, prev_mouse_x, prev_mouse_y);
            if (_moved > 2) {
                // Sonido de frote suave
                if (rub_sound_cooldown <= 0) {
                    audio_play_sound(snd_pou_rascar, 1, false);
                    rub_sound_cooldown = 14;
                }
                _pou.squash_t = 0.22;
                
                // Generar espuma/burbujas sobre el cuerpo de Pou
                if (soap_spawn_cooldown <= 0 && array_length(bubbles) < 28) {
                    soap_spawn_cooldown = 3;
                    array_push(bubbles, {
                        ox: (jabon_x - _pou.x) + random_range(-16, 16),
                        oy: (jabon_y - _pou.y) + random_range(-16, 16),
                        scale: random_range(0.55, 0.95),
                        alpha: 0.95,
                        rot: random(360)
                    });
                }
            }
        }
    }
} else {
    // Regresar a su pedestal suavemente
    jabon_x = lerp(jabon_x, jabon_home_x, 0.2);
    jabon_y = lerp(jabon_y, jabon_home_y, 0.2);
    jabon_angle = lerp(jabon_angle, 0, 0.2);
}

// ========================================================
// 3. LÓGICA DE LA DUCHA (Flujo continuo de agua)
// ========================================================
if (ducha_dragging) {
    ducha_x = mouse_x + ducha_drag_ox;
    ducha_y = mouse_y + ducha_drag_oy;
    ducha_angle = lerp(ducha_angle, -15, 0.2);
    
    // Boquilla de la regadera
    var _noz_x = ducha_x + 10;
    var _noz_y = ducha_y - 20;
    
    // Generar chorros de gotas de agua que caen hacia abajo
    repeat (3) {
        array_push(water_drops, {
            x: _noz_x + random_range(-12, 12),
            y: _noz_y + random_range(-4, 4),
            vx: random_range(-1.2, 1.2),
            vy: random_range(16, 23),
            len: random_range(16, 24),
            alpha: 0.85,
            life: 35
        });
    }
    
    // Sonido continuo de agua
    if (water_sound_cooldown <= 0) {
        audio_play_sound(snd_pou_beber, 1, false);
        water_sound_cooldown = 18;
    }
} else {
    // Regresar a su pedestal suavemente
    ducha_x = lerp(ducha_x, ducha_home_x, 0.2);
    ducha_y = lerp(ducha_y, ducha_home_y, 0.2);
    ducha_angle = lerp(ducha_angle, 0, 0.2);
}

// ========================================================
// 4. FÍSICA DE GOTAS DE AGUA Y LIMPIEZA DE BURBUJAS Y LODO
// ========================================================
for (var _d = array_length(water_drops) - 1; _d >= 0; _d--) {
    var _drop = water_drops[_d];
    _drop.x += _drop.vx;
    _drop.y += _drop.vy;
    _drop.life--;
    
    var _removed = false;
    
    if (_pou != noone) {
        // Enjuagar burbujas de jabón
        for (var _b = array_length(bubbles) - 1; _b >= 0; _b--) {
            var _bub = bubbles[_b];
            var _bx = _pou.x + _bub.ox;
            var _by = _pou.y + _bub.oy;
            if (point_distance(_drop.x, _drop.y, _bx, _by) < 32) {
                array_delete(bubbles, _b, 1);
                array_push(splashes, {
                    x: _drop.x, y: _drop.y,
                    vx: random_range(-3, 3), vy: random_range(-3, 1),
                    r: random_range(4, 7), alpha: 0.9,
                    col: c_white, life: 15
                });
                _removed = true;
                break;
            }
        }
        
        // Lavar manchas de suciedad en Pou
        if (variable_global_exists("pou_dirt_spots")) {
            for (var _s = 0; _s < array_length(global.pou_dirt_spots); _s++) {
                var _spot = global.pou_dirt_spots[_s];
                if (_spot.dirty > 0) {
                    var _sx = _pou.x + _spot.ox;
                    var _sy = _pou.y + _spot.oy;
                    if (point_distance(_drop.x, _drop.y, _sx, _sy) < (_spot.r + 20)) {
                        _spot.dirty = max(0, _spot.dirty - 0.04);
                        if (random(1) < 0.28) {
                            array_push(splashes, {
                                x: _drop.x, y: _drop.y,
                                vx: random_range(-2, 2), vy: random_range(2, 5),
                                r: random_range(3, 5), alpha: 0.8,
                                col: make_color_rgb(115, 78, 45), life: 20
                            });
                        }
                        _removed = true;
                        break;
                    }
                }
            }
        }
    }
    
    // Impacto en el suelo o fin de vida
    if (_drop.y >= 1060 || _drop.life <= 0 || _removed) {
        if (!_removed && _drop.y >= 1060 && random(1) < 0.25) {
            array_push(splashes, {
                x: _drop.x, y: 1060,
                vx: random_range(-2, 2), vy: random_range(-3, -1),
                r: random_range(3, 5), alpha: 0.6,
                col: make_color_rgb(200, 230, 255), life: 12
            });
        }
        array_delete(water_drops, _d, 1);
    }
}

// ========================================================
// 5. RECÁLCULO DE SUCIEDAD Y SALUD
// ========================================================
if (variable_global_exists("pou_dirt_spots")) {
    var _total_dirty = 0;
    var _count = array_length(global.pou_dirt_spots);
    for (var _k = 0; _k < _count; _k++) {
        _total_dirty += global.pou_dirt_spots[_k].dirty;
    }
    global.pou_suciedad = (_count > 0) ? round((_total_dirty / _count) * 100) : 0;
    global.pou_salud = round(clamp(100 - global.pou_suciedad * 0.4, 50, 100));
}

// ========================================================
// 6. CELEBRACIÓN: POU 100% LIMPIO
// ========================================================
if (global.pou_suciedad <= 0 && array_length(bubbles) == 0 && was_dirty) {
    was_dirty = false;
    celebration_timer = 150;
    celebration_text = "+10 Monedas  ¡Pou Limpio!";
    global.pou_salud = 100;
    global.pou_monedas += 10;
    audio_play_sound(snd_acierto, 1, false);
    audio_play_sound(snd_moneda, 1, false);
    
    if (_pou != noone) {
        _pou.cambiar_emocion(PouEmocion.Feliz);
        _pou.jump_vy = -16;
    }
    
    // Generar estrellas brillantes de limpieza ✨
    for (var _sp = 0; _sp < 24; _sp++) {
        var _px = (_pou != noone) ? _pou.x : 360;
        var _py = (_pou != noone) ? _pou.y - 170 : 600;
        array_push(sparkles, {
            x: _px + random_range(-140, 140),
            y: _py + random_range(-140, 140),
            vx: random_range(-2, 2),
            vy: random_range(-3, -0.5),
            scale: random_range(0.8, 1.5),
            alpha: 1.0,
            rot: random(360),
            rot_spd: random_range(-5, 5),
            life: irandom_range(35, 60)
        });
    }
}

// ========================================================
// 7. ACTUALIZACIÓN DE SALPICADURAS Y DESTELLOS
// ========================================================
for (var _s = array_length(splashes) - 1; _s >= 0; _s--) {
    var _sp = splashes[_s];
    _sp.x += _sp.vx;
    _sp.y += _sp.vy;
    _sp.vy += 0.2;
    _sp.life--;
    _sp.alpha = _sp.life / 20;
    if (_sp.life <= 0) array_delete(splashes, _s, 1);
}

for (var _p = array_length(sparkles) - 1; _p >= 0; _p--) {
    var _star = sparkles[_p];
    _star.x += _star.vx;
    _star.y += _star.vy;
    _star.rot += _star.rot_spd;
    _star.life--;
    _star.alpha = clamp(_star.life / 30, 0, 1);
    if (_star.life <= 0) array_delete(sparkles, _p, 1);
}

prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;
