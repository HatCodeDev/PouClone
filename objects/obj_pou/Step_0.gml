/// @description Respiración, expresiones, reacción táctil y física
bob_t += 3;

// Manejo del sacudido de cabeza (cuando rechaza comida)
if (head_shake_timer > 0) {
    head_shake_timer--;
    head_shake_x = dsin(head_shake_timer * 36) * 16;
} else {
    head_shake_x = 0;
}

if (chew_timer > 0) chew_timer--;

// Teclas 1 a 6 para forzar emociones en desarrollo/testing
var _tecla_pulsada = false;
for (var _i = 0; _i < 6; _i++) {
    if (keyboard_check_pressed(ord("1") + _i)) {
        cambiar_emocion(_i);
        _tecla_pulsada = true;
    }
}

// Si no se forzó con teclado, actualizar la emoción automáticamente según estado
if (!_tecla_pulsada) {
    if (mouth_open || chew_timer > 0) {
        cambiar_emocion(PouEmocion.Feliz);
    } else if (refusing || head_shake_timer > 0) {
        cambiar_emocion(PouEmocion.Serio);
    } else {
        if (global.pou_hambre < 35) {
            cambiar_emocion(PouEmocion.Hambriento);
        } else if (global.pou_hambre >= 75) {
            cambiar_emocion(PouEmocion.Feliz);
        } else {
            cambiar_emocion(PouEmocion.Normal);
        }
    }
}

// Toque y caricia a Pou (solo si no se está arrastrando comida en la cocina)
var _is_food_dragging = false;
var _cocina = instance_find(obj_cocina, 0);
if (_cocina != noone && _cocina.is_dragging) {
    _is_food_dragging = true;
}

if (!_is_food_dragging && mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, x - 180 * base_scale, y + jump_y - 302 * base_scale, x + 180 * base_scale, y + jump_y)) {
        var _snd = reaction_sounds[irandom(array_length(reaction_sounds) - 1)];
        audio_play_sound(_snd, 1, false);
        squash_t = 1;
        jump_vy = -9;
    }
}

// Física de salto y rebote
if (jump_vy != 0 || jump_y < 0) {
    jump_y += jump_vy;
    jump_vy += 1;
    if (jump_y >= 0) { jump_y = 0; jump_vy = 0; }
}
squash_t = max(0, squash_t - 0.04);
