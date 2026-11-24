/// @desc Interacción táctil y física de comida y menú de Nevera (estilo Pou original)
float_t += 4;
if (bite_cooldown > 0) bite_cooldown--;

// Manejo dinámico de profundidad para que el orden de renderizado sea siempre perfecto
depth = fridge_open ? -1000 : (is_dragging ? -100 : 10);

var _pou = instance_find(obj_pou, 0);

// ========================================================
// 1. GESTIÓN DEL MENÚ MODAL DE LA NEVERA
// ========================================================
if (fridge_open) {
    // Si se suelta o cancela cualquier arrastre previo
    is_dragging = false;
    if (_pou != noone) {
        _pou.mouth_open = false;
        _pou.refusing = false;
    }
    
    // Clics dentro del menú de la nevera
    if (mouse_check_button_pressed(mb_left)) {
        // Botón cerrar "X" (Esquina superior derecha del modal)
        if (point_distance(mouse_x, mouse_y, 652, 65) <= 28) {
            fridge_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Botón inferior "Volver a la Cocina"
        if (point_in_rectangle(mouse_x, mouse_y, 360 - 160, 1150, 360 + 160, 1204)) {
            fridge_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Clic fuera del modal para cerrar
        if (mouse_x < 20 || mouse_x > 700 || mouse_y < 20 || mouse_y > 1240) {
            fridge_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Cuadrícula de 10 alimentos (2 columnas x 5 filas)
        for (var _i = 0; _i < array_length(foods); _i++) {
            var _col = _i mod 2;
            var _row = floor(_i / 2);
            var _card_x = (_col == 0) ? 35 : 365;
            var _card_y = 115 + _row * 195;
            
            // Botón "Servir" / "Elegir" (pone la comida en el plato)
            var _s_x1 = _card_x + 112;
            var _s_y1 = _card_y + 118;
            var _s_x2 = _s_x1 + 92;
            var _s_y2 = _s_y1 + 40;
            
            if (point_in_rectangle(mouse_x, mouse_y, _s_x1, _s_y1, _s_x2, _s_y2)) {
                food_index = _i;
                bites_remaining = bites_total;
                food_x = plate_x;
                food_y = plate_y;
                food_punch = 1.3;
                fridge_open = false;
                audio_play_sound(snd_click, 1, false);
                exit;
            }
            
            // Botón "+ Comprar"
            var _b_x1 = _card_x + 212;
            var _b_y1 = _card_y + 118;
            var _b_x2 = _b_x1 + 96;
            var _b_y2 = _b_y1 + 40;
            
            if (point_in_rectangle(mouse_x, mouse_y, _b_x1, _b_y1, _b_x2, _b_y2)) {
                if (global.pou_monedas >= foods[_i].price) {
                    global.pou_monedas -= foods[_i].price;
                    foods[_i].count += 1;
                    global.pou_food_counts[_i] = foods[_i].count;
                    audio_play_sound(snd_comprar, 1, false);
                } else {
                    audio_play_sound(snd_no, 1, false);
                }
                exit;
            }
        }
    }
    
    // Mientras la nevera esté abierta, no procesar el resto de la cocina
    exit;
}

// ========================================================
// 2. INTERACCIÓN NORMAL EN LA COCINA (Plato, Nevera, Arrastre)
// ========================================================
var _current_food = foods[food_index];

if (!is_dragging) {
    // Abrir Nevera
    if (mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, nevera_x, nevera_y) <= 45) {
        fridge_open = true;
        audio_play_sound(snd_click, 1, false);
        exit;
    }
    
    // Flecha izquierda (<)
    else if (mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, arrow_left_x, arrow_left_y) <= arrow_radius) {
        food_index = (food_index - 1 + array_length(foods)) mod array_length(foods);
        bites_remaining = bites_total;
        food_x = plate_x;
        food_y = plate_y;
        food_punch = 1.25;
        audio_play_sound(snd_click, 1, false);
    }
    
    // Flecha derecha (>)
    else if (mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, arrow_right_x, arrow_right_y) <= arrow_radius) {
        food_index = (food_index + 1) mod array_length(foods);
        bites_remaining = bites_total;
        food_x = plate_x;
        food_y = plate_y;
        food_punch = 1.25;
        audio_play_sound(snd_click, 1, false);
    }
    
    // Botón comprar en plato si se agotó
    else if (_current_food.count <= 0 && mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mouse_x, mouse_y, plate_x - btn_buy_w * 0.5, plate_y + 55, plate_x + btn_buy_w * 0.5, plate_y + 55 + btn_buy_h)) {
            if (global.pou_monedas >= _current_food.price) {
                global.pou_monedas -= _current_food.price;
                _current_food.count += 1;
                global.pou_food_counts[food_index] = _current_food.count;
                audio_play_sound(snd_comprar, 1, false);
            } else {
                audio_play_sound(snd_no, 1, false);
            }
        }
    }
    
    // Iniciar arrastre de la comida si hay stock
    else if (_current_food.count > 0 && mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, food_x, food_y) <= 65) {
        is_dragging = true;
        drag_offset_x = food_x - mouse_x;
        drag_offset_y = food_y - mouse_y;
        prev_mouse_x = mouse_x;
        audio_play_sound(snd_pou_toque, 1, false);
    }
}

