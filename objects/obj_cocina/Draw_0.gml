/// @desc Dibujo de la mesa, comida, flechas, partículas y estado
var _current_food = foods[food_index];

// 1. Plato / Base de comida
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

// 2. Flechas de navegación (< y >)
var _h_left = point_distance(mouse_x, mouse_y, arrow_left_x, arrow_left_y) <= arrow_radius;
draw_set_color(_h_left ? make_color_rgb(180, 200, 220) : make_color_rgb(230, 235, 240));
draw_circle(arrow_left_x, arrow_left_y, arrow_radius, false);
draw_set_color(make_color_rgb(80, 90, 100));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(arrow_left_x - 2, arrow_left_y, "<", 2.2, 2.2, 0);

var _h_right = point_distance(mouse_x, mouse_y, arrow_right_x, arrow_right_y) <= arrow_radius;
draw_set_color(_h_right ? make_color_rgb(180, 200, 220) : make_color_rgb(230, 235, 240));
draw_circle(arrow_right_x, arrow_right_y, arrow_radius, false);
draw_set_color(make_color_rgb(80, 90, 100));
draw_text_transformed(arrow_right_x + 2, arrow_right_y, ">", 2.2, 2.2, 0);

// 3. Botón de la Nevera / Tienda rápida
var _h_nevera = point_distance(mouse_x, mouse_y, nevera_x, nevera_y) <= 45;
var _nev_scale = _h_nevera ? 1.05 : 0.95;
draw_sprite_ext(spr_nevera, 0, nevera_x, nevera_y - 10, _nev_scale, _nev_scale, 0, c_white, 1);
draw_set_color(c_white);
draw_set_valign(fa_top);
draw_text_transformed(nevera_x, nevera_y + 45, "Nevera", 1.2, 1.2, 0);

// 4. Dibujar la comida actual
if (_current_food.count > 0) {
    // Factor de escala según los mordiscos restantes (100%, 75%, 50%)
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
    var _by1 = plate_y + 50;
    var _bx2 = plate_x + btn_buy_w * 0.5;
    var _by2 = _by1 + btn_buy_h;
    
    var _h_buy = point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2);
    draw_set_color(_h_buy ? make_color_rgb(100, 190, 80) : make_color_rgb(76, 165, 58));
    draw_roundrect(_bx1, _by1, _bx2, _by2, false);
    
    draw_set_color(c_white);
    draw_set_valign(fa_middle);
    draw_text_transformed(plate_x, _by1 + btn_buy_h * 0.5, "+ Comprar (" + string(_current_food.price) + ")", 1.1, 1.1, 0);
}

// 5. Nombre y cantidad de la comida
draw_set_valign(fa_top);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text_transformed(plate_x, plate_y + 55, _current_food.name + " (x" + string(_current_food.count) + ")", 1.4, 1.4, 0);

// 6. Dibujar partículas de migas
for (var _i = 0; _i < array_length(crumbs); _i++) {
    var _c = crumbs[_i];
    draw_set_alpha(_c.alpha);
    draw_set_color(_c.col);
    draw_circle(_c.x, _c.y, _c.radius, false);
}
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
