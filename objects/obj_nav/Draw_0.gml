/// @desc Dibuja flechas superiores de navegación, título del cuarto y HUD superior de estadísticas
// Si la nevera está abierta en la cocina o el armario en el dormitorio, ocultar el HUD para no encimarse
var _cocina = instance_find(obj_cocina, 0);
if (_cocina != noone && _cocina.fridge_open) {
    exit;
}
var _dorm = instance_find(obj_dormitorio, 0);
if (_dorm != noone && _dorm.closet_open) {
    exit;
}
var _sala = instance_find(obj_sala, 0);
if (_sala != noone && _sala.games_menu_open) {
    exit;
}

// Paleta de colores original de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);   // Marrón oscuro del contorno y textos de Pou
var _c_pou_border = make_color_rgb(75, 52, 30);   // Borde de pastillas UI
var _c_pou_pill   = make_color_rgb(255, 250, 238); // Fondo crema cálido
var _c_pou_shadow = make_color_rgb(215, 205, 185); // Sombra suave de pastillas

// ========================================================
// 1. FILA SUPERIOR (y: 18 a 60): Navegación con Flechas, Título y Monedas
// ========================================================

// 1.1 Pastilla del Título de Sala (Centrada en x = 360)
var _title_w = 210;
var _title_h = 42;
var _tx1 = room_width * 0.5 - _title_w * 0.5;
var _ty1 = 18;
var _tx2 = _tx1 + _title_w;
var _ty2 = _ty1 + _title_h;

// Sombra
draw_set_color(_c_pou_shadow);
draw_roundrect(_tx1, _ty1 + 3, _tx2, _ty2 + 3, false);
// Fondo crema
draw_set_color(_c_pou_pill);
draw_roundrect(_tx1, _ty1, _tx2, _ty2, false);
// Borde marrón
draw_set_color(_c_pou_border);
draw_roundrect(_tx1, _ty1, _tx2, _ty2, true);

// Texto del título (Dibuja "Baño" con tilde ASCII '~' sobre la 'n')
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_c_pou_text);
if (room_title == "Bano") {
    draw_text_transformed(room_width * 0.5, _ty1 + _title_h * 0.5, "Bano", 1.5, 1.5, 0);
    draw_text_transformed(room_width * 0.5 + 4, _ty1 + _title_h * 0.5 - 13, "~", 1.3, 1.3, 0);
} else {
    draw_text_transformed(room_width * 0.5, _ty1 + _title_h * 0.5, room_title, 1.5, 1.5, 0);
}

// 1.2 Flechas de Navegación de Cuartos (< y >) estilo Pou original
var _h_left = point_distance(mouse_x, mouse_y, arrow_l_x, arrow_y) <= arrow_radius + 4;
draw_set_color(_c_pou_shadow);
draw_circle(arrow_l_x, arrow_y + 2, arrow_radius, false);
draw_set_color(_h_left ? make_color_rgb(242, 232, 215) : _c_pou_pill);
draw_circle(arrow_l_x, arrow_y, arrow_radius, false);
draw_set_color(_c_pou_border);
draw_circle(arrow_l_x, arrow_y, arrow_radius, true);
draw_set_color(_c_pou_text);
draw_text_transformed(arrow_l_x - 1, arrow_y, "<", 2.0, 2.0, 0);

var _h_right = point_distance(mouse_x, mouse_y, arrow_r_x, arrow_y) <= arrow_radius + 4;
draw_set_color(_c_pou_shadow);
draw_circle(arrow_r_x, arrow_y + 2, arrow_radius, false);
draw_set_color(_h_right ? make_color_rgb(242, 232, 215) : _c_pou_pill);
draw_circle(arrow_r_x, arrow_y, arrow_radius, false);
draw_set_color(_c_pou_border);
draw_circle(arrow_r_x, arrow_y, arrow_radius, true);
draw_set_color(_c_pou_text);
draw_text_transformed(arrow_r_x + 1, arrow_y, ">", 2.0, 2.0, 0);

// 1.3 Pastilla de Monedas (Esquina superior derecha)
var _coin_w = 145;
var _coin_h = 42;
var _cx1 = room_width - _coin_w - 20;
var _cy1 = 18;
var _cx2 = _cx1 + _coin_w;
var _cy2 = _cy1 + _coin_h;

// Sombra
draw_set_color(_c_pou_shadow);
draw_roundrect(_cx1, _cy1 + 3, _cx2, _cy2 + 3, false);
// Fondo crema
draw_set_color(_c_pou_pill);
draw_roundrect(_cx1, _cy1, _cx2, _cy2, false);
// Borde marrón
draw_set_color(_c_pou_border);
draw_roundrect(_cx1, _cy1, _cx2, _cy2, true);

// Icono de moneda y valor numérico
draw_sprite_ext(spr_moneda, 0, _cx1 + 24, _cy1 + _coin_h * 0.5, 1.05, 1.05, 0, c_white, 1);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(_c_pou_text);
draw_text_transformed(_cx1 + 46, _cy1 + _coin_h * 0.5, string(global.pou_monedas), 1.4, 1.4, 0);

// ========================================================
// 2. FILA DE ESTADOS (y: 110 a 195): Hambre, Salud, Diversión, Energía
// Posicionada más abajo con espacio holgado para no verse encimada
// ========================================================
var _hud_items = [
    { icon: spr_estado_hambre,    val: global.pou_hambre,    x: 90 },
    { icon: spr_estado_salud,     val: global.pou_salud,     x: 270 },
    { icon: spr_estado_diversion, val: global.pou_diversion, x: 450 },
    { icon: spr_estado_energia,   val: global.pou_energia,   x: 630 }
];

var _bar_w = 84;
var _bar_h = 13;
var _icon_y = 120;
var _bar_y = 154;

for (var _k = 0; _k < 4; _k++) {
    var _item = _hud_items[_k];
    var _ix = _item.x;
    
    // Icono del estado centrado
    draw_sprite_ext(_item.icon, 0, _ix, _icon_y, 0.72, 0.72, 0, c_white, 1);
    
    // Fondo oscuro de la barra
    draw_set_color(make_color_rgb(45, 40, 35));
    draw_roundrect(_ix - _bar_w * 0.5, _bar_y, _ix + _bar_w * 0.5, _bar_y + _bar_h, false);
    
    // Relleno dinámico según porcentaje
    var _fill_w = (_bar_w - 2) * clamp(_item.val / 100, 0, 1);
    var _fill_col = make_color_rgb(95, 195, 75); // Verde
    if (_item.val < 30) {
        _fill_col = make_color_rgb(230, 65, 55); // Rojo
    } else if (_item.val < 60) {
        _fill_col = make_color_rgb(245, 185, 45); // Amarillo / Naranja
    }
    
    if (_fill_w > 0) {
        draw_set_color(_fill_col);
        draw_roundrect(_ix - _bar_w * 0.5 + 1, _bar_y + 1, _ix - _bar_w * 0.5 + 1 + _fill_w, _bar_y + _bar_h - 1, false);
    }
    
    // Borde fino de la barra
    draw_set_color(_c_pou_border);
    draw_roundrect(_ix - _bar_w * 0.5, _bar_y, _ix + _bar_w * 0.5, _bar_y + _bar_h, true);
    
    // Porcentaje en tipografía y color de Pou
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_c_pou_text);
    draw_text_transformed(_ix, _bar_y + _bar_h + 3, string(round(_item.val)) + "%", 1.05, 1.05, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
