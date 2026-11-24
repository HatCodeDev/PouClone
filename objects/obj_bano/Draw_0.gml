/// @desc Dibujo de herramientas del baño, jabonera, soporte, agua, espuma y efectos
var _pou = instance_find(obj_pou, 0);

// Paleta de colores original de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);
var _c_pou_border = make_color_rgb(75, 52, 30);
var _c_pou_pill   = make_color_rgb(255, 250, 238);
var _c_pou_shadow = make_color_rgb(215, 205, 185);

// ========================================================
// 1. BASES Y PLATILLOS DE LAS HERRAMIENTAS EN EL SUELO
// ========================================================

// 1.1 Jabonera (Izquierda)
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_ellipse(jabon_home_x - 65, jabon_home_y + 35, jabon_home_x + 65, jabon_home_y + 55, false);

draw_set_alpha(0.9);
draw_set_color(make_color_rgb(215, 230, 245));
draw_ellipse(jabon_home_x - 58, jabon_home_y + 20, jabon_home_x + 58, jabon_home_y + 48, false);
draw_set_color(make_color_rgb(245, 250, 255));
draw_ellipse(jabon_home_x - 50, jabon_home_y + 22, jabon_home_x + 50, jabon_home_y + 44, false);
draw_set_alpha(1);

// Etiqueta "Jabon"
var _lw = 76;
var _lh = 26;
draw_set_color(_c_pou_shadow);
draw_roundrect(jabon_home_x - _lw * 0.5, jabon_home_y + 58, jabon_home_x + _lw * 0.5, jabon_home_y + 58 + _lh, false);
draw_set_color(_c_pou_pill);
draw_roundrect(jabon_home_x - _lw * 0.5, jabon_home_y + 56, jabon_home_x + _lw * 0.5, jabon_home_y + 56 + _lh, false);
draw_set_color(_c_pou_border);
draw_roundrect(jabon_home_x - _lw * 0.5, jabon_home_y + 56, jabon_home_x + _lw * 0.5, jabon_home_y + 56 + _lh, true);
draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(jabon_home_x, jabon_home_y + 56 + _lh * 0.5, "Jabon", 1.1, 1.1, 0);

// 1.2 Soporte de Ducha (Derecha)
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_ellipse(ducha_home_x - 55, ducha_home_y + 35, ducha_home_x + 55, ducha_home_y + 55, false);

draw_set_alpha(0.9);
draw_set_color(make_color_rgb(225, 228, 235));
draw_ellipse(ducha_home_x - 50, ducha_home_y + 20, ducha_home_x + 50, ducha_home_y + 48, false);
draw_set_color(make_color_rgb(248, 250, 255));
draw_ellipse(ducha_home_x - 42, ducha_home_y + 22, ducha_home_x + 42, ducha_home_y + 44, false);
draw_set_alpha(1);

// Etiqueta "Ducha"
draw_set_color(_c_pou_shadow);
draw_roundrect(ducha_home_x - _lw * 0.5, ducha_home_y + 58, ducha_home_x + _lw * 0.5, ducha_home_y + 58 + _lh, false);
draw_set_color(_c_pou_pill);
draw_roundrect(ducha_home_x - _lw * 0.5, ducha_home_y + 56, ducha_home_x + _lw * 0.5, ducha_home_y + 56 + _lh, false);
draw_set_color(_c_pou_border);
draw_roundrect(ducha_home_x - _lw * 0.5, ducha_home_y + 56, ducha_home_x + _lw * 0.5, ducha_home_y + 56 + _lh, true);
draw_set_color(_c_pou_text);
draw_text_transformed(ducha_home_x, ducha_home_y + 56 + _lh * 0.5, "Ducha", 1.1, 1.1, 0);

// ========================================================
// 2. BOTÓN "¡ENSUCIAR!" (Lado derecho inferior)
// ========================================================
var _bx1 = 480;
var _by1 = 1115;
var _bx2 = 660;
var _by2 = 1165;
var _h_ens = point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2);

