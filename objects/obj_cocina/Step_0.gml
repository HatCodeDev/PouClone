/// @desc Interacción táctil y física de comida (estilo Pou original)
float_t += 4;
if (bite_cooldown > 0) bite_cooldown--;

var _current_food = foods[food_index];
var _pou = instance_find(obj_pou, 0);

// Comprobar clics en botones de la interfaz cuando NO se está arrastrando
if (!is_dragging) {
    // Flecha izquierda (<)
    if (mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, arrow_left_x, arrow_left_y) <= arrow_radius) {
        food_index = (food_index - 1 + array_length(foods)) mod array_length(foods);
        bites_remaining = bites_total;
        food_x = plate_x;
        food_y = plate_y;
        food_punch = 1.3;
        audio_play_sound(snd_click, 1, false);
    }
    
    // Flecha derecha (>)
    else if (mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, arrow_right_x, arrow_right_y) <= arrow_radius) {
        food_index = (food_index + 1) mod array_length(foods);
        bites_remaining = bites_total;
        food_x = plate_x;
        food_y = plate_y;
        food_punch = 1.3;
        audio_play_sound(snd_click, 1, false);
    }
    
    // Botón de Nevera / Tienda rápida
    else if (mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, nevera_x, nevera_y) <= 45) {
        if (global.pou_monedas >= _current_food.price) {
            global.pou_monedas -= _current_food.price;
            _current_food.count++;
            global.pou_food_counts[food_index] = _current_food.count;
            audio_play_sound(snd_comprar, 1, false);
        } else {
            audio_play_sound(snd_no, 1, false);
        }
    }
    
    // Botón comprar si se agotó (count == 0)
    else if (_current_food.count <= 0 && mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mouse_x, mouse_y, plate_x - btn_buy_w * 0.5, plate_y + 45, plate_x + btn_buy_w * 0.5, plate_y + 45 + btn_buy_h)) {
            if (global.pou_monedas >= _current_food.price) {
                global.pou_monedas -= _current_food.price;
                _current_food.count += 2;
                global.pou_food_counts[food_index] = _current_food.count;
                audio_play_sound(snd_comprar, 1, false);
            } else {
                audio_play_sound(snd_no, 1, false);
            }
        }
    }
    
    // Iniciar arrastre de la comida si hay stock
    else if (_current_food.count > 0 && mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, food_x, food_y) <= 60) {
        is_dragging = true;
        drag_offset_x = food_x - mouse_x;
        drag_offset_y = food_y - mouse_y;
        audio_play_sound(snd_pou_toque, 1, false);
    }
}

// Lógica durante el arrastre
if (is_dragging) {
    var _prev_x = food_x;
    food_target_x = mouse_x + drag_offset_x;
    food_target_y = mouse_y + drag_offset_y;
    
    // Movimiento fluido que responde a la posición del puntero/dedo
    food_x = lerp(food_x, food_target_x, 0.7);
    food_y = lerp(food_y, food_target_y, 0.7);
    food_angle = clamp((food_x - _prev_x) * -2.0, -25, 25);
    
    if (_pou != noone) {
        // Coordenadas de la boca de Pou
        var _mouth_x = _pou.x + _pou.head_shake_x;
        var _mouth_y = _pou.y + _pou.jump_y - 182;
        var _dist = point_distance(food_x, food_y, _mouth_x, _mouth_y);
        
        // Zona de anticipación: Pou abre la boca con el sonido "¡oh!"
        if (_dist < 210) {
            if (global.pou_hambre < 100) {
                if (!_pou.mouth_open) {
                    _pou.mouth_open = true;
                    audio_play_sound(snd_pou_boca, 2, false);
                }
            } else {
                // Pou lleno rechaza: dice "No" y sacude la cabeza
                if (!_pou.refusing) {
                    _pou.refusing = true;
                    _pou.head_shake_timer = 30;
                    audio_play_sound(snd_no, 2, false);
                }
            }
        } else {
            _pou.mouth_open = false;
            _pou.refusing = false;
        }
        
        // Zona de mordisco (contacto directo con la boca)
        if (_dist < 60) {
            if (global.pou_hambre >= 100) {
                if (_pou.head_shake_timer <= 0) {
                    _pou.head_shake_timer = 25;
                    audio_play_sound(snd_no, 2, false);
                }
            } else if (bite_cooldown <= 0) {
                // Dar mordisco
                bite_cooldown = 22;
                bites_remaining--;
                food_punch = 1.4;
                
                // Animación de masticar y squash en Pou
                _pou.squash_t = 0.9;
                _pou.chew_timer = 20;
                
                // Sonido de mordisco o bebida
                if (_current_food.is_drink) {
                    audio_play_sound(snd_pou_beber, 2, false);
                } else {
                    var _s = bite_sounds[irandom(array_length(bite_sounds) - 1)];
                    audio_play_sound(_s, 2, false);
                }
                
                // Generar migas / partículas
                for (var _k = 0; _k < 12; _k++) {
                    var _col_idx = irandom(array_length(_current_food.crumbs) - 1);
                    var _c_col = _current_food.crumbs[_col_idx];
                    array_push(crumbs, {
                        x: _mouth_x + random_range(-15, 15),
                        y: _mouth_y + random_range(-10, 10),
                        vx: random_range(-4, 4),
                        vy: random_range(-5, 0),
                        col: _c_col,
                        radius: random_range(3, 6),
                        alpha: 1.0,
                        life: irandom_range(25, 40)
                    });
                }
                
                // Incremento de hambre y salud
                var _nutr = ceil(_current_food.nutrition / bites_total);
                global.pou_hambre = min(100, global.pou_hambre + _nutr);
                global.pou_salud = min(100, global.pou_salud + 1);
                
                // Si la comida ha sido totalmente consumida
                if (bites_remaining <= 0) {
                    _current_food.count = max(0, _current_food.count - 1);
                    global.pou_food_counts[food_index] = _current_food.count;
                    bites_remaining = bites_total;
                    is_dragging = false;
                    _pou.mouth_open = false;
                    _pou.jump_vy = -8;
                    audio_play_sound(snd_pou_hablar, 2, false);
                    
                    // Recompensa en monedas (+2)
                    global.pou_monedas += 2;
                    audio_play_sound(snd_moneda, 1, false);
                    
                    food_x = plate_x;
                    food_y = plate_y;
                    food_punch = 1.3;
                }
            }
        }
    }
    
    // Soltar comida si se levanta el botón del ratón
    if (mouse_check_button_released(mb_left)) {
        is_dragging = false;
        if (_pou != noone) {
            _pou.mouth_open = false;
            _pou.refusing = false;
        }
    }
} else {
    // Retorno suave y flotación en el plato
    var _float_offset = dsin(float_t) * 3;
    food_x = lerp(food_x, plate_x, 0.2);
    food_y = lerp(food_y, plate_y + _float_offset, 0.2);
    food_angle = lerp(food_angle, 0, 0.2);
}

// Reducción del punch de escala
food_punch = max(1.0, food_punch - 0.04);

// Actualizar partículas de migas
for (var _i = array_length(crumbs) - 1; _i >= 0; _i--) {
    var _c = crumbs[_i];
    _c.x += _c.vx;
    _c.y += _c.vy;
    _c.vy += 0.35; // Gravedad
    _c.life--;
    _c.alpha = _c.life / 30;
    if (_c.life <= 0) {
        array_delete(crumbs, _i, 1);
    }
}
