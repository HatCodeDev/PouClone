/// @desc Dibujo de Lámpara, Armario, Oscuridad de Sueño y Modal de Ropa
var _pou = instance_find(obj_pou, 0);

// Paleta de colores original de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);
var _c_pou_border = make_color_rgb(75, 52, 30);
var _c_pou_pill   = make_color_rgb(255, 250, 238);
var _c_pou_shadow = make_color_rgb(215, 205, 185);

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
// 2. MODAL DEL ARMARIO (Personalización de Ropa y Accesorios)
// ========================================================
if (closet_open) {
    // Fondo oscuro translúcido
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // Ventana modal
    var _mx1 = 20;
    var _my1 = 20;
    var _mx2 = 700;
    var _my2 = 1225;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_mx1 + 4, _my1 + 6, _mx2 + 4, _my2 + 6, false);
    draw_set_color(make_color_rgb(255, 252, 244));
    draw_roundrect(_mx1, _my1, _mx2, _my2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_mx1, _my1, _mx2, _my2, true);
    
    // Cabecera del Armario
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(_c_pou_text);
    draw_text_transformed(65, 65, "Armario de Pou", 1.6, 1.6, 0);
    
    // Botón Cerrar "X"
    var _h_close = point_distance(mouse_x, mouse_y, 652, 65) <= 24;
    draw_set_color(_h_close ? make_color_rgb(255, 210, 210) : _c_pou_pill);
    draw_circle(652, 65, 24, false);
    draw_set_color(_c_pou_border);
    draw_circle(652, 65, 24, true);
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(180, 40, 40));
    draw_text_transformed(652, 65, "X", 1.5, 1.5, 0);
    
    // Pestañas (Sombreros y Lentes)
    var _tab_s_col = (closet_tab == 0) ? make_color_rgb(85, 150, 65) : _c_pou_pill;
    var _tab_s_txt = (closet_tab == 0) ? c_white : _c_pou_text;
    draw_set_color(_tab_s_col);
    draw_roundrect(60, 115, 340, 165, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(60, 115, 340, 165, true);
    draw_set_color(_tab_s_txt);
    draw_text_transformed(200, 140, "Sombreros", 1.3, 1.3, 0);
    
    var _tab_l_col = (closet_tab == 1) ? make_color_rgb(85, 150, 65) : _c_pou_pill;
    var _tab_l_txt = (closet_tab == 1) ? c_white : _c_pou_text;
    draw_set_color(_tab_l_col);
    draw_roundrect(380, 115, 660, 165, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(380, 115, 660, 165, true);
    draw_set_color(_tab_l_txt);
    draw_text_transformed(520, 140, "Lentes", 1.3, 1.3, 0);
    
    // Lista de ítems según pestaña
    var _items = (closet_tab == 0) ? sombreros : lentes;
    var _cur_equipped = (closet_tab == 0) ? global.pou_sombrero : global.pou_lentes;
    
    for (var _i = 0; _i < array_length(_items); _i++) {
        var _card_x = (_i mod 2 == 0) ? 60 : 380;
        var _card_y = 200 + floor(_i / 2) * 220;
        var _card_w = 280;
        var _card_h = 190;
        var _it = _items[_i];
        var _is_equipped = (_cur_equipped == _it.sprite);
        
        // Sombra de tarjeta
        draw_set_color(_c_pou_shadow);
        draw_roundrect(_card_x + 2, _card_y + 3, _card_x + _card_w + 2, _card_y + _card_h + 3, false);
        // Fondo de tarjeta
        draw_set_color(_is_equipped ? make_color_rgb(255, 252, 230) : c_white);
        draw_roundrect(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, false);
        draw_set_color(_is_equipped ? make_color_rgb(85, 150, 65) : _c_pou_border);
        draw_roundrect(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, true);
        
        // Sprite o icono
        if (_it.sprite != -1) {
            var _preview_scale = (closet_tab == 1) ? 0.65 : 0.72;
            draw_sprite_ext(_it.sprite, 0, _card_x + _card_w * 0.5, _card_y + 75, _preview_scale, _preview_scale, 0, c_white, 1);
        } else {
            draw_set_color(make_color_rgb(180, 180, 180));
            draw_circle(_card_x + _card_w * 0.5, _card_y + 75, 28, true);
            draw_line_width(_card_x + _card_w * 0.5 - 20, _card_y + 95, _card_x + _card_w * 0.5 + 20, _card_y + 55, 3);
        }
        
        // Nombre del ítem
        draw_set_color(_c_pou_text);
        draw_text_transformed(_card_x + _card_w * 0.5, _card_y + 130, _it.name, 1.2, 1.2, 0);
        
        // Botón Equipado / Poner
        var _btn_y1 = _card_y + 148;
        var _btn_y2 = _card_y + 180;
        draw_set_color(_is_equipped ? make_color_rgb(95, 185, 80) : _c_pou_pill);
        draw_roundrect(_card_x + 40, _btn_y1, _card_x + _card_w - 40, _btn_y2, false);
        draw_set_color(_c_pou_border);
        draw_roundrect(_card_x + 40, _btn_y1, _card_x + _card_w - 40, _btn_y2, true);
        draw_set_color(_is_equipped ? c_white : _c_pou_text);
        draw_text_transformed(_card_x + _card_w * 0.5, (_btn_y1 + _btn_y2) * 0.5, _is_equipped ? "Puesto" : "Equipar", 1.05, 1.05, 0);
    }
    
    // Botón inferior "Volver al Dormitorio"
    var _close_w = 320;
    var _close_h = 48;
    var _cl_x1 = 360 - _close_w * 0.5;
    var _cl_y1 = 1152;
    var _cl_x2 = _cl_x1 + _close_w;
    var _cl_y2 = _cl_y1 + _close_h;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_cl_x1, _cl_y1 + 2, _cl_x2, _cl_y2 + 2, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, true);
    
    draw_set_color(_c_pou_text);
    draw_text_transformed(360, _cl_y1 + _close_h * 0.5, "<- Volver al Dormitorio", 1.3, 1.3, 0);
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
