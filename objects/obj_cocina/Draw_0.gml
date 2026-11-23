/// @desc Dibujo de la mesa, comida, flechas, partículas y menú Nevera con paleta Pou
var _current_food = foods[food_index];

// Paleta de colores original de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);   // Marrón oscuro
var _c_pou_border = make_color_rgb(75, 52, 30);   // Borde marrón
var _c_pou_pill   = make_color_rgb(255, 250, 238); // Fondo crema cálido
var _c_pou_shadow = make_color_rgb(215, 205, 185); // Sombra suave

// ========================================================
// 1. ELEMENTOS DE LA COCINA (Plato, Flechas, Comida)
// ========================================================

// 1.1 Plato / Base de comida
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_ellipse(plate_x - 110, plate_y + 28, plate_x + 110, plate_y + 55, false);

// Borde del plato de porcelana
draw_set_alpha(0.9);
draw_set_color(make_color_rgb(220, 225, 230));
draw_ellipse(plate_x - 100, plate_y + 15, plate_x + 100, plate_y + 48, false);
draw_set_color(make_color_rgb(248, 250, 252));
draw_ellipse(plate_x - 90, plate_y + 18, plate_x + 90, plate_y + 44, false);
draw_set_alpha(1);

// 1.2 Flechas de navegación (< y >) estilo Pou
var _h_left = point_distance(mouse_x, mouse_y, arrow_left_x, arrow_left_y) <= arrow_radius;
var _col_btn_l = _h_left ? make_color_rgb(242, 232, 215) : _c_pou_pill;
draw_set_color(_c_pou_shadow);
draw_circle(arrow_left_x, arrow_left_y + 2, arrow_radius, false);
draw_set_color(_col_btn_l);
draw_circle(arrow_left_x, arrow_left_y, arrow_radius, false);
draw_set_color(_c_pou_border);
draw_circle(arrow_left_x, arrow_left_y, arrow_radius, true);
draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(arrow_left_x - 1, arrow_left_y, "<", 2.2, 2.2, 0);

var _h_right = point_distance(mouse_x, mouse_y, arrow_right_x, arrow_right_y) <= arrow_radius;
var _col_btn_r = _h_right ? make_color_rgb(242, 232, 215) : _c_pou_pill;
draw_set_color(_c_pou_shadow);
draw_circle(arrow_right_x, arrow_right_y + 2, arrow_radius, false);
draw_set_color(_col_btn_r);
draw_circle(arrow_right_x, arrow_right_y, arrow_radius, false);
draw_set_color(_c_pou_border);
draw_circle(arrow_right_x, arrow_right_y, arrow_radius, true);
draw_set_color(_c_pou_text);
draw_text_transformed(arrow_right_x + 1, arrow_right_y, ">", 2.2, 2.2, 0);

// 1.3 Botón de la Nevera
var _h_nevera = point_distance(mouse_x, mouse_y, nevera_x, nevera_y) <= 45;
var _nev_scale = _h_nevera ? 1.08 : 0.98;
draw_sprite_ext(spr_nevera, 0, nevera_x, nevera_y - 12, _nev_scale, _nev_scale, 0, c_white, 1);

// Pastilla de etiqueta "Nevera"
var _nev_lbl_w = 80;
var _nev_lbl_h = 26;
var _nx1 = nevera_x - _nev_lbl_w * 0.5;
var _ny1 = nevera_y + 40;
draw_set_color(_c_pou_shadow);
draw_roundrect(_nx1, _ny1 + 2, _nx1 + _nev_lbl_w, _ny1 + _nev_lbl_h + 2, false);
draw_set_color(_h_nevera ? make_color_rgb(242, 232, 215) : _c_pou_pill);
draw_roundrect(_nx1, _ny1, _nx1 + _nev_lbl_w, _ny1 + _nev_lbl_h, false);
draw_set_color(_c_pou_border);
draw_roundrect(_nx1, _ny1, _nx1 + _nev_lbl_w, _ny1 + _nev_lbl_h, true);
draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(nevera_x, _ny1 + _nev_lbl_h * 0.5, "Nevera", 1.1, 1.1, 0);

