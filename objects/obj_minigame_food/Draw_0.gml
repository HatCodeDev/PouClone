/// @desc Renderizado visual completo del Minijuego "Atrapar Comida" - Versión Pulida

// Paleta de colores oficial de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);
var _c_pou_border = make_color_rgb(75, 52, 30);
var _c_pou_pill   = make_color_rgb(255, 250, 238);
var _c_pou_shadow = make_color_rgb(215, 205, 185);
var _c_pou_green  = make_color_rgb(85, 165, 60);

// ========================================================
// 1. CIELO Y FONDO AMBIENTAL
// ========================================================
var _sky_top = make_color_rgb(175, 222, 248);
var _sky_bot = make_color_rgb(230, 246, 255);
draw_rectangle_color(0, 0, room_width, 1140, _sky_top, _sky_top, _sky_bot, _sky_bot, false);

// Nubes de fondo esponjosas
draw_set_color(c_white);
draw_set_alpha(0.85);
for (var _c = 0; _c < array_length(clouds); _c++) {
    var _cd = clouds[_c];
    draw_ellipse(_cd.x, _cd.y, _cd.x + _cd.w, _cd.y + _cd.h, false);
    draw_ellipse(_cd.x + _cd.w * 0.2, _cd.y - _cd.h * 0.35, _cd.x + _cd.w * 0.7, _cd.y + _cd.h * 0.6, false);
}
draw_set_alpha(1.0);

// Suelo verde de césped
var _grass_top = make_color_rgb(125, 195, 65);
var _grass_bot = make_color_rgb(95, 160, 45);
draw_rectangle_color(0, 1140, room_width, room_height, _grass_top, _grass_top, _grass_bot, _grass_bot, false);

// Línea de borde del césped
draw_set_color(make_color_rgb(75, 135, 35));
draw_line_width(0, 1140, room_width, 1140, 4);

// Pequeños mechones decorativos de hierba
draw_set_color(make_color_rgb(145, 215, 75));
for (var _gx = 30; _gx < room_width; _gx += 65) {
    draw_triangle(_gx - 6, 1140, _gx, 1128, _gx + 6, 1140, false);
}

// ========================================================
// 2. SOMBRAS DE ITEMS Y OBJETOS CAYENDO
// ========================================================
for (var _i = 0; _i < array_length(falling_items); _i++) {
    var _it = falling_items[_i];
    var _ground_dist = max(10, 1140 - _it.y);
    var _shadow_alpha = clamp(1.0 - (_ground_dist / 900), 0.1, 0.45);
    var _shadow_w = clamp(25 * (1.0 - (_ground_dist / 1140)), 8, 30);
    
    draw_set_alpha(_shadow_alpha);
    draw_set_color(c_black);
    draw_ellipse(_it.x - _shadow_w, 1142 - 4, _it.x + _shadow_w, 1142 + 4, false);
    draw_set_alpha(1.0);
    
    // Sprite del item rotado
    draw_sprite_ext(_it.sprite, 0, _it.x + shake_x, _it.y + shake_y, _it.scale, _it.scale, _it.rot, c_white, 1);
}

// ========================================================
// 3. POU EN EL JUEGO (Con soporte para parpadeo al ser golpeado)
// ========================================================
// Sombra de Pou en el césped
draw_set_alpha(0.32);
draw_set_color(c_black);
draw_ellipse(pou_x - 45, 1134, pou_x + 45, 1148, false);
draw_set_alpha(1.0);

// Parpadeo de invulnerabilidad tras daño
var _pou_alpha = (invulnerable_timer > 0 && (invulnerable_timer mod 6 < 3)) ? 0.45 : 1.0;
draw_set_alpha(_pou_alpha);

// Dibujo del sprite de Pou
draw_sprite_ext(spr_pou_emociones, pou_emotion, pou_x + head_shake_x + shake_x, pou_y + shake_y, pou_scale_x, pou_scale_y, 0, c_white, _pou_alpha);

// 1. Ropa / Pajarita
if (variable_global_exists("pou_ropa") && global.pou_ropa != -1) {
    var _ropa_y = pou_y + shake_y - 95 * pou_scale_y;
    draw_sprite_ext(global.pou_ropa, 0, pou_x + head_shake_x + shake_x, _ropa_y, pou_scale_x * 0.85, pou_scale_y * 0.85, 0, c_white, _pou_alpha);
}

