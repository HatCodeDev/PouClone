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
// 2. GESTIÓN DEL MODAL DEL ARMARIO (Equipar sombreros y lentes)
// ========================================================
if (closet_open) {
    if (mouse_check_button_pressed(mb_left)) {
        // Botón Cerrar "X"
        if (point_distance(mouse_x, mouse_y, 652, 65) <= 28) {
            closet_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Botón inferior "Volver al Dormitorio"
        if (point_in_rectangle(mouse_x, mouse_y, 360 - 160, 1150, 360 + 160, 1204)) {
            closet_open = false;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Pestañas: 0: Sombreros, 1: Lentes
        if (point_in_rectangle(mouse_x, mouse_y, 60, 120, 340, 165)) {
            closet_tab = 0;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        if (point_in_rectangle(mouse_x, mouse_y, 380, 120, 660, 165)) {
            closet_tab = 1;
            audio_play_sound(snd_click, 1, false);
            exit;
        }
        
        // Selección de Sombreros (Pestaña 0)
        if (closet_tab == 0) {
            for (var _i = 0; _i < array_length(sombreros); _i++) {
                var _card_x = (_i mod 2 == 0) ? 60 : 380;
                var _card_y = 200 + floor(_i / 2) * 220;
                var _card_w = 280;
                var _card_h = 190;
                
                if (point_in_rectangle(mouse_x, mouse_y, _card_x, _card_y, _card_x + _card_w, _card_y + _card_h)) {
                    global.pou_sombrero = sombreros[_i].sprite;
                    audio_play_sound(snd_pocion, 1, false);
                    exit;
                }
            }
        }
        // Selección de Lentes (Pestaña 1)
        else if (closet_tab == 1) {
            for (var _j = 0; _j < array_length(lentes); _j++) {
                var _card_x = (_j mod 2 == 0) ? 60 : 380;
                var _card_y = 200 + floor(_j / 2) * 220;
                var _card_w = 280;
                var _card_h = 190;
                
                if (point_in_rectangle(mouse_x, mouse_y, _card_x, _card_y, _card_x + _card_w, _card_y + _card_h)) {
                    global.pou_lentes = lentes[_j].sprite;
                    audio_play_sound(snd_pocion, 1, false);
                    exit;
                }
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
