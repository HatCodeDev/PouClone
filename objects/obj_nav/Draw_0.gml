/// @desc Dibuja las puertas, título del cuarto y HUD superior de estadísticas
var _hh = sprite_get_height(spr_puerta) * door_scale * 0.5;

// 1. Título de la habitación
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_transformed(room_width * 0.5, 16, room_title, 2, 2, 0);

// 2. Contador de Monedas (Top-Right)
var _coin_x = 610;
var _coin_y = 26;
draw_sprite_ext(spr_moneda, 0, _coin_x - 16, _coin_y + 10, 1.1, 1.1, 0, c_white, 1);
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 230, 90));
draw_text_transformed(_coin_x + 6, _coin_y, string(global.pou_monedas), 1.5, 1.5, 0);

// 3. Barras de estado (HUD superior estilo Pou)
var _hud_items = [
    { icon: spr_estado_hambre,    val: global.pou_hambre,    label: "Hambre",    x: 105 },
    { icon: spr_estado_salud,     val: global.pou_salud,     label: "Salud",     x: 255 },
    { icon: spr_estado_diversion, val: global.pou_diversion, label: "Diversión", x: 405 },
    { icon: spr_estado_energia,   val: global.pou_energia,   label: "Energía",   x: 555 }
];

var _bar_w = 70;
var _bar_h = 10;
var _bar_y = 96;

for (var _k = 0; _k < 4; _k++) {
    var _item = _hud_items[_k];
    var _ix = _item.x;
    
    // Icono
    draw_sprite_ext(_item.icon, 0, _ix, 68, 0.65, 0.65, 0, c_white, 1);
    
    // Fondo de la barra
    draw_set_color(make_color_rgb(40, 45, 50));
    draw_roundrect(_ix - _bar_w * 0.5, _bar_y, _ix + _bar_w * 0.5, _bar_y + _bar_h, false);
    
    // Relleno según porcentaje
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
    
    // Porcentaje
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text_transformed(_ix, _bar_y + _bar_h + 3, string(round(_item.val)) + "%", 0.9, 0.9, 0);
}

// 4. Puertas de navegación inferiores
draw_set_halign(fa_center);
draw_set_valign(fa_top);
for (var _i = 0; _i < array_length(doors); _i++) {
    var _d = doors[_i];
    var _col = (hover == _i) ? c_white : c_ltgray;
    draw_sprite_ext(spr_puerta, 0, _d.x, _d.y, door_scale, door_scale, 0, _col, 1);
    draw_set_color(c_white);
    draw_text(_d.x, _d.y + _hh + 6, _d.label);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
