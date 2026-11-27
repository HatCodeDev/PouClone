/// @desc Renderizado visual completo del Minijuego "Juego de Memoria" - Diseño Perfeccionado 100%

// Paleta de colores oficial de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);
var _c_pou_border = make_color_rgb(75, 52, 30);
var _c_pou_pill   = make_color_rgb(255, 250, 238);
var _c_pou_shadow = make_color_rgb(215, 205, 185);
var _c_pou_green  = make_color_rgb(85, 165, 60);

// ========================================================
// 1. FONDO DE SALA DE JUEGOS Y AMBIENTACIÓN CÁLIDA
// ========================================================
var _bg_top = make_color_rgb(222, 236, 252);
var _bg_bot = make_color_rgb(195, 218, 244);
draw_rectangle_color(0, 0, room_width, room_height, _bg_top, _bg_top, _bg_bot, _bg_bot, false);

// Patrón decorativo sutil en las paredes (estilo sala de juegos)
draw_set_color(make_color_rgb(240, 248, 255));
draw_set_alpha(0.35);
for (var _gx = 30; _gx < room_width; _gx += 60) {
    for (var _gy = 30; _gy < room_height; _gy += 60) {
        draw_circle(_gx, _gy, 4, false);
    }
}
draw_set_alpha(1.0);

// ========================================================
// 2. HUD SUPERIOR (Sin solapamientos, totalmente equilibrado)
// ========================================================
// 2.1 Botón Volver a la Sala (Izquierda)
var _bx1 = 24;
var _by1 = 20;
var _bx2 = 155;
var _by2 = 72;
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

// 2.2 Pastilla de Intentos
var _ix1 = 169;
var _iy1 = 20;
var _ix2 = 349;
var _iy2 = 72;

draw_set_color(_c_pou_shadow);
draw_roundrect(_ix1, _iy1 + 3, _ix2, _iy2 + 3, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_ix1, _iy1, _ix2, _iy2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_ix1, _iy1, _ix2, _iy2, true);

draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed((_ix1 + _ix2) * 0.5, (_iy1 + _iy2) * 0.5, "Intentos: " + string(moves_count), 1.2, 1.2, 0);

// 2.3 Pastilla de Monedas
var _mx1 = 363;
var _my1 = 20;
var _mx2 = 523;
var _my2 = 72;

draw_set_color(_c_pou_shadow);
draw_roundrect(_mx1, _my1 + 3, _mx2, _my2 + 3, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_mx1, _my1, _mx2, _my2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_mx1, _my1, _mx2, _my2, true);

draw_sprite_ext(spr_moneda, 0, _mx1 + 28, (_my1 + _my2) * 0.5, 0.52, 0.52, 0, c_white, 1);
draw_set_color(_c_pou_text);
draw_set_halign(fa_left);
draw_text_transformed(_mx1 + 52, (_my1 + _my2) * 0.5, string(global.pou_monedas), 1.25, 1.25, 0);

// 2.4 Pastilla de Tiempo
var _tx1 = 537;
var _ty1 = 20;
var _tx2 = 696;
var _ty2 = 72;

draw_set_color(_c_pou_shadow);
draw_roundrect(_tx1, _ty1 + 3, _tx2, _ty2 + 3, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_tx1, _ty1, _tx2, _ty2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_tx1, _ty1, _tx2, _ty2, true);

draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed((_tx1 + _tx2) * 0.5, (_ty1 + _ty2) * 0.5, string(timer_seconds) + "s", 1.25, 1.25, 0);

// ========================================================
// 3. POU COMPAÑERO SUPERVISOR (Visible al 100%, sin cortes)
// ========================================================
// Sombra ovalada en el suelo debajo de Pou
draw_set_alpha(0.25);
draw_set_color(c_black);
draw_ellipse(pou_x - 45, pou_y - 4, pou_x + 45, pou_y + 10, false);
draw_set_alpha(1.0);

// Dibujo de Pou con salto animado
draw_sprite_ext(spr_pou_emociones, pou_emotion, pou_x, pou_y + pou_jump_y, pou_scale, pou_scale, 0, c_white, 1);