// Lógica durante el arrastre con ratón/cursor
if (is_dragging) {
    // Seguimiento inmediato y directo del cursor (sin retraso que cause jitter)
    food_x = mouse_x + drag_offset_x;
    food_y = mouse_y + drag_offset_y;
    
    // Inclinación suave según la velocidad horizontal del ratón
    var _dx = mouse_x - prev_mouse_x;
    food_angle = lerp(food_angle, clamp(_dx * -1.2, -20, 20), 0.35);
    prev_mouse_x = mouse_x;
    
    if (_pou != noone) {
        // Coordenadas fijas y estables de la boca de Pou (sin verse afectadas por head_shake_x)
        var _mouth_x = _pou.x;
        var _mouth_y = _pou.y - 182;
        var _dist = point_distance(food_x, food_y, _mouth_x, _mouth_y);
        
        // Zona de anticipación con histéresis estable (abre a < 190, cierra a > 230)
        if (_pou.mouth_open || _pou.refusing) {
            if (_dist > 230) {
                _pou.mouth_open = false;
                _pou.refusing = false;
            }
        } else {
            if (_dist < 190) {
                if (global.pou_hambre < 100) {
                    _pou.mouth_open = true;
                    audio_play_sound(snd_pou_boca, 2, false);
                } else {
                    _pou.refusing = true;
                    _pou.head_shake_timer = 25;
                    audio_play_sound(snd_no, 2, false);
                }
            }
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
                bite_cooldown = 24;
                bites_remaining--;
                food_punch = 1.3;
                
                // Animación de masticar suave en Pou (sin activar squash violento)
                _pou.chew_timer = 20;
                
                // Sonido de mordisco o bebida
                if (_current_food.is_drink) {
                    audio_play_sound(snd_pou_beber, 2, false);
                } else {
                    var _s = bite_sounds[irandom(array_length(bite_sounds) - 1)];
                    audio_play_sound(_s, 2, false);
                }
                
                // Generar migas / partículas
                for (var _k = 0; _k < 10; _k++) {
                    var _col_idx = irandom(array_length(_current_food.crumbs) - 1);
                    var _c_col = _current_food.crumbs[_col_idx];
                    array_push(crumbs, {
                        x: _mouth_x + random_range(-12, 12),
                        y: _mouth_y + random_range(-8, 8),
                        vx: random_range(-3.5, 3.5),
                        vy: random_range(-4, 0),
                        col: _c_col,
                        radius: random_range(3, 5),
                        alpha: 1.0,
                        life: irandom_range(20, 35)
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
                    
                    // Al comer, Pou se ensucia gradualmente como en el juego original
                    global.pou_suciedad = min(100, global.pou_suciedad + 8);
                    if (variable_global_exists("pou_dirt_spots")) {
                        for (var _k = 0; _k < array_length(global.pou_dirt_spots); _k++) {
                            global.pou_dirt_spots[_k].dirty = min(1.0, global.pou_dirt_spots[_k].dirty + 0.1);
                        }
                    }
                    
                    // Recompensa en monedas (+2)
                    global.pou_monedas += 2;
                    audio_play_sound(snd_moneda, 1, false);
                    
                    food_x = plate_x;
                    food_y = plate_y;
                    food_punch = 1.25;
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
    // Retorno suave y flotación sutil en el plato
    var _float_offset = dsin(float_t) * 3;
    food_x = lerp(food_x, plate_x, 0.25);
    food_y = lerp(food_y, plate_y + _float_offset, 0.25);
    food_angle = lerp(food_angle, 0, 0.25);
}

// Reducción del punch de escala
food_punch = max(1.0, food_punch - 0.03);

// Actualizar partículas de migas
for (var _i = array_length(crumbs) - 1; _i >= 0; _i--) {
    var _c = crumbs[_i];
    _c.x += _c.vx;
    _c.y += _c.vy;
    _c.vy += 0.35; // Gravedad
    _c.life--;
    _c.alpha = _c.life / 25;
    if (_c.life <= 0) {
        array_delete(crumbs, _i, 1);
    }
}