// 2. Bigote
if (variable_global_exists("pou_bigote") && global.pou_bigote != -1) {
    var _bigote_y = pou_y + shake_y - 173 * pou_scale_y;
    draw_sprite_ext(global.pou_bigote, 0, pou_x + head_shake_x + shake_x, _bigote_y, pou_scale_x * 0.75, pou_scale_y * 0.75, 0, c_white, _pou_alpha);
}

// 3. Lentes equipados si existen (con altura correcta en los ojos)
if (variable_global_exists("pou_lentes") && global.pou_lentes != -1) {
    var _glasses_y = pou_y + shake_y - 228.5 * pou_scale_y;
    draw_sprite_ext(global.pou_lentes, 0, pou_x + head_shake_x + shake_x, _glasses_y, pou_scale_x * 0.72, pou_scale_y * 0.72, 0, c_white, _pou_alpha);
}

// 4. Sombrero equipado si existe (con altura correcta en la cabeza)
if (variable_global_exists("pou_sombrero") && global.pou_sombrero != -1) {
    var _hat_y_off = 330;
    var _hat_scale = 0.78;
    if (global.pou_sombrero == spr_sombrero_bruja || global.pou_sombrero == spr_sombrero_fiesta) {
        _hat_y_off = 345;
        _hat_scale = 0.80;
    } else if (global.pou_sombrero == spr_sombrero_copa) {
        _hat_y_off = 320;
        _hat_scale = 0.76;
    } else if (global.pou_sombrero == spr_sombrero_lana) {
        _hat_y_off = 325;
        _hat_scale = 0.78;
    } else if (global.pou_sombrero == spr_sombrero_azul) {
        _hat_y_off = 330;
        _hat_scale = 0.76;
    } else if (global.pou_sombrero == spr_sombrero_negro) {
        _hat_y_off = 330;
        _hat_scale = 0.78;
    }
    var _hat_y = pou_y + shake_y - _hat_y_off * pou_scale_y;
    draw_sprite_ext(global.pou_sombrero, 0, pou_x + head_shake_x + shake_x, _hat_y, pou_scale_x * _hat_scale, pou_scale_y * _hat_scale, 0, c_white, _pou_alpha);
}
draw_set_alpha(1.0);

// ========================================================
// 4. PARTÍCULAS Y TEXTOS FLOTANTES
// ========================================================
for (var _p = 0; _p < array_length(particles); _p++) {
    var _part = particles[_p];
    draw_set_alpha(_part.alpha);
    draw_set_color(_part.color);
    draw_circle(_part.x, _part.y, _part.size, false);
}
draw_set_alpha(1.0);

for (var _t = 0; _t < array_length(floating_texts); _t++) {
    var _txt = floating_texts[_t];
    draw_set_alpha(_txt.alpha);
    draw_set_color(_txt.color);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_txt.x, _txt.y, _txt.text, _txt.scale, _txt.scale, 0);
}
draw_set_alpha(1.0);

// ========================================================
// 5. HUD SUPERIOR DE PARTIDA
// ========================================================
// 5.1 Botón Volver a la Sala (Izquierda)
var _bx1 = 20;
var _by1 = 20;
var _bx2 = 135;
var _by2 = 68;
var _h_exit = point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2);

draw_set_color(_c_pou_shadow);
draw_roundrect(_bx1, _by1 + 3, _bx2, _by2 + 3, false);
draw_set_color(_h_exit ? make_color_rgb(245, 238, 225) : _c_pou_pill);
draw_roundrect(_bx1, _by1, _bx2, _by2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_bx1, _by1, _bx2, _by2, true);

draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "<- Sala", 1.25, 1.25, 0);

// 5.2 Pastilla de Puntos y Racha Combo
var _px1 = 150;
var _py1 = 20;
var _px2 = 360;
var _py2 = 68;

draw_set_color(_c_pou_shadow);
draw_roundrect(_px1, _py1 + 3, _px2, _py2 + 3, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_px1, _py1, _px2, _py2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_px1, _py1, _px2, _py2, true);

