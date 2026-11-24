/// @description Dibujo de Pou, sombra, respiración, masticación y botones de emociones en la sala

// Si la nevera está abierta en la cocina, ocultar a Pou para que no se encime en el menú
var _cocina = instance_find(obj_cocina, 0);
if (_cocina != noone && _cocina.fridge_open) {
    exit;
}

var _breath = dsin(bob_t) * 0.03;

// Reacción suave al toque (un solo arco suave de compresión y rebote, sin vibración)
var _react = (squash_t > 0) ? dsin(squash_t * 180) * 0.12 * squash_t : 0;

// Masticación suave y natural al comer (un solo ciclo de deglución por mordisco)
var _chew = (chew_timer > 0) ? dsin((chew_timer / 20) * 180) * 0.07 : 0;

var _sx = base_scale * (1 - _breath + _react + _chew);
var _sy = base_scale * (1 + _breath - _react - _chew);

// Sombra en el suelo
draw_set_alpha(0.2);
draw_set_color(c_black);
draw_ellipse(x - 155, home_y - 12, x + 155, home_y + 14, false);
draw_set_alpha(1);
draw_set_color(c_white);

// Dibujo de Pou (con head_shake_x en caso de negación con la cabeza)
draw_sprite_ext(sprite_index, image_index, x + head_shake_x, y + jump_y, _sx, _sy, 0, c_white, 1);

// Dibujo de manchas de suciedad/lodo en el cuerpo de Pou
if (global.pou_suciedad > 0 && variable_global_exists("pou_dirt_spots")) {
    for (var _i = 0; _i < array_length(global.pou_dirt_spots); _i++) {
        var _s = global.pou_dirt_spots[_i];
        if (_s.dirty > 0) {
            var _spot_alpha = _s.dirty * clamp(global.pou_suciedad / 60, 0.25, 1);
            var _spot_x = (x + head_shake_x) + _s.ox * (_sx / base_scale);
            var _spot_y = (y + jump_y) + _s.oy * (_sy / base_scale);
            var _spot_r = _s.r * (_sx / base_scale) * (0.65 + 0.35 * _s.dirty);
            
            // Borde oscuro del lodo
            draw_set_alpha(_spot_alpha * 0.95);
            draw_set_color(make_color_rgb(70, 45, 25));
            draw_circle(_spot_x, _spot_y, _spot_r + 2, false);
            draw_circle(_spot_x - _spot_r * 0.4, _spot_y - _spot_r * 0.3, _spot_r * 0.65 + 1.5, false);
            draw_circle(_spot_x + _spot_r * 0.4, _spot_y + _spot_r * 0.25, _spot_r * 0.6 + 1.5, false);
            
            // Relleno de lodo
            draw_set_color(make_color_rgb(115, 78, 45));
            draw_circle(_spot_x, _spot_y, _spot_r, false);
            draw_circle(_spot_x - _spot_r * 0.4, _spot_y - _spot_r * 0.3, _spot_r * 0.65, false);
            draw_circle(_spot_x + _spot_r * 0.4, _spot_y + _spot_r * 0.25, _spot_r * 0.6, false);
            
            // Brillo de textura de lodo
            draw_set_color(make_color_rgb(148, 102, 60));
            draw_circle(_spot_x - _spot_r * 0.2, _spot_y - _spot_r * 0.2, _spot_r * 0.38, false);
        }
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Dibujar los botones de cambio de emoción ÚNICAMENTE en la sala (rm_sala)
if (room == rm_sala) {
    var _c_pou_text   = make_color_rgb(52, 36, 20);
    var _c_pou_border = make_color_rgb(75, 52, 30);
    var _c_pou_pill   = make_color_rgb(255, 250, 238);
    var _c_pou_shadow = make_color_rgb(215, 205, 185);
    var _c_active_bg  = make_color_rgb(85, 128, 75); // Verde activo estilo Pou

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    for (var _i = 0; _i < 6; _i++) {
        var _bx = 40 + (_i mod 3) * 220;
        var _by = 850 + floor(_i / 3) * 80;
        var _is_sel = (_i == emocion);

        // Sombra suave
        draw_set_color(_c_pou_shadow);
        draw_roundrect(_bx, _by + 3, _bx + 200, _by + 67, false);

        // Fondo del botón
        draw_set_color(_is_sel ? _c_active_bg : _c_pou_pill);
        draw_roundrect(_bx, _by, _bx + 200, _by + 64, false);

        // Borde marrón
        draw_set_color(_is_sel ? make_color_rgb(50, 80, 45) : _c_pou_border);
        draw_roundrect(_bx, _by, _bx + 200, _by + 64, true);

        // Texto del botón en estilo Pou
        draw_set_color(_is_sel ? c_white : _c_pou_text);
        draw_text_transformed(_bx + 100, _by + 32, emocion_nombres[_i], 1.35, 1.35, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