// 1. Ropa / Pajarita
if (variable_global_exists("pou_ropa") && global.pou_ropa != -1) {
    var _ropa_y = pou_y + pou_jump_y - 95 * pou_scale;
    draw_sprite_ext(global.pou_ropa, 0, pou_x, _ropa_y, pou_scale * 0.85, pou_scale * 0.85, 0, c_white, 1);
}

// 2. Bigote
if (variable_global_exists("pou_bigote") && global.pou_bigote != -1) {
    var _bigote_y = pou_y + pou_jump_y - 173 * pou_scale;
    draw_sprite_ext(global.pou_bigote, 0, pou_x, _bigote_y, pou_scale * 0.75, pou_scale * 0.75, 0, c_white, 1);
}

// 3. Lentes equipados
if (variable_global_exists("pou_lentes") && global.pou_lentes != -1) {
    var _glasses_y = pou_y + pou_jump_y - 228.5 * pou_scale;
    draw_sprite_ext(global.pou_lentes, 0, pou_x, _glasses_y, pou_scale * 0.72, pou_scale * 0.72, 0, c_white, 1);
}

// 4. Sombrero equipado
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
    draw_sprite_ext(global.pou_sombrero, 0, pou_x, pou_y + pou_jump_y - _hat_y_off * pou_scale, pou_scale * _hat_scale, pou_scale * _hat_scale, 0, c_white, 1);
}

// ========================================================
// 4. PASTILLA DE ESTADO: PAREJAS Y PROGRESO VISUAL
// ========================================================
var _msg_x1 = 160;
var _msg_y1 = 315;
var _msg_x2 = 560;
var _msg_y2 = 370;

draw_set_color(_c_pou_shadow);
draw_roundrect(_msg_x1, _msg_y1 + 2, _msg_x2, _msg_y2 + 2, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_msg_x1, _msg_y1, _msg_x2, _msg_y2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_msg_x1, _msg_y1, _msg_x2, _msg_y2, true);

// Texto de estado
draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var _status_text = (pairs_found == total_pairs) ? "Increible! Lo lograste!" : ("Parejas: " + string(pairs_found) + " de " + string(total_pairs));
draw_text_transformed(360, _msg_y1 + 17, _status_text, 1.15, 1.15, 0);

// Indicadores luminosos de las 8 parejas
var _dot_start_x = 360 - 70;
for (var _k = 0; _k < total_pairs; _k++) {
    var _dot_x = _dot_start_x + _k * 20;
    var _dot_y = _msg_y1 + 38;
    var _is_done = (_k < pairs_found);
    
    draw_set_color(_is_done ? make_color_rgb(255, 195, 30) : make_color_rgb(220, 210, 195));
    draw_circle(_dot_x, _dot_y, 5, false);
    draw_set_color(_is_done ? make_color_rgb(180, 130, 20) : make_color_rgb(175, 160, 145));
    draw_circle(_dot_x, _dot_y, 5, true);
}

// ========================================================
// 5. TAPETE Y TABLERO DE CARTAS (4x4 = 16 CARTAS OPTIMIZADAS)
// ========================================================
var _mat_x1 = 45;
var _mat_y1 = 405;
var _mat_x2 = 675;
var _mat_y2 = 1065;

// Sombra suave del tapete
draw_set_color(make_color_rgb(180, 202, 228));
draw_roundrect(_mat_x1 + 3, _mat_y1 + 5, _mat_x2 + 3, _mat_y2 + 5, false);

// Relleno del tapete
draw_set_color(make_color_rgb(246, 250, 255));
draw_roundrect(_mat_x1, _mat_y1, _mat_x2, _mat_y2, false);

// Borde del tapete
draw_set_color(make_color_rgb(175, 200, 230));
draw_roundrect(_mat_x1, _mat_y1, _mat_x2, _mat_y2, true);