draw_sprite_ext(spr_food_apple, 0, _px1 + 24, (_py1 + _py2) * 0.5, 0.45, 0.45, 0, c_white, 1);
draw_set_color(_c_pou_text);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text_transformed(_px1 + 50, (_py1 + _py2) * 0.5, "Puntos: " + string(score_food), 1.25, 1.25, 0);

if (combo >= 2) {
    // Insignia de combo
    draw_set_color(make_color_rgb(245, 160, 30));
    draw_set_halign(fa_right);
    draw_text_transformed(_px2 - 10, (_py1 + _py2) * 0.5, "x" + string(combo), 1.15, 1.15, 0);
}

// 5.3 Pastilla de Monedas
var _mx1 = 375;
var _my1 = 20;
var _mx2 = 520;
var _my2 = 68;

draw_set_color(_c_pou_shadow);
draw_roundrect(_mx1, _my1 + 3, _mx2, _my2 + 3, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_mx1, _my1, _mx2, _my2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_mx1, _my1, _mx2, _my2, true);

draw_sprite_ext(spr_moneda, 0, _mx1 + 24, (_my1 + _my2) * 0.5, 0.52, 0.52, 0, c_white, 1);
draw_set_color(_c_pou_text);
draw_set_halign(fa_left);
draw_text_transformed(_mx1 + 48, (_my1 + _my2) * 0.5, string(global.pou_monedas), 1.25, 1.25, 0);

// 5.4 Vidas restantes (Pastilla a la derecha con 4 corazones)
var _vx1 = 515;
var _vy1 = 20;
var _vx2 = 700;
var _vy2 = 68;

draw_set_color(_c_pou_shadow);
draw_roundrect(_vx1, _vy1 + 3, _vx2, _vy2 + 3, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_vx1, _vy1, _vx2, _vy2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_vx1, _vy1, _vx2, _vy2, true);

var _heart_spacing = (_vx2 - _vx1 - 36) / (max_lives - 1);
for (var _l = 0; _l < max_lives; _l++) {
    var _lx = _vx1 + 18 + _l * _heart_spacing;
    var _ly = (_vy1 + _vy2) * 0.5;
    if (_l < lives_count) {
        // Vida activa (Círculo rojo brillante)
        draw_set_color(make_color_rgb(235, 60, 60));
        draw_circle(_lx, _ly, 12, false);
        draw_set_color(_c_pou_border);
        draw_circle(_lx, _ly, 12, true);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(_lx, _ly - 1, "<3", 0.85, 0.85, 0);
    } else {
        // Vida perdida (Gris con X)
        draw_set_color(make_color_rgb(180, 170, 160));
        draw_circle(_lx, _ly, 12, false);
        draw_set_color(_c_pou_border);
        draw_circle(_lx, _ly, 12, true);
        draw_set_color(make_color_rgb(110, 100, 90));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(_lx, _ly, "X", 0.85, 0.85, 0);
    }
}

