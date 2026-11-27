/// @desc Dibujo de Lámpara, Armario, Oscuridad de Sueño y Probador en Vivo
var _pou = instance_find(obj_pou, 0);

// Paleta de colores original de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);
var _c_pou_border = make_color_rgb(75, 52, 30);
var _c_pou_pill   = make_color_rgb(255, 250, 238);
var _c_pou_shadow = make_color_rgb(215, 205, 185);
var _c_green      = make_color_rgb(85, 150, 65);
var _c_green_bg   = make_color_rgb(240, 255, 240);

// ========================================================
// 1. ELEMENTOS DEL DORMITORIO (Lámpara y Armario en la parte inferior)
// ========================================================
if (!closet_open) {
    // 1.1 Soporte y Dibujo de la Lámpara
    draw_set_alpha(0.25);
    draw_set_color(c_black);
    draw_ellipse(lamp_x - 55, lamp_y + 35, lamp_x + 55, lamp_y + 55, false);
    
    draw_set_alpha(0.9);
    draw_set_color(make_color_rgb(235, 235, 240));
    draw_ellipse(lamp_x - 50, lamp_y + 20, lamp_x + 50, lamp_y + 48, false);
    draw_set_color(make_color_rgb(252, 252, 255));
    draw_ellipse(lamp_x - 42, lamp_y + 22, lamp_x + 42, lamp_y + 44, false);
    draw_set_alpha(1);
    
    var _lamp_spr = global.pou_lamp_on ? spr_lampara_on : spr_lampara_off;
    draw_sprite_ext(_lamp_spr, 0, lamp_x, lamp_y - 25, 1.25, 1.25, 0, c_white, 1);
    
    // Etiqueta "Lampara"
    var _lw = 90;
    var _lh = 26;
    draw_set_color(_c_pou_shadow);
    draw_roundrect(lamp_x - _lw * 0.5, lamp_y + 58, lamp_x + _lw * 0.5, lamp_y + 58 + _lh, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(lamp_x - _lw * 0.5, lamp_y + 56, lamp_x - _lw * 0.5 + _lw, lamp_y + 56 + _lh, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(lamp_x - _lw * 0.5, lamp_y + 56, lamp_x - _lw * 0.5 + _lw, lamp_y + 56 + _lh, true);
    draw_set_color(_c_pou_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(lamp_x, lamp_y + 56 + _lh * 0.5, "Lampara", 1.1, 1.1, 0);

    // 1.2 Soporte y Dibujo del Armario (Gabinete de ropa)
    draw_set_alpha(0.25);
    draw_set_color(c_black);
    draw_ellipse(closet_x - 60, closet_y + 35, closet_x + 60, closet_y + 55, false);
    draw_set_alpha(1);
    
    // Cuerpo del armario estilo madera cálida
    var _cw = 96;
    var _ch = 92;
    var _cx1 = closet_x - _cw * 0.5;
    var _cy1 = closet_y - 65;
    var _cx2 = _cx1 + _cw;
    var _cy2 = _cy1 + _ch;
    
    // Sombra del armario
    draw_set_color(make_color_rgb(120, 80, 50));
    draw_roundrect(_cx1 + 2, _cy1 + 3, _cx2 + 2, _cy2 + 3, false);
    // Puertas
    draw_set_color(make_color_rgb(175, 125, 80));
    draw_roundrect(_cx1, _cy1, _cx2, _cy2, false);
    draw_set_color(make_color_rgb(85, 50, 25));
    draw_roundrect(_cx1, _cy1, _cx2, _cy2, true);
    // División central y tiradores
    draw_line_width(closet_x, _cy1 + 4, closet_x, _cy2 - 4, 2);
    draw_set_color(make_color_rgb(255, 215, 80));
    draw_circle(closet_x - 12, closet_y - 20, 4, false);
    draw_circle(closet_x + 12, closet_y - 20, 4, false);
    
    // Etiqueta "Armario"
    draw_set_color(_c_pou_shadow);
    draw_roundrect(closet_x - _lw * 0.5, closet_y + 58, closet_x + _lw * 0.5, closet_y + 58 + _lh, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(closet_x - _lw * 0.5, closet_y + 56, closet_x - _lw * 0.5 + _lw, closet_y + 56 + _lh, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(closet_x - _lw * 0.5, closet_y + 56, closet_x - _lw * 0.5 + _lw, closet_y + 56 + _lh, true);
    draw_set_color(_c_pou_text);
    draw_text_transformed(closet_x, closet_y + 56 + _lh * 0.5, "Armario", 1.1, 1.1, 0);
    
    // 1.3 Partículas Zzz al dormir
    for (var _z = 0; _z < array_length(zzz_particles); _z++) {
        var _zp = zzz_particles[_z];
        draw_set_alpha(_zp.alpha);
        draw_set_color(make_color_rgb(210, 235, 255));
        draw_text_transformed(_zp.x, _zp.y, "Z", _zp.scale * 1.5, _zp.scale * 1.5, 0);
    }
    draw_set_alpha(1);
    
    // 1.4 Oscuridad de la habitación cuando la lámpara está apagada
    if (!global.pou_lamp_on) {
        draw_set_alpha(0.82);
        draw_set_color(make_color_rgb(12, 16, 32));
        draw_rectangle(0, 0, room_width, room_height, false);
        
        // Destello sutil alrededor de la lámpara para facilitar encenderla
        draw_set_alpha(0.18);
        draw_set_color(make_color_rgb(100, 140, 200));
        draw_circle(lamp_x, lamp_y - 25, 75, false);
        draw_set_alpha(1);
    }
}

// ========================================================
// 2. MODAL DEL ARMARIO Y PROBADOR EN VIVO DE POU
// ========================================================
if (closet_open) {
    // Fondo oscuro translúcido
    draw_set_alpha(0.80);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // Ventana modal principal
    var _mx1 = 24;
    var _my1 = 30;
    var _mx2 = 696;
    var _my2 = 1250;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_mx1 + 4, _my1 + 6, _mx2 + 4, _my2 + 6, false);
    draw_set_color(make_color_rgb(255, 252, 245));
    draw_roundrect(_mx1, _my1, _mx2, _my2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_mx1, _my1, _mx2, _my2, true);
    
    // Cabecera del Armario
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(_c_pou_text);
    draw_text_transformed(55, 65, "Armario de Pou", 1.5, 1.5, 0);
    
    // Botón Cerrar "X"
    var _h_close = point_distance(mouse_x, mouse_y, 652, 65) <= 24;
    draw_set_color(_h_close ? make_color_rgb(255, 210, 210) : _c_pou_pill);
    draw_circle(652, 65, 24, false);
    draw_set_color(_c_pou_border);
    draw_circle(652, 65, 24, true);
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(180, 40, 40));
    draw_text_transformed(652, 65, "X", 1.5, 1.5, 0);
    
    // Etiqueta "Probador en Vivo"
    draw_set_color(_c_pou_shadow);
    draw_roundrect(50, 112, 230, 144, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(50, 110, 230, 142, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(50, 110, 230, 142, true);
    draw_set_color(_c_pou_text);
    draw_text_transformed(140, 126, "Probador en Vivo", 1.05, 1.05, 0);
    
    // Botón "Desvestir Todo"
    var _h_undress = point_in_rectangle(mouse_x, mouse_y, 490, 105, 675, 145);
    draw_set_color(_c_pou_shadow);
    draw_roundrect(490, 107, 675, 147, false);
    draw_set_color(_h_undress ? make_color_rgb(255, 210, 210) : make_color_rgb(255, 235, 235));
    draw_roundrect(490, 105, 675, 145, false);
    draw_set_color(make_color_rgb(190, 60, 60));
    draw_roundrect(490, 105, 675, 145, true);
    draw_text_transformed(582, 125, "Desvestir Todo", 1.05, 1.05, 0);
    
    // --- 2.1 PROBADOR EN VIVO DE POU (Área superior) ---
    // Alfombra redonda del probador
    draw_set_color(make_color_rgb(230, 205, 170));
    draw_ellipse(360 - 150, 455, 360 + 150, 495, false);
    draw_set_color(make_color_rgb(180, 150, 110));
    draw_ellipse(360 - 150, 455, 360 + 150, 495, true);
    draw_set_color(make_color_rgb(245, 225, 195));
    draw_ellipse(360 - 130, 460, 360 + 130, 490, false);
    
    // Cálculo de rebote dinámico al probarse ropa
    var _bounce_offset = sin(preview_bounce * 3.14159) * 26;
    var _bounce_sx = 1.0 + sin(preview_bounce * 3.14159) * 0.10;
    var _bounce_sy = 1.0 - sin(preview_bounce * 3.14159) * 0.10;
    var _p_scale = 0.92;
    var _px = 360;
    var _py = 465 - _bounce_offset;
    
    // Dibujo de Pou en el probador (feliz y vistiendo todo lo equipado)
    draw_sprite_ext(spr_pou_emociones, PouEmocion.Feliz, _px, _py, _p_scale * _bounce_sx, _p_scale * _bounce_sy, 0, c_white, 1);
    
    // 1. Ropa / Pajarita
    if (global.pou_ropa != -1) {
        draw_sprite_ext(global.pou_ropa, 0, _px, _py - 95 * _p_scale * _bounce_sy, _p_scale * _bounce_sx * 0.85, _p_scale * _bounce_sy * 0.85, 0, c_white, 1);
    }
    // 2. Bigote
    if (global.pou_bigote != -1) {
        draw_sprite_ext(global.pou_bigote, 0, _px, _py - 173 * _p_scale * _bounce_sy, _p_scale * _bounce_sx * 0.75, _p_scale * _bounce_sy * 0.75, 0, c_white, 1);
    }
    // 3. Lentes
    if (global.pou_lentes != -1) {
        draw_sprite_ext(global.pou_lentes, 0, _px, _py - 228.5 * _p_scale * _bounce_sy, _p_scale * _bounce_sx * 0.72, _p_scale * _bounce_sy * 0.72, 0, c_white, 1);
    }
    // 4. Sombrero
    if (global.pou_sombrero != -1) {
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
        draw_sprite_ext(global.pou_sombrero, 0, _px, _py - _hat_y_off * _p_scale * _bounce_sy, _p_scale * _bounce_sx * _hat_scale, _p_scale * _bounce_sy * _hat_scale, 0, c_white, 1);
    }
    
    // --- 2.2 PESTAÑAS DE CATEGORÍA (y: 515..560) ---
    var _tabs_info = [
        { name: "Sombreros", x1: 36,  x2: 188 },
        { name: "Lentes",    x1: 194, x2: 346 },
        { name: "Ropa",      x1: 352, x2: 504 },
        { name: "Bigotes",   x1: 510, x2: 662 }
    ];
    
    for (var _t = 0; _t < 4; _t++) {
        var _tb = _tabs_info[_t];
        var _is_active = (closet_tab == _t);
        draw_set_color(_c_pou_shadow);
        draw_roundrect(_tb.x1, 517, _tb.x2, 562, false);
        draw_set_color(_is_active ? _c_green : _c_pou_pill);
        draw_roundrect(_tb.x1, 515, _tb.x2, 560, false);
        draw_set_color(_is_active ? _c_green : _c_pou_border);
        draw_roundrect(_tb.x1, 515, _tb.x2, 560, true);
        draw_set_color(_is_active ? c_white : _c_pou_text);
        draw_text_transformed((_tb.x1 + _tb.x2) * 0.5, 537, _tb.name, 1.15, 1.15, 0);
    }
    
    // --- 2.3 CATÁLOGO DE ÍTEMS EN TARJETAS (y: 575..1115) ---
    var _items = sombreros;
    var _cur_equipped = global.pou_sombrero;
    if (closet_tab == 1) { _items = lentes; _cur_equipped = global.pou_lentes; }
    else if (closet_tab == 2) { _items = ropas; _cur_equipped = global.pou_ropa; }
    else if (closet_tab == 3) { _items = bigotes; _cur_equipped = global.pou_bigote; }
    
    var _start_idx = closet_page * 6;
    var _end_idx = min(array_length(_items), _start_idx + 6);
    
    for (var _k = _start_idx; _k < _end_idx; _k++) {
        var _local_i = _k - _start_idx;
        var _card_x = (_local_i mod 2 == 0) ? 45 : 365;
        var _card_y = 575 + floor(_local_i / 2) * 185;
        var _card_w = 310;
        var _card_h = 175;
        var _it = _items[_k];
        
        var _is_eq = (_it.sprite == -1) ? (_cur_equipped == -1) : (_cur_equipped == _it.sprite);
        
        // Sombra de tarjeta
        draw_set_color(_c_pou_shadow);
        draw_roundrect(_card_x + 2, _card_y + 3, _card_x + _card_w + 2, _card_y + _card_h + 3, false);
        // Fondo de tarjeta
        draw_set_color(_is_eq ? _c_green_bg : c_white);
        draw_roundrect(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, false);
        draw_set_color(_is_eq ? _c_green : _c_pou_border);
        draw_roundrect(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, true);
        
        // Icono / Sprite en la tarjeta
        if (_it.sprite != -1) {
            var _thumb_scale = 0.58;
            if (closet_tab == 2) _thumb_scale = 0.65;
            else if (closet_tab == 3) _thumb_scale = 0.70;
            draw_sprite_ext(_it.sprite, 0, _card_x + _card_w * 0.5, _card_y + 48, _thumb_scale, _thumb_scale, 0, c_white, 1);
        } else {
            // Icono de desequipar (círculo con línea diagonal)
            draw_set_color(make_color_rgb(180, 180, 180));
            draw_circle(_card_x + _card_w * 0.5, _card_y + 48, 24, true);
            draw_line_width(_card_x + _card_w * 0.5 - 16, _card_y + 64, _card_x + _card_w * 0.5 + 16, _card_y + 32, 2.5);
        }
        
        // Nombre del ítem
        draw_set_color(_c_pou_text);
        draw_text_transformed(_card_x + _card_w * 0.5, _card_y + 98, _it.name, 1.15, 1.15, 0);
        
        // Botón Equipar / Puesto
        var _btn_y1 = _card_y + 125;
        var _btn_y2 = _card_y + 162;
        draw_set_color(_is_eq ? _c_green : _c_pou_pill);
        draw_roundrect(_card_x + 35, _btn_y1, _card_x + _card_w - 35, _btn_y2, false);
        draw_set_color(_is_eq ? _c_green : _c_pou_border);
        draw_roundrect(_card_x + 35, _btn_y1, _card_x + _card_w - 35, _btn_y2, true);
        draw_set_color(_is_eq ? c_white : _c_pou_text);
        draw_text_transformed(_card_x + _card_w * 0.5, (_btn_y1 + _btn_y2) * 0.5, _is_eq ? "Puesto" : "Equipar", 1.05, 1.05, 0);
    }
    
    // --- 2.4 FLECHAS DE PAGINACIÓN SI HAY MÁS DE 6 ÍTEMS ---
    if (array_length(_items) > 6) {
        var _total_pages = ceil(array_length(_items) / 6);
        
        // Flecha anterior
        if (closet_page > 0) {
            draw_set_color(_c_pou_pill);
            draw_roundrect(220, 1130, 290, 1170, false);
            draw_set_color(_c_pou_border);
            draw_roundrect(220, 1130, 290, 1170, true);
            draw_set_color(_c_pou_text);
            draw_text_transformed(255, 1150, "<", 1.3, 1.3, 0);
        }
        
        // Indicador de página
        draw_set_color(_c_pou_text);
        draw_text_transformed(360, 1150, "Pagina " + string(closet_page + 1) + " / " + string(_total_pages), 1.1, 1.1, 0);
        
        // Flecha siguiente
        if ((_start_idx + 6) < array_length(_items)) {
            draw_set_color(_c_pou_pill);
            draw_roundrect(430, 1130, 500, 1170, false);
            draw_set_color(_c_pou_border);
            draw_roundrect(430, 1130, 500, 1170, true);
            draw_set_color(_c_pou_text);
            draw_text_transformed(465, 1150, ">", 1.3, 1.3, 0);
        }
    }
    
    // --- 2.5 BOTÓN INFERIOR "VOLVER AL DORMITORIO" ---
    var _close_w = 360;
    var _close_h = 54;
    var _cl_x1 = 360 - _close_w * 0.5;
    var _cl_y1 = 1180;
    var _cl_x2 = _cl_x1 + _close_w;
    var _cl_y2 = _cl_y1 + _close_h;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_cl_x1, _cl_y1 + 2, _cl_x2, _cl_y2 + 2, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, true);
    
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, _cl_y1 + _close_h * 0.5, "<- Volver al Dormitorio", 1.25, 1.25, 0);
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