// Renderizado individual de cartas
for (var _i = 0; _i < array_length(cards); _i++) {
    var _cd = cards[_i];
    var _cx = _cd.x;
    var _cy = _cd.y;
    var _half_w = _cd.w * 0.5;
    var _half_h = _cd.h * 0.5;
    var _is_hover = point_in_rectangle(mouse_x, mouse_y, _cx - _half_w, _cy - _half_h, _cx + _half_w, _cy + _half_h) && !_cd.is_matched && !_cd.is_face_up && _cd.flip_phase == 0;
    
    var _scale_draw_x = (130 / 100) * _cd.scale_x;
    var _scale_draw_y = (130 / 100) * _cd.scale_y;
    
    // Sombra proyectada con el propio sprite de la carta (sin esquinas cuadradas toscas)
    draw_sprite_ext(_cd.is_face_up ? spr_carta_frente : spr_carta_atras, 0, _cx + 3, _cy + 5, _scale_draw_x, _scale_draw_y, 0, c_black, 0.20);
    
    if (_cd.is_face_up || _cd.is_matched) {
        // Carta Boca Arriba (spr_carta_frente + Icono correspondiente)
        draw_sprite_ext(spr_carta_frente, 0, _cx, _cy, _scale_draw_x, _scale_draw_y, 0, c_white, 1);
        
        // Icono de la pareja en el centro de la carta
        draw_sprite_ext(_cd.icon, 0, _cx, _cy, 0.95 * _cd.scale_x, 0.95 * _cd.scale_y, 0, c_white, 1);
        
        // Borde verde si está acertada o azul si está volteada
        if (_cd.is_matched) {
            draw_set_color(make_color_rgb(75, 185, 60));
            draw_roundrect(_cx - _half_w * _cd.scale_x, _cy - _half_h * _cd.scale_y, _cx + _half_w * _cd.scale_x, _cy + _half_h * _cd.scale_y, true);
        } else {
            draw_set_color(make_color_rgb(60, 130, 210));
            draw_roundrect(_cx - _half_w * _cd.scale_x, _cy - _half_h * _cd.scale_y, _cx + _half_w * _cd.scale_x, _cy + _half_h * _cd.scale_y, true);
        }
        
        // Halo de brillo visual de celebración al acertar
        if (_cd.glow > 0) {
            draw_set_alpha(_cd.glow * 0.45);
            draw_set_color(c_yellow);
            draw_roundrect(_cx - _half_w * _cd.scale_x - 4, _cy - _half_h * _cd.scale_y - 4, _cx + _half_w * _cd.scale_x + 4, _cy + _half_h * _cd.scale_y + 4, false);
            draw_set_alpha(1.0);
        }
    } else {
        // Carta Boca Abajo (spr_carta_atras)
        var _card_col = _is_hover ? make_color_rgb(255, 245, 230) : c_white;
        draw_sprite_ext(spr_carta_atras, 0, _cx, _cy, _scale_draw_x, _scale_draw_y, 0, _card_col, 1);
        
        if (_is_hover) {
            draw_set_color(make_color_rgb(220, 160, 50));
            draw_roundrect(_cx - _half_w, _cy - _half_h, _cx + _half_w, _cy + _half_h, true);
        }
    }
}

// ========================================================
// 6. BARRA DE CONTROL INFERIOR (Récord y Botón Reiniciar)
// ========================================================
// 6.1 Pastilla de Récord
var _rx1 = 45;
var _ry1 = 1105;
var _rx2 = 345;
var _ry2 = 1175;

draw_set_color(_c_pou_shadow);
draw_roundrect(_rx1, _ry1 + 3, _rx2, _ry2 + 3, false);
draw_set_color(_c_pou_pill);
draw_roundrect(_rx1, _ry1, _rx2, _ry2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_rx1, _ry1, _rx2, _ry2, true);

