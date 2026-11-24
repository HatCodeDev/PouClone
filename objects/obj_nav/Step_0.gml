/// @desc Navegación por flechas superiores (< y >) para cambiar de habitación

// Si la nevera está abierta en la cocina o el armario en el dormitorio, ignorar clics
var _cocina = instance_find(obj_cocina, 0);
if (_cocina != noone && _cocina.fridge_open) {
    exit;
}
var _dorm = instance_find(obj_dormitorio, 0);
if (_dorm != noone && _dorm.closet_open) {
    exit;
}

if (mouse_check_button_pressed(mb_left)) {
    // Flecha izquierda (<): Habitación anterior
    if (point_distance(mouse_x, mouse_y, arrow_l_x, arrow_y) <= arrow_radius + 6) {
        audio_play_sound(snd_click, 1, false);
        var _prev_idx = (current_room_index - 1 + array_length(rooms_list)) mod array_length(rooms_list);
        room_goto(rooms_list[_prev_idx].target);
    }
    // Flecha derecha (>): Siguiente habitación
    else if (point_distance(mouse_x, mouse_y, arrow_r_x, arrow_y) <= arrow_radius + 6) {
        audio_play_sound(snd_click, 1, false);
        var _next_idx = (current_room_index + 1) mod array_length(rooms_list);
        room_goto(rooms_list[_next_idx].target);
    }
}
