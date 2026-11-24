/// @description Respiración, expresiones, reacción táctil, física y selector en la sala
bob_t += 3;

// Manejo del sacudido de cabeza (cuando rechaza comida)
if (head_shake_timer > 0) {
    head_shake_timer--;
    head_shake_x = dsin(head_shake_timer * 36) * 16;
} else {
    head_shake_x = 0;
}

if (chew_timer > 0) chew_timer--;
if (pet_react_timer > 0) pet_react_timer--;

// --------------------------------------------------------
// DECAIMIENTO TEMPORAL Y BALANCE DE ESTADÍSTICAS COMO EN POU
// --------------------------------------------------------
decay_timer++;
if (decay_timer >= 180) { // Cada ~3 segundos
    decay_timer = 0;
    // Hambre y diversión decaen suavemente
    global.pou_hambre = max(0, global.pou_hambre - 0.25);
    global.pou_diversion = max(0, global.pou_diversion - 0.25);
    
    // Energía decae si la lámpara está encendida (está despierto)
    if (variable_global_exists("pou_lamp_on") && global.pou_lamp_on) {
        global.pou_energia = max(0, global.pou_energia - 0.2);
    }
    
    // La salud está ligada al nivel de suciedad
    if (variable_global_exists("pou_suciedad")) {
        var _salud_ideal = round(clamp(100 - global.pou_suciedad * 0.7, 15, 100));
        global.pou_salud = round(lerp(global.pou_salud, _salud_ideal, 0.08));
    }
}

// Teclas 1 a 6 para probar emociones manualmente
for (var _i = 0; _i < 6; _i++) {
    if (keyboard_check_pressed(ord("1") + _i)) {
        cambiar_emocion(_i);
        manual_override = true;
    }
}

// Botones de cambio de estado ÚNICAMENTE en la sala (rm_sala)
if (room == rm_sala && mouse_check_button_pressed(mb_left)) {
    for (var _i = 0; _i < 6; _i++) {
        var _bx = 40 + (_i mod 3) * 220;
        var _by = 850 + floor(_i / 3) * 80;
        if (point_in_rectangle(mouse_x, mouse_y, _bx, _by, _bx + 200, _by + 64)) {
            cambiar_emocion(_i);
            manual_override = true;
            audio_play_sound(snd_click, 1, false);
        }
    }
}

// --------------------------------------------------------
// SISTEMA DE EMOCIONES REACTIVAS DEL POU ORIGINAL
// --------------------------------------------------------
var _dorm_inst = instance_find(obj_dormitorio, 0);
var _bano_inst = instance_find(obj_bano, 0);
var _cocina_inst = instance_find(obj_cocina, 0);

// Las interacciones activas cancelan el override manual para dar respuesta inmediata
if (mouth_open || chew_timer > 0 || refusing || head_shake_timer > 0 || pet_react_timer > 0 ||
    (_bano_inst != noone && _bano_inst.is_dragging)) {
    manual_override = false;
}

if (!manual_override) {
    // 1. Acciones en tiempo real (comer, masticar, caricias, baño)
    if (mouth_open || chew_timer > 0 || pet_react_timer > 0) {
        cambiar_emocion(PouEmocion.Feliz);
    } else if (refusing || head_shake_timer > 0) {
        cambiar_emocion(PouEmocion.Serio);
    } else if (_bano_inst != noone && _bano_inst.is_dragging) {
        cambiar_emocion(PouEmocion.Feliz);
    } else if (room == rm_dormitorio && variable_global_exists("pou_lamp_on") && !global.pou_lamp_on) {
        cambiar_emocion(PouEmocion.Normal); // Durmiendo plácidamente
    }
    // 2. Estado de Salud Crítico (Enfermo con termómetro)
    else if (global.pou_salud < 35) {
        cambiar_emocion(PouEmocion.Enfermo);
    }
    // 3. Estado de Hambre Crítico (Boca abierta de hambre)
    else if (global.pou_hambre < 35) {
        cambiar_emocion(PouEmocion.Hambriento);
    }
    // 4. Estado de Malestar o Tristeza (Sucio, agotado o aburrido)
    else if (global.pou_suciedad >= 60 || global.pou_energia < 25 || global.pou_diversion < 25) {
        cambiar_emocion(PouEmocion.Triste);
    }
    // 5. Estado Feliz (Bien alimentado, limpio y saludable)
    else if (global.pou_hambre >= 70 && global.pou_salud >= 70 && global.pou_suciedad < 30) {
        cambiar_emocion(PouEmocion.Feliz);
    }
    // 6. Estado Normal por defecto
    else {
        cambiar_emocion(PouEmocion.Normal);
    }
}

// Toque y caricia a Pou (solo si no se está arrastrando comida, bañando ni con la nevera o armario abierto)
var _bloquear_toque = false;
if (_cocina_inst != noone && (_cocina_inst.is_dragging || _cocina_inst.fridge_open)) {
    _bloquear_toque = true;
}
if (_bano_inst != noone && _bano_inst.is_dragging) {
    _bloquear_toque = true;
}
if (_dorm_inst != noone && _dorm_inst.closet_open) {
    _bloquear_toque = true;
}

if (!_bloquear_toque && mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, x - 180 * base_scale, y + jump_y - 302 * base_scale, x + 180 * base_scale, y + jump_y)) {
        var _snd = reaction_sounds[irandom(array_length(reaction_sounds) - 1)];
        audio_play_sound(_snd, 1, false);
        squash_t = 1;
        jump_vy = -9;
        
        // Al acariciar y hacerle cosquillas a Pou, sube la barra de DIVERSIÓN
        global.pou_diversion = min(100, global.pou_diversion + 5);
        pet_react_timer = 45;
        manual_override = false;
    }
}

// Física de salto y rebote
if (jump_vy != 0 || jump_y < 0) {
    jump_y += jump_vy;
    jump_vy += 1;
    if (jump_y >= 0) { jump_y = 0; jump_vy = 0; }
}
squash_t = max(0, squash_t - 0.04);
