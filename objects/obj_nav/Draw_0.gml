/// @desc Dibuja las puertas, título del cuarto y HUD superior de estadísticas al estilo Pou
var _hh = sprite_get_height(spr_puerta) * door_scale * 0.5;

// Paleta de colores original de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);   // Marrón oscuro del contorno y textos de Pou
var _c_pou_border = make_color_rgb(75, 52, 30);   // Borde de pastillas UI
var _c_pou_pill   = make_color_rgb(255, 250, 238); // Fondo crema cálido
var _c_pou_shadow = make_color_rgb(215, 205, 185); // Sombra suave de pastillas

// ========================================================
// 1. FILA SUPERIOR (y: 18 a 60): Título de sala y Monedas
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

// Texto del título
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_c_pou_text);
draw_text_transformed(room_width * 0.5, _ty1 + _title_h * 0.5, room_title, 1.6, 1.6, 0);

// 1.2 Pastilla de Monedas (Esquina superior derecha)
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
// 2. FILA DE ESTADOS (y: 82 a 160): Hambre, Salud, Diversión, Energía
// Separada verticalmente para que NUNCA choque con el título
// ========================================================
var _hud_items = [
    { icon: spr_estado_hambre,    val: global.pou_hambre,    x: 90 },
    { icon: spr_estado_salud,     val: global.pou_salud,     x: 270 },
    { icon: spr_estado_diversion, val: global.pou_diversion, x: 450 },
    { icon: spr_estado_energia,   val: global.pou_energia,   x: 630 }
];

var _bar_w = 84;
var _bar_h = 12;
var _bar_y = 126;

for (var _k = 0; _k < 4; _k++) {
    var _item = _hud_items[_k];
    var _ix = _item.x;
    
    // Icono del estado centrado
    draw_sprite_ext(_item.icon, 0, _ix, 92, 0.72, 0.72, 0, c_white, 1);
    
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

// ========================================================
// 3. PUERTAS DE NAVEGACIÓN INFERIORES
// Con pastilla contenedora en color Pou para máxima legibilidad
// ========================================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var _i = 0; _i < array_length(doors); _i++) {
    var _d = doors[_i];
    var _col = (hover == _i) ? c_white : c_ltgray;
    draw_sprite_ext(spr_puerta, 0, _d.x, _d.y, door_scale, door_scale, 0, _col, 1);
    
    // Pastilla con nombre del cuarto debajo de la puerta
    var _lbl_w = string_width(_d.label) * 1.3 + 28;
    var _lbl_h = 32;
    var _lx1 = _d.x - _lbl_w * 0.5;
    var _ly1 = _d.y + _hh + 8;
    var _lx2 = _lx1 + _lbl_w;
    var _ly2 = _ly1 + _lbl_h;
    
    // Sombra
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_lx1, _ly1 + 2, _lx2, _ly2 + 2, false);
    // Fondo crema
    draw_set_color(_c_pou_pill);
    draw_roundrect(_lx1, _ly1, _lx2, _ly2, false);
    // Borde marrón
    draw_set_color(_c_pou_border);
    draw_roundrect(_lx1, _ly1, _lx2, _ly2, true);
    
    // Texto de la puerta en color Pou
    draw_set_color(_c_pou_text);
    draw_text_transformed(_d.x, _ly1 + _lbl_h * 0.5, _d.label, 1.25, 1.25, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