// 1.4 Dibujar la comida actual
if (_current_food.count > 0) {
    var _bite_scale = (bites_remaining / bites_total);
    var _draw_scale = food_scale * (0.45 + 0.55 * _bite_scale) * food_punch;
    
    // Sombra proyectada si está en el aire
    if (is_dragging) {
        draw_set_alpha(0.2);
        draw_set_color(c_black);
        draw_ellipse(food_x - 35, food_y + 45, food_x + 35, food_y + 60, false);
        draw_set_alpha(1);
    }
    
    draw_sprite_ext(_current_food.sprite, 0, food_x, food_y, _draw_scale, _draw_scale, food_angle, c_white, 1);
} else {
    // Comida agotada: dibujo translúcido y botón comprar
    draw_sprite_ext(_current_food.sprite, 0, food_x, food_y, food_scale, food_scale, 0, c_white, 0.35);
    
    var _bx1 = plate_x - btn_buy_w * 0.5;
    var _by1 = plate_y + 55;
    var _bx2 = plate_x + btn_buy_w * 0.5;
    var _by2 = _by1 + btn_buy_h;
    
    var _h_buy = point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2);
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_bx1, _by1 + 2, _bx2, _by2 + 2, false);
    draw_set_color(_h_buy ? make_color_rgb(105, 195, 85) : make_color_rgb(85, 175, 65));
    draw_roundrect(_bx1, _by1, _bx2, _by2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_bx1, _by1, _bx2, _by2, true);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(plate_x, _by1 + btn_buy_h * 0.5, "+ Comprar (" + string(_current_food.price) + ")", 1.15, 1.15, 0);
}

// 1.5 Pastilla con Nombre y Cantidad de la comida
if (_current_food.count > 0) {
    var _food_str = _current_food.name + " (x" + string(_current_food.count) + ")";
    var _fn_w = string_width(_food_str) * 1.3 + 30;
    var _fn_h = 34;
    var _fx1 = plate_x - _fn_w * 0.5;
    var _fy1 = plate_y + 58;
    var _fx2 = _fx1 + _fn_w;
    var _fy2 = _fy1 + _fn_h;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_fx1, _fy1 + 2, _fx2, _fy2 + 2, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_fx1, _fy1, _fx2, _fy2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_fx1, _fy1, _fx2, _fy2, true);
    
    draw_set_color(_c_pou_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(plate_x, _fy1 + _fn_h * 0.5, _food_str, 1.3, 1.3, 0);
}

// 1.6 Dibujar partículas de migas
for (var _i = 0; _i < array_length(crumbs); _i++) {
    var _c = crumbs[_i];
    draw_set_alpha(_c.alpha);
    draw_set_color(_c.col);
    draw_circle(_c.x, _c.y, _c.radius, false);
}
draw_set_alpha(1);