// ========================================================
// 6. MODAL: PANTALLA DE INSTRUCCIONES / LISTO (STATE_READY)
// ========================================================
if (game_state == state_ready) {
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    var _rw1 = 50;
    var _ry1 = 250;
    var _rw2 = 670;
    var _ry2 = 885;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_rw1 + 3, _ry1 + 5, _rw2 + 3, _ry2 + 5, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_rw1, _ry1, _rw2, _ry2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_rw1, _ry1, _rw2, _ry2, true);
    
    // Título
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, _ry1 + 30, "ATRAPAR COMIDA", 1.7, 1.7, 0);
    draw_set_color(make_color_rgb(140, 110, 80));
    draw_text_transformed(360, _ry1 + 70, "(Food Drop)", 1.15, 1.15, 0);
    
    // Récord actual
    if (global.food_drop_highscore > 0) {
        draw_set_color(make_color_rgb(220, 140, 20));
        draw_text_transformed(360, _ry1 + 105, "Mejor Record: " + string(global.food_drop_highscore) + " puntos", 1.15, 1.15, 0);
    }
    
    // Decoración de comida cayendo
    var _fl = dsin(anim_t * 3) * 6;
    draw_sprite_ext(spr_food_cherries, 0, 160, _ry1 + 175 + _fl, 0.9, 0.9, -15, c_white, 1);
    draw_sprite_ext(spr_pou_emociones, 1, 360, _ry1 + 225, 0.60, 0.60, 0, c_white, 1);
    draw_sprite_ext(spr_food_apple, 0, 560, _ry1 + 175 - _fl, 0.9, 0.9, 15, c_white, 1);
    
    // Instrucciones en texto limpio ASCII
    draw_set_color(make_color_rgb(90, 75, 60));
    draw_text_transformed(360, _ry1 + 295, "* Mueve a Pou con el raton o las flechas / A-D", 1.15, 1.15, 0);
    draw_text_transformed(360, _ry1 + 335, "* Atrapa las frutas y postres (+1 Moneda por comida)", 1.05, 1.05, 0);
    draw_text_transformed(360, _ry1 + 375, "* Esquiva los zapatos y herraduras!", 1.15, 1.15, 0);
    draw_text_transformed(360, _ry1 + 415, "* Cada 5 comidas seguidas: Bonificacion de COMBO!", 1.1, 1.1, 0);
    draw_text_transformed(360, _ry1 + 455, "* Tienes 4 vidas. Cada 15 comidas recuperas 1 vida!", 1.05, 1.05, 0);
    
    // Botón Empezar
    var _btn_s_x1 = 360 - 150;
    var _btn_s_y1 = 780;
    var _btn_s_x2 = 360 + 150;
    var _btn_s_y2 = 850;
    var _h_start = point_in_rectangle(mouse_x, mouse_y, _btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2);
    
    draw_set_color(make_color_rgb(200, 185, 165));
    draw_roundrect(_btn_s_x1 + 2, _btn_s_y1 + 3, _btn_s_x2 + 2, _btn_s_y2 + 3, false);
    draw_set_color(_h_start ? make_color_rgb(105, 195, 85) : _c_pou_green);
    draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_btn_s_x1, _btn_s_y1, _btn_s_x2, _btn_s_y2, true);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(360, (_btn_s_y1 + _btn_s_y2) * 0.5, "EMPEZAR", 1.5, 1.5, 0);
}

// ========================================================
// 7. MODAL: JUEGO EN PAUSA (STATE_PAUSED)
// ========================================================
if (game_state == state_paused) {
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    var _pw1 = 120;
    var _py1 = 440;
    var _pw2 = 600;
    var _py2 = 780;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_pw1 + 3, _py1 + 5, _pw2 + 3, _py2 + 5, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_pw1, _py1, _pw2, _py2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_pw1, _py1, _pw2, _py2, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, _py1 + 35, "JUEGO EN PAUSA", 1.6, 1.6, 0);
    
    // Botón Continuar
    var _pr_x1 = 360 - 140; var _pr_y1 = 580; var _pr_x2 = 360 + 140; var _pr_y2 = 645;
    var _h_pr = point_in_rectangle(mouse_x, mouse_y, _pr_x1, _pr_y1, _pr_x2, _pr_y2);
    draw_set_color(_h_pr ? make_color_rgb(105, 195, 85) : _c_pou_green);
    draw_roundrect(_pr_x1, _pr_y1, _pr_x2, _pr_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_pr_x1, _pr_y1, _pr_x2, _pr_y2, true);
    draw_set_color(c_white);
    draw_set_valign(fa_middle);
    draw_text_transformed(360, (_pr_y1 + _pr_y2) * 0.5, "Continuar", 1.35, 1.35, 0);
    
    // Botón Salir
    var _pq_x1 = 360 - 140; var _pq_y1 = 665; var _pq_x2 = 360 + 140; var _pq_y2 = 730;
    var _h_pq = point_in_rectangle(mouse_x, mouse_y, _pq_x1, _pq_y1, _pq_x2, _pq_y2);
    draw_set_color(_h_pq ? make_color_rgb(245, 238, 225) : _c_pou_pill);
    draw_roundrect(_pq_x1, _pq_y1, _pq_x2, _pq_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_pq_x1, _pq_y1, _pq_x2, _pq_y2, true);
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, (_pq_y1 + _pq_y2) * 0.5, "Salir a la Sala", 1.25, 1.25, 0);
}