// Icono estrella / trofeo
draw_set_color(make_color_rgb(230, 160, 20));
draw_circle(_rx1 + 36, (_ry1 + _ry2) * 0.5, 14, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(_rx1 + 36, (_ry1 + _ry2) * 0.5, "*", 1.5, 1.5, 0);

draw_set_color(_c_pou_text);
draw_set_halign(fa_left);
var _rec_text = (global.memory_best_moves > 0) ? ("Record: " + string(global.memory_best_moves) + " int.") : "Sin record aun";
draw_text_transformed(_rx1 + 60, (_ry1 + _ry2) * 0.5, _rec_text, 1.15, 1.15, 0);

// 6.2 Botón Reiniciar Tablero
var _reb_x1 = 375;
var _reb_y1 = 1105;
var _reb_x2 = 675;
var _reb_y2 = 1175;
var _h_reb = point_in_rectangle(mouse_x, mouse_y, _reb_x1, _reb_y1, _reb_x2, _reb_y2);

draw_set_color(_c_pou_shadow);
draw_roundrect(_reb_x1, _reb_y1 + 3, _reb_x2, _reb_y2 + 3, false);
draw_set_color(_h_reb ? make_color_rgb(240, 248, 238) : _c_pou_pill);
draw_roundrect(_reb_x1, _reb_y1, _reb_x2, _reb_y2, false);
draw_set_color(_c_pou_border);
draw_roundrect(_reb_x1, _reb_y1, _reb_x2, _reb_y2, true);

draw_set_color(_c_pou_text);
draw_set_halign(fa_center);
draw_text_transformed((_reb_x1 + _reb_x2) * 0.5, (_reb_y1 + _reb_y2) * 0.5, "Reiniciar Tablero", 1.25, 1.25, 0);

// ========================================================
// 7. PARTÍCULAS Y TEXTOS FLOTANTES
// ========================================================
for (var _p = 0; _p < array_length(particles); _p++) {
    var _pt = particles[_p];
    draw_set_alpha(_pt.alpha);
    draw_set_color(_pt.color);
    draw_circle(_pt.x, _pt.y, _pt.size, false);
}
draw_set_alpha(1.0);

for (var _t = 0; _t < array_length(floating_texts); _t++) {
    var _ft = floating_texts[_t];
    draw_set_alpha(_ft.alpha);
    draw_set_color(_ft.color);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_ft.x, _ft.y, _ft.text, _ft.scale, _ft.scale, 0);
}
draw_set_alpha(1.0);