// ========================================================
// 2. INTERFAZ MODAL DE LA NEVERA (Alimentos disponibles y tienda)
// ========================================================
if (fridge_open) {
    // 2.1 Fondo oscurecido
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // 2.2 Ventana de la Nevera
    var _mx1 = 30;
    var _my1 = 120;
    var _mx2 = 690;
    var _my2 = 1130;
    
    // Sombra del modal
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_mx1 + 4, _my1 + 6, _mx2 + 4, _my2 + 6, false);
    
    // Cuerpo del modal
    draw_set_color(make_color_rgb(255, 252, 244));
    draw_roundrect(_mx1, _my1, _mx2, _my2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_mx1, _my1, _mx2, _my2, true);
    
    // 2.3 Cabecera de la Nevera
    draw_sprite_ext(spr_nevera, 0, 68, 160, 0.85, 0.85, 0, c_white, 1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(_c_pou_text);
    draw_text_transformed(102, 160, "Nevera de Pou", 1.55, 1.55, 0);
    
    // Contador de Monedas en cabecera
    var _cbox_w = 145;
    var _cbox_h = 38;
    var _cbx1 = 475;
    var _cby1 = 141;
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_cbx1, _cby1 + 2, _cbx1 + _cbox_w, _cby1 + _cbox_h + 2, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_cbx1, _cby1, _cbx1 + _cbox_w, _cby1 + _cbox_h, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_cbx1, _cby1, _cbx1 + _cbox_w, _cby1 + _cbox_h, true);
    draw_sprite_ext(spr_moneda, 0, _cbx1 + 20, _cby1 + _cbox_h * 0.5, 0.95, 0.95, 0, c_white, 1);
    draw_set_color(_c_pou_text);
    draw_text_transformed(_cbx1 + 40, _cby1 + _cbox_h * 0.5, string(global.pou_monedas), 1.3, 1.3, 0);
    
    // Botón Cerrar "X"
    var _h_close = point_distance(mouse_x, mouse_y, 645, 160) <= 24;
    draw_set_color(_h_close ? make_color_rgb(255, 210, 210) : _c_pou_pill);
    draw_circle(645, 160, 22, false);
    draw_set_color(_c_pou_border);
    draw_circle(645, 160, 22, true);
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(180, 40, 40));
    draw_text_transformed(645, 160, "X", 1.4, 1.4, 0);
    
    // 2.4 Cuadrícula de Alimentos (10 alimentos: 2 columnas x 5 filas)
    for (var _i = 0; _i < array_length(foods); _i++) {
        var _col = _i mod 2;
        var _row = floor(_i / 2);
        var _card_x = (_col == 0) ? 45 : 375;
        var _card_y = 205 + _row * 168;
        var _card_w = 300;
        var _card_h = 155;
        var _f_item = foods[_i];
        var _is_selected = (_i == food_index);
        
        // Sombra de tarjeta
        draw_set_color(_c_pou_shadow);
        draw_roundrect(_card_x + 2, _card_y + 3, _card_x + _card_w + 2, _card_y + _card_h + 3, false);
        
        // Fondo de tarjeta
        draw_set_color(_is_selected ? make_color_rgb(255, 252, 230) : make_color_rgb(255, 255, 255));
        draw_roundrect(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, false);
        
        // Borde de tarjeta
        draw_set_color(_is_selected ? make_color_rgb(85, 150, 65) : _c_pou_border);
        draw_roundrect(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, true);
        
        // Sprite del alimento
        draw_sprite_ext(_f_item.sprite, 0, _card_x + 52, _card_y + 55, 0.72, 0.72, 0, c_white, 1);
        
        // Etiqueta de Nutrición
        var _nutr_w = 84;
        var _nutr_h = 24;
        var _nutr_x1 = _card_x + 10;
        var _nutr_y1 = _card_y + 108;
        draw_set_color(make_color_rgb(235, 245, 230));
        draw_roundrect(_nutr_x1, _nutr_y1, _nutr_x1 + _nutr_w, _nutr_y1 + _nutr_h, false);
        draw_set_color(make_color_rgb(60, 130, 50));
        draw_roundrect(_nutr_x1, _nutr_y1, _nutr_x1 + _nutr_w, _nutr_y1 + _nutr_h, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(_nutr_x1 + _nutr_w * 0.5, _nutr_y1 + _nutr_h * 0.5, "+" + string(_f_item.nutrition) + "%", 0.95, 0.95, 0);
        
        // Nombre del alimento
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(_c_pou_text);
        draw_text_transformed(_card_x + 105, _card_y + 16, _f_item.name, 1.18, 1.18, 0);
        
        // Indicador de Stock ("Tienes: X")
        var _has_stock = (_f_item.count > 0);
        var _stk_w = 180;
        var _stk_h = 24;
        var _stk_x1 = _card_x + 105;
        var _stk_y1 = _card_y + 48;
        draw_set_color(_has_stock ? make_color_rgb(225, 248, 225) : make_color_rgb(255, 235, 235));
        draw_roundrect(_stk_x1, _stk_y1, _stk_x1 + _stk_w, _stk_y1 + _stk_h, false);
        draw_set_color(_has_stock ? make_color_rgb(45, 135, 45) : make_color_rgb(180, 50, 50));
        draw_roundrect(_stk_x1, _stk_y1, _stk_x1 + _stk_w, _stk_y1 + _stk_h, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _stk_text = _has_stock ? ("Tienes: " + string(_f_item.count)) : "Agotado (0)";
        draw_text_transformed(_stk_x1 + _stk_w * 0.5, _stk_y1 + _stk_h * 0.5, _stk_text, 0.95, 0.95, 0);
        
        // Botón 1: "Servir"
        var _btn_s_x1 = _card_x + 105;
        var _btn_s_y1 = _card_y + 104;
        var _btn_s_x2 = _btn_s_x1 + 84;
        var _btn_s_y2 = _btn_s_y1 + 34;
        var _h_servir = point_in_rectangle(mouse_x, mouse_y, _btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2);
        
        if (_is_selected) {
            draw_set_color(make_color_rgb(245, 238, 210));
            draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, false);
            draw_set_color(make_color_rgb(180, 140, 50));
            draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, true);
            draw_text_transformed(_btn_s_x1 + 42, _btn_s_y1 + 17, "En plato", 0.95, 0.95, 0);
        } else if (_has_stock) {
            draw_set_color(_h_servir ? make_color_rgb(105, 195, 95) : make_color_rgb(80, 170, 70));
            draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, false);
            draw_set_color(_c_pou_border);
            draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, true);
            draw_set_color(c_white);
            draw_text_transformed(_btn_s_x1 + 42, _btn_s_y1 + 17, "Servir", 1.0, 1.0, 0);
        } else {
            draw_set_color(make_color_rgb(220, 220, 220));
            draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, false);
            draw_set_color(make_color_rgb(160, 160, 160));
            draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, true);
            draw_text_transformed(_btn_s_x1 + 42, _btn_s_y1 + 17, "Vacío", 0.95, 0.95, 0);
        }
        
        // Botón 2: "+ Comprar"
        var _btn_b_x1 = _card_x + 196;
        var _btn_b_y1 = _card_y + 104;
        var _btn_b_x2 = _btn_b_x1 + 94;
        var _btn_b_y2 = _btn_b_y1 + 34;
        var _h_comprar = point_in_rectangle(mouse_x, mouse_y, _btn_b_x1, _btn_b_y1, _btn_b_x2, _btn_b_y2);
        
        draw_set_color(_h_comprar ? make_color_rgb(255, 190, 60) : make_color_rgb(240, 165, 45));
        draw_roundrect(_btn_b_x1, _btn_b_y1, _btn_b_x2, _btn_b_y2, false);
        draw_set_color(_c_pou_border);
        draw_roundrect(_btn_b_x1, _btn_b_y1, _btn_b_x2, _btn_b_y2, true);
        draw_set_color(c_white);
        draw_text_transformed(_btn_b_x1 + 47, _btn_b_y1 + 17, "+1 ($" + string(_f_item.price) + ")", 0.95, 0.95, 0);
    }
    
    // 2.5 Botón inferior: "Volver a la Cocina"
    var _close_w = 280;
    var _close_h = 44;
    var _cl_x1 = 360 - _close_w * 0.5;
    var _cl_y1 = 1060;
    var _cl_x2 = _cl_x1 + _close_w;
    var _cl_y2 = _cl_y1 + _close_h;
    var _h_back = point_in_rectangle(mouse_x, mouse_y, _cl_x1, _cl_y1, _cl_x2, _cl_y2);
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_cl_x1, _cl_y1 + 2, _cl_x2, _cl_y2 + 2, false);
    draw_set_color(_h_back ? make_color_rgb(242, 232, 215) : _c_pou_pill);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, true);
    
    draw_set_color(_c_pou_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(360, _cl_y1 + _close_h * 0.5, "<- Volver a la Cocina", 1.25, 1.25, 0);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