// ========================================================
// 8. MODAL: JUEGO TERMINADO (STATE_GAMEOVER)
// ========================================================
if (game_state == state_gameover) {
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    var _gw1 = 60;
    var _gy1 = 260;
    var _gw2 = 660;
    var _gy2 = 945;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_gw1 + 3, _gy1 + 5, _gw2 + 3, _gy2 + 5, false);
    draw_set_color(make_color_rgb(255, 252, 244));
    draw_roundrect(_gw1, _gy1, _gw2, _gy2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_gw1, _gy1, _gw2, _gy2, true);
    
    // Cabecera Game Over
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(190, 45, 45));
    draw_text_transformed(360, _gy1 + 30, "FIN DEL JUEGO", 1.8, 1.8, 0);
    
    // Nuevo récord si corresponde
    if (is_new_record) {
        draw_set_color(make_color_rgb(230, 150, 20));
        draw_text_transformed(360, _gy1 + 75, "NUEVO RECORD!", 1.4, 1.4, 0);
    }
    
    // Pou triste en el centro
    draw_sprite_ext(spr_pou_emociones, 3, 360, _gy1 + 185, 0.60, 0.60, 0, c_white, 1);
    
    // Estadísticas
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, _gy1 + 245, "Comidas Atrapadas: " + string(score_food), 1.4, 1.4, 0);
    draw_text_transformed(360, _gy1 + 285, "Mejor Racha Combo: x" + string(max_combo), 1.25, 1.25, 0);
    
    // Monedas ganadas
    draw_sprite_ext(spr_moneda, 0, 305, _gy1 + 340, 0.7, 0.7, 0, c_white, 1);
    draw_set_color(make_color_rgb(140, 105, 30));
    draw_set_halign(fa_left);
    draw_text_transformed(340, _gy1 + 325, "+" + string(coins_earned) + " Monedas", 1.4, 1.4, 0);
    
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(45, 135, 40));
    draw_text_transformed(360, _gy1 + 380, "Diversion de Pou aumentada!", 1.25, 1.25, 0);
    
    // Botón Reintentar
    var _btn_r_x1 = 360 - 150;
    var _btn_r_y1 = 770;
    var _btn_r_x2 = 360 + 150;
    var _btn_r_y2 = 835;
    var _h_retry = point_in_rectangle(mouse_x, mouse_y, _btn_r_x1, _btn_r_y1, _btn_r_x2, _btn_r_y2);
    
    draw_set_color(make_color_rgb(200, 185, 165));
    draw_roundrect(_btn_r_x1 + 2, _btn_r_y1 + 2, _btn_r_x2 + 2, _btn_r_y2 + 2, false);
    draw_set_color(_h_retry ? make_color_rgb(105, 195, 85) : _c_pou_green);
    draw_roundrect(_btn_r_x1, _btn_r_y1, _btn_r_x2, _btn_r_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_btn_r_x1, _btn_r_y1, _btn_r_x2, _btn_r_y2, true);
    
    draw_set_color(c_white);
    draw_set_valign(fa_middle);
    draw_text_transformed(360, (_btn_r_y1 + _btn_r_y2) * 0.5, "Reintentar", 1.35, 1.35, 0);
    
    // Botón Volver a la Sala
    var _btn_b_x1 = 360 - 150;
    var _btn_b_y1 = 855;
    var _btn_b_x2 = 360 + 150;
    var _btn_b_y2 = 920;
    var _h_back = point_in_rectangle(mouse_x, mouse_y, _btn_b_x1, _btn_b_y1, _btn_b_x2, _btn_b_y2);
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_btn_b_x1, _btn_b_y1 + 2, _btn_b_x2, _btn_b_y2 + 2, false);
    draw_set_color(_h_back ? make_color_rgb(245, 238, 225) : _c_pou_pill);
    draw_roundrect(_btn_b_x1, _btn_b_y1, _btn_b_x2, _btn_b_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_btn_b_x1, _btn_b_y1, _btn_b_x2, _btn_b_y2, true);
    
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, (_btn_b_y1 + _btn_b_y2) * 0.5, "<- Volver a la Sala", 1.25, 1.25, 0);
}

// Reset de configuraciones de dibujo
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
