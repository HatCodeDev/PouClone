/// @desc Interacción de Lámpara, Sueño y Armario en el Dormitorio
depth = closet_open ? -1000 : 10;

var _pou = instance_find(obj_pou, 0);

// ========================================================
// 1. INTERACCIÓN CUANDO EL ARMARIO ESTÁ CERRADO
// ========================================================
if (!closet_open) {
    if (mouse_check_button_pressed(mb_left)) {
        // Clic en la Lámpara (Encender / Apagar)
        if (point_distance(mouse_x, mouse_y, lamp_x, lamp_y) <= 55) {
            global.pou_lamp_on = !global.pou_lamp_on;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Clic en el Armario (Abrir menú de ropa)
        if (point_distance(mouse_x, mouse_y, closet_x, closet_y) <= 55) {
            closet_open = true;
            closet_page = 0;
            preview_bounce = 0.6;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
    }
    
    // Lógica de descanso y recuperación de energía con la lámpara apagada
    if (!global.pou_lamp_on) {
        global.pou_energia = min(100, global.pou_energia + 0.08);
        
        zzz_timer++;
        if (zzz_timer >= 32) {
            zzz_timer = 0;
            var _px = (_pou != noone) ? _pou.x + 40 : 400;
            var _py = (_pou != noone) ? _pou.y - 190 : 580;
            array_push(zzz_particles, {
                x: _px + random_range(-10, 10),
                y: _py + random_range(-5, 5),
                vx: random_range(0.4, 1.2),
                vy: random_range(-1.8, -1.1),
                scale: random_range(0.9, 1.4),
                alpha: 1.0,
                life: 55
            });
        }
    }
}

// ========================================================
// 2. GESTIÓN DEL MODAL DEL ARMARIO Y PROBADOR EN VIVO
// ========================================================
if (closet_open) {
    // Animación de rebote suave de Pou en el probador
    if (preview_bounce > 0) {
        preview_bounce = max(0, preview_bounce - 0.05);
    }
    
    if (mouse_check_button_pressed(mb_left)) {
        // Botón Cerrar "X" superior derecho
        if (point_distance(mouse_x, mouse_y, 652, 65) <= 26) {
            closet_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Botón inferior "Volver al Dormitorio"
        if (point_in_rectangle(mouse_x, mouse_y, 180, 1180, 540, 1236)) {
            closet_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Botón "Desvestir Todo"
        if (point_in_rectangle(mouse_x, mouse_y, 490, 105, 675, 145)) {
            global.pou_sombrero = -1;
            global.pou_lentes = -1;
            global.pou_ropa = -1;
            global.pou_bigote = -1;
            preview_bounce = 1.0;
            audio_play_sound(snd_shuffle, 1, false);
            exit;
        }
        
        // Pestañas de categorías: 0: Sombreros, 1: Lentes, 2: Ropa, 3: Bigotes (y: 515..560)
        if (point_in_rectangle(mouse_x, mouse_y, 36, 515, 188, 560)) {
            if (closet_tab != 0) { closet_tab = 0; closet_page = 0; audio_play_sound(snd_click, 1, false); }
            exit;
        }
        if (point_in_rectangle(mouse_x, mouse_y, 194, 515, 346, 560)) {
            if (closet_tab != 1) { closet_tab = 1; closet_page = 0; audio_play_sound(snd_click, 1, false); }
            exit;
        }
        if (point_in_rectangle(mouse_x, mouse_y, 352, 515, 504, 560)) {
            if (closet_tab != 2) { closet_tab = 2; closet_page = 0; audio_play_sound(snd_click, 1, false); }
            exit;
        }
        if (point_in_rectangle(mouse_x, mouse_y, 510, 515, 662, 560)) {
            if (closet_tab != 3) { closet_tab = 3; closet_page = 0; audio_play_sound(snd_click, 1, false); }
            exit;
        }
        
        // Obtener la lista activa según la pestaña
        var _items = sombreros;
        if (closet_tab == 1) _items = lentes;
        else if (closet_tab == 2) _items = ropas;
        else if (closet_tab == 3) _items = bigotes;
        
        var _start_idx = closet_page * 6;
        var _end_idx = min(array_length(_items), _start_idx + 6);
        
        // Clic en las tarjetas del catálogo
        for (var _k = _start_idx; _k < _end_idx; _k++) {
            var _local_i = _k - _start_idx;
            var _card_x = (_local_i mod 2 == 0) ? 45 : 365;
            var _card_y = 575 + floor(_local_i / 2) * 185;
            var _card_w = 310;
            var _card_h = 175;
            
            if (point_in_rectangle(mouse_x, mouse_y, _card_x, _card_y, _card_x + _card_w, _card_y + _card_h)) {
                var _spr = _items[_k].sprite;
                
                if (closet_tab == 0) {
                    if (global.pou_sombrero == _spr && _spr != -1) {
                        global.pou_sombrero = -1;
                        audio_play_sound(snd_click, 1, false);
                        preview_bounce = 0.5;
                    } else {
                        global.pou_sombrero = _spr;
                        audio_play_sound(snd_pocion, 1, false);
                        preview_bounce = 1.0;
                    }
                } else if (closet_tab == 1) {
                    if (global.pou_lentes == _spr && _spr != -1) {
                        global.pou_lentes = -1;
                        audio_play_sound(snd_click, 1, false);
                        preview_bounce = 0.5;
                    } else {
                        global.pou_lentes = _spr;
                        audio_play_sound(snd_pocion, 1, false);
                        preview_bounce = 1.0;
                    }
                } else if (closet_tab == 2) {
                    if (global.pou_ropa == _spr && _spr != -1) {
                        global.pou_ropa = -1;
                        audio_play_sound(snd_click, 1, false);
                        preview_bounce = 0.5;
                    } else {
                        global.pou_ropa = _spr;
                        audio_play_sound(snd_pocion, 1, false);
                        preview_bounce = 1.0;
                    }
                } else if (closet_tab == 3) {
                    if (global.pou_bigote == _spr && _spr != -1) {
                        global.pou_bigote = -1;
                        audio_play_sound(snd_click, 1, false);
                        preview_bounce = 0.5;
                    } else {
                        global.pou_bigote = _spr;
                        audio_play_sound(snd_pocion, 1, false);
                        preview_bounce = 1.0;
                    }
                }
                exit;
            }
        }
        
        // Flechas de paginación si hay más de 6 ítems
        if (array_length(_items) > 6) {
            // Flecha izquierda
            if (point_in_rectangle(mouse_x, mouse_y, 220, 1130, 290, 1170) && closet_page > 0) {
                closet_page--;
                audio_play_sound(snd_click, 1, false);
                exit;
            }
            // Flecha derecha
            if (point_in_rectangle(mouse_x, mouse_y, 430, 1130, 500, 1170) && (_start_idx + 6) < array_length(_items)) {
                closet_page++;
                audio_play_sound(snd_click, 1, false);
                exit;
            }
        }
    }
    exit;
}

// ========================================================
// 3. ACTUALIZACIÓN DE PARTÍCULAS Zzz
// ========================================================
for (var _z = array_length(zzz_particles) - 1; _z >= 0; _z--) {
    var _zp = zzz_particles[_z];
    _zp.x += _zp.vx;
    _zp.y += _zp.vy;
    _zp.life--;
    _zp.alpha = _zp.life / 55;
    if (_zp.life <= 0) array_delete(zzz_particles, _z, 1);
}