// ========================================================
// 8. MODAL: INSTRUCCIONES / LISTO (STATE_READY)
// ========================================================
if (game_state == state_ready) {
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    var _ready_w1 = 55;
    var _ready_y1 = 230;
    var _ready_w2 = 665;
    var _ready_y2 = 910;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_ready_w1 + 3, _ready_y1 + 5, _ready_w2 + 3, _ready_y2 + 5, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_ready_w1, _ready_y1, _ready_w2, _ready_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_ready_w1, _ready_y1, _ready_w2, _ready_y2, true);
    
    // Título
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, _ready_y1 + 30, "JUEGO DE MEMORIA", 1.65, 1.65, 0);
    draw_set_color(make_color_rgb(140, 110, 80));
    draw_text_transformed(360, _ready_y1 + 72, "(Memory Match)", 1.15, 1.15, 0);
    
    // Récord actual
    if (global.memory_best_moves > 0) {
        draw_set_color(make_color_rgb(220, 140, 20));
        draw_text_transformed(360, _ready_y1 + 108, "Mejor Record: " + string(global.memory_best_moves) + " intentos", 1.15, 1.15, 0);
    }
    
    // Decoración de cartas
    var _fl = dsin(anim_t * 3) * 6;
    draw_sprite_ext(spr_carta_atras, 0, 200, _ready_y1 + 185 + _fl, 0.95, 0.95, -10, c_white, 1);
    draw_sprite_ext(spr_carta_frente, 0, 360, _ready_y1 + 185 - _fl, 0.95, 0.95, 0, c_white, 1);
    draw_sprite_ext(spr_game_avion, 0, 360, _ready_y1 + 185 - _fl, 0.85, 0.85, 0, c_white, 1);
    draw_sprite_ext(spr_carta_frente, 0, 520, _ready_y1 + 185 + _fl, 0.95, 0.95, 10, c_white, 1);
    draw_sprite_ext(spr_food_apple, 0, 520, _ready_y1 + 185 + _fl, 0.85, 0.85, 10, c_white, 1);
    
    // Instrucciones en texto limpio ASCII
    draw_set_color(make_color_rgb(90, 75, 60));
    draw_text_transformed(360, _ready_y1 + 295, "* Toca dos cartas para voltearlas", 1.2, 1.2, 0);
    draw_text_transformed(360, _ready_y1 + 340, "* Encuentra las 8 parejas de figuras iguales", 1.1, 1.1, 0);
    draw_text_transformed(360, _ready_y1 + 385, "* Ganas +5 Monedas por cada pareja acertada!", 1.15, 1.15, 0);
    draw_text_transformed(360, _ready_y1 + 430, "* Bonificacion de +10 Monedas al completar el tablero!", 1.05, 1.05, 0);
    draw_text_transformed(360, _ready_y1 + 475, "* Aumenta la DIVERSION de Pou al 100%!", 1.1, 1.1, 0);
    
    // Botón Empezar
    var _btn_s_x1 = 200;
    var _btn_s_y1 = 805;
    var _btn_s_x2 = 520;
    var _btn_s_y2 = 875;
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
// 9. MODAL: VICTORIA / TABLERO COMPLETADO (STATE_VICTORY)
// ========================================================
if (game_state == state_victory) {
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    var _vw1 = 55;
    var _vy1 = 210;
    var _vw2 = 665;
    var _vy2 = 970;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_vw1 + 3, _vy1 + 5, _vw2 + 3, _vy2 + 5, false);
    draw_set_color(make_color_rgb(255, 252, 244));
    draw_roundrect(_vw1, _vy1, _vw2, _vy2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_vw1, _vy1, _vw2, _vy2, true);
    
    // Cabecera Victoria
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(45, 140, 35));
    draw_text_transformed(360, _vy1 + 30, "EXCELENTE MEMORIA!", 1.7, 1.7, 0);
    
    // Nuevo récord si corresponde
    if (is_new_record) {
        draw_set_color(make_color_rgb(230, 150, 20));
        draw_text_transformed(360, _vy1 + 75, "NUEVO RECORD DE INTENTOS!", 1.35, 1.35, 0);
    }
    
    // Pou feliz celebrando
    draw_sprite_ext(spr_pou_emociones, 1, 360, _vy1 + 220, 0.65, 0.65, 0, c_white, 1);
    
    // Estadísticas
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, _vy1 + 265, "Intentos realizados: " + string(moves_count), 1.35, 1.35, 0);
    draw_text_transformed(360, _vy1 + 310, "Tiempo total: " + string(timer_seconds) + " segundos", 1.35, 1.35, 0);
    
    // Monedas ganadas
    draw_sprite_ext(spr_moneda, 0, 305, _vy1 + 380, 0.7, 0.7, 0, c_white, 1);
    draw_set_color(make_color_rgb(140, 105, 30));
    draw_set_halign(fa_left);
    draw_text_transformed(340, _vy1 + 368, "+" + string(coins_earned) + " Monedas", 1.4, 1.4, 0);
    
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(45, 135, 40));
    draw_text_transformed(360, _vy1 + 435, "Diversion de Pou al 100%!", 1.25, 1.25, 0);
    
    // Botón Jugar Otra Vez
    var _btn_r_x1 = 200;
    var _btn_r_y1 = 785;
    var _btn_r_x2 = 520;
    var _btn_r_y2 = 855;
    var _h_retry = point_in_rectangle(mouse_x, mouse_y, _btn_r_x1, _btn_r_y1, _btn_r_x2, _btn_r_y2);
    
    draw_set_color(make_color_rgb(200, 185, 165));
    draw_roundrect(_btn_r_x1 + 2, _btn_r_y1 + 2, _btn_r_x2 + 2, _btn_r_y2 + 2, false);
    draw_set_color(_h_retry ? make_color_rgb(105, 195, 85) : _c_pou_green);
    draw_roundrect(_btn_r_x1, _btn_r_y1, _btn_r_x2, _btn_r_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_btn_r_x1, _btn_r_y1, _btn_r_x2, _btn_r_y2, true);
    
    draw_set_color(c_white);
    draw_set_valign(fa_middle);
    draw_text_transformed(360, (_btn_r_y1 + _btn_r_y2) * 0.5, "Jugar Otra Vez", 1.35, 1.35, 0);
    
    // Botón Volver a la Sala
    var _btn_b_x1 = 200;
    var _btn_b_y1 = 875;
    var _btn_b_x2 = 520;
    var _btn_b_y2 = 945;
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
