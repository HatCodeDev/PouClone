/// @description Dibujo de Pou, sombra, respiración, masticación y sacudido de cabeza
var _breath = dsin(bob_t) * 0.03;
var _react = dsin(squash_t * 720) * 0.12 * squash_t;
var _chew = (chew_timer > 0) ? dsin(chew_timer * 72) * 0.08 : 0;

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