draw_set_color(_c_pou_shadow);
draw_roundrect(_bx1, _by1 + 3, _bx2, _by2 + 3, false);
draw_set_color(_h_ens ? make_color_rgb(245, 230, 215) : _c_pou_pill);
draw_roundrect(_bx1, _by1, _bx2, _by2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_bx1, _by1, _bx2, _by2, true);
draw_set_color(make_color_rgb(115, 78, 45));
draw_text_transformed((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "+ Ensuciar", 1.25, 1.25, 0);

// ========================================================
// 3. BURBUJAS DE ESPUMA ADHERIDAS A POU
// ========================================================
if (_pou != noone) {
    for (var _i = 0; _i < array_length(bubbles); _i++) {
        var _b = bubbles[_i];
        var _bx = _pou.x + _b.ox;
        var _by = _pou.y + _b.oy;
        draw_sprite_ext(spr_burbujas, 0, _bx, _by, _b.scale, _b.scale, _b.rot, c_white, _b.alpha);
        
        // Destello de brillo de burbuja
        draw_set_alpha(_b.alpha * 0.7);
        draw_set_color(make_color_rgb(215, 245, 255));
        draw_circle(_bx - 10 * _b.scale, _by - 10 * _b.scale, 4 * _b.scale, false);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// ========================================================
// 4. GOTAS Y CHORROS DE AGUA
// ========================================================
for (var _d = 0; _d < array_length(water_drops); _d++) {
    var _drop = water_drops[_d];
    draw_set_alpha(_drop.alpha);
    // Chorro azul cielo
    draw_set_color(make_color_rgb(155, 215, 255));
    draw_line_width(_drop.x, _drop.y, _drop.x + _drop.vx * 1.5, _drop.y - _drop.len, 3.8);
    // Núcleo blanco brillante
    draw_set_color(c_white);
    draw_circle(_drop.x, _drop.y, 2, false);
}
draw_set_alpha(1);
draw_set_color(c_white);

// ========================================================
// 5. SALPICADURAS AL IMPACTAR EL AGUA
// ========================================================
for (var _s = 0; _s < array_length(splashes); _s++) {
    var _sp = splashes[_s];
    draw_set_alpha(_sp.alpha);
    draw_set_color(_sp.col);
    draw_circle(_sp.x, _sp.y, _sp.r, false);
}
draw_set_alpha(1);
draw_set_color(c_white);

// ========================================================
// 6. HERRAMIENTAS INTERACTIVAS (Jabón y Ducha)
// ========================================================

// 6.1 Ducha / Regadera
if (ducha_dragging) {
    draw_set_alpha(0.2);
    draw_set_color(c_black);
    draw_ellipse(ducha_x - 30, ducha_y + 40, ducha_x + 30, ducha_y + 55, false);
    draw_set_alpha(1);
}
draw_sprite_ext(spr_ducha, 0, ducha_x, ducha_y, ducha_scale, ducha_scale, ducha_angle, c_white, 1);

// 6.2 Jabón
if (jabon_dragging) {
    draw_set_alpha(0.2);
    draw_set_color(c_black);
    draw_ellipse(jabon_x - 35, jabon_y + 40, jabon_x + 35, jabon_y + 55, false);
    draw_set_alpha(1);
}
draw_sprite_ext(spr_jabon, 0, jabon_x, jabon_y, jabon_scale, jabon_scale, jabon_angle, c_white, 1);

// ========================================================
// 7. DESTELLOS Y ESTRELLAS DE LIMPIEZA ✨
// ========================================================
for (var _p = 0; _p < array_length(sparkles); _p++) {
    var _star = sparkles[_p];
    draw_set_alpha(_star.alpha);
    draw_set_color(make_color_rgb(255, 235, 120));
    
    // Estrella de 4 puntas
    var _r = 12 * _star.scale;
    var _ang = _star.rot;
    var _c1 = dcos(_ang) * _r; var _s1 = dsin(_ang) * _r;
    var _c2 = dcos(_ang + 90) * _r; var _s2 = dsin(_ang + 90) * _r;
    
    draw_line_width(_star.x - _c1, _star.y + _s1, _star.x + _c1, _star.y - _s1, 2.5);
    draw_line_width(_star.x - _c2, _star.y + _s2, _star.x + _c2, _star.y - _s2, 2.5);
    draw_set_color(c_white);
    draw_circle(_star.x, _star.y, 3 * _star.scale, false);
}
draw_set_alpha(1);
draw_set_color(c_white);

// ========================================================
// 8. BANNER DE CELEBRACIÓN (Cuando queda limpio)
// ========================================================
if (celebration_timer > 0) {
    var _alpha = clamp(celebration_timer / 30, 0, 1);
    var _cw = 380;
    var _ch = 56;
    var _cx1 = 360 - _cw * 0.5;
    var _cy1 = 220;
    var _cx2 = _cx1 + _cw;
    var _cy2 = _cy1 + _ch;
    
    draw_set_alpha(_alpha);
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_cx1, _cy1 + 3, _cx2, _cy2 + 3, false);
    draw_set_color(make_color_rgb(255, 252, 230));
    draw_roundrect(_cx1, _cy1, _cx2, _cy2, false);
    draw_set_color(make_color_rgb(85, 160, 65));
    draw_roundrect(_cx1, _cy1, _cx2, _cy2, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(60, 130, 45));
    draw_text_transformed(360, _cy1 + _ch * 0.5, celebration_text, 1.4, 1.4, 0);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
