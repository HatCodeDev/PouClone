/// @desc Dibujo del Botón de Juegos en la Sala y Modal Completo de Minijuegos

// Paleta de colores original de Pou
var _c_pou_text   = make_color_rgb(52, 36, 20);
var _c_pou_border = make_color_rgb(75, 52, 30);
var _c_pou_pill   = make_color_rgb(255, 250, 238);
var _c_pou_shadow = make_color_rgb(215, 205, 185);
var _c_pou_green  = make_color_rgb(85, 165, 60);

// ========================================================
// 1. BOTÓN "JUEGOS" EN EL SUELO DE LA SALA (rm_sala)
// ========================================================
if (!games_menu_open) {
    var _bx1 = games_btn_x - games_btn_w * 0.5;
    var _by1 = games_btn_y - games_btn_h * 0.5;
    var _bx2 = games_btn_x + games_btn_w * 0.5;
    var _by2 = games_btn_y + games_btn_h * 0.5;
    
    var _is_hover = point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2);
    
    // Sombra del pedestal en el suelo
    draw_set_alpha(0.25);
    draw_set_color(c_black);
    draw_ellipse(games_btn_x - 130, games_btn_y + 28, games_btn_x + 130, games_btn_y + 48, false);
    draw_set_alpha(1);
    
    // Sombra 3D del botón
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_bx1 + 2, _by1 + 4, _bx2 + 2, _by2 + 4, false);
    
    // Cuerpo del botón (Crema cálido, ligeramente más claro al pasar el cursor)
    draw_set_color(_is_hover ? make_color_rgb(255, 253, 246) : _c_pou_pill);
    draw_roundrect(_bx1, _by1, _bx2, _by2, false);
    
    // Borde marrón
    draw_set_color(_c_pou_border);
    draw_roundrect(_bx1, _by1, _bx2, _by2, true);
    
    // Icono decorativo estilo Gamepad / Joystick a la izquierda
    var _icon_x = games_btn_x - 72;
    var _icon_y = games_btn_y;
    draw_set_color(make_color_rgb(180, 170, 160));
    draw_roundrect(_icon_x - 18, _icon_y - 12, _icon_x + 18, _icon_y + 12, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_icon_x - 18, _icon_y - 12, _icon_x + 18, _icon_y + 12, true);
    // Botones del mando
    draw_set_color(make_color_rgb(220, 60, 60));
    draw_circle(_icon_x + 9, _icon_y - 4, 3, false);
    draw_set_color(make_color_rgb(60, 130, 220));
    draw_circle(_icon_x + 9, _icon_y + 4, 3, false);
    // Cruz direccional
    draw_set_color(_c_pou_border);
    draw_line_width(_icon_x - 11, _icon_y, _icon_x - 3, _icon_y, 3);
    draw_line_width(_icon_x - 7, _icon_y - 4, _icon_x - 7, _icon_y + 4, 3);
    
    // Texto del botón
    draw_set_color(_c_pou_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text_transformed(games_btn_x - 38, games_btn_y, "Juegos", 1.4, 1.4, 0);
    
    // Insignia verde "2 Minijuegos"
    var _badge_x = _bx2 - 25;
    var _badge_y = _by1 + 6;
    draw_set_color(_c_pou_green);
    draw_circle(_badge_x, _badge_y, 14, false);
    draw_set_color(_c_pou_border);
    draw_circle(_badge_x, _badge_y, 14, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text_transformed(_badge_x, _badge_y, "2", 1.1, 1.1, 0);
}

// ========================================================
// 2. MODAL DE SELECCIÓN DE MINIJUEGOS (games_menu_open)
// ========================================================
if (games_menu_open) {
    // 2.1 Fondo oscuro translúcido
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // 2.2 Ventana modal principal
    var _mx1 = 20;
    var _my1 = 20;
    var _mx2 = 700;
    var _my2 = 1225;
    
    // Sombra del contenedor
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_mx1 + 4, _my1 + 6, _mx2 + 4, _my2 + 6, false);
    // Fondo crema cálido
    draw_set_color(make_color_rgb(255, 252, 244));
    draw_roundrect(_mx1, _my1, _mx2, _my2, false);
    // Borde marrón exterior
    draw_set_color(_c_pou_border);
    draw_roundrect(_mx1, _my1, _mx2, _my2, true);
    
    // 2.3 Cabecera del modal
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(_c_pou_text);
    draw_text_transformed(55, 60, "Sala de Videojuegos", 1.55, 1.55, 0);
    
    draw_set_color(make_color_rgb(115, 95, 75));
    draw_text_transformed(55, 90, "Juega con Pou para divertirte y ganar monedas", 1.05, 1.05, 0);
    
    // Contador de Monedas en cabecera
    var _coin_box_x = 450;
    var _coin_box_y = 60;
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_coin_box_x, _coin_box_y - 18, _coin_box_x + 120, _coin_box_y + 18, false);
    draw_set_color(_c_pou_pill);
    draw_roundrect(_coin_box_x, _coin_box_y - 20, _coin_box_x + 120, _coin_box_y + 16, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_coin_box_x, _coin_box_y - 20, _coin_box_x + 120, _coin_box_y + 16, true);
    
    draw_sprite_ext(spr_moneda, 0, _coin_box_x + 22, _coin_box_y - 2, 0.45, 0.45, 0, c_white, 1);
    draw_set_color(_c_pou_text);
    draw_set_halign(fa_center);
    draw_text_transformed(_coin_box_x + 72, _coin_box_y - 2, string(global.pou_monedas), 1.25, 1.25, 0);
    
    // Botón Cerrar "X"
    var _h_close = point_distance(mouse_x, mouse_y, 652, 65) <= 24;
    draw_set_color(_h_close ? make_color_rgb(255, 210, 210) : _c_pou_pill);
    draw_circle(652, 65, 24, false);
    draw_set_color(_c_pou_border);
    draw_circle(652, 65, 24, true);
    draw_set_color(make_color_rgb(180, 40, 40));
    draw_set_halign(fa_center);
    draw_text_transformed(652, 65, "X", 1.5, 1.5, 0);
    
    // Banner de feedback al seleccionar
    if (feedback_timer > 0) {
        var _fb_alpha = min(1, feedback_timer / 20);
        draw_set_alpha(_fb_alpha);
        draw_set_color(make_color_rgb(220, 245, 215));
        draw_roundrect(50, 120, 670, 168, false);
        draw_set_color(_c_pou_green);
        draw_roundrect(50, 120, 670, 168, true);
        draw_set_color(make_color_rgb(40, 110, 30));
        draw_set_halign(fa_center);
        draw_text_transformed(360, 144, feedback_msg, 1.2, 1.2, 0);
        draw_set_alpha(1);
    }
    
    // ========================================================
    // 2.4 TARJETA 1: ATRAPAR COMIDA (Food Drop)
    // ========================================================
    var _c1_x1 = 50;
    var _c1_y1 = 190;
    var _c1_x2 = 670;
    var _c1_y2 = 440;
    var _h_c1 = point_in_rectangle(mouse_x, mouse_y, _c1_x1, _c1_y1, _c1_x2, _c1_y2);
    
    // Sombra y fondo de tarjeta 1
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_c1_x1 + 3, _c1_y1 + 4, _c1_x2 + 3, _c1_y2 + 4, false);
    draw_set_color(c_white);
    draw_roundrect(_c1_x1, _c1_y1, _c1_x2, _c1_y2, false);
    draw_set_color(_h_c1 ? make_color_rgb(220, 90, 50) : _c_pou_border);
    draw_roundrect(_c1_x1, _c1_y1, _c1_x2, _c1_y2, true);
    
    // Escuadro de vista previa izquierda (Ilustración temática)
    var _prev1_x1 = _c1_x1 + 16;
    var _prev1_y1 = _c1_y1 + 16;
    var _prev1_x2 = _prev1_x1 + 160;
    var _prev1_y2 = _c1_y2 - 16;
    draw_set_color(make_color_rgb(255, 245, 235));
    draw_roundrect(_prev1_x1, _prev1_y1, _prev1_x2, _prev1_y2, false);
    draw_set_color(make_color_rgb(240, 215, 195));
    draw_roundrect(_prev1_x1, _prev1_y1, _prev1_x2, _prev1_y2, true);
    
    // Comida cayendo en la vista previa
    var _float1 = dsin(anim_t * 2) * 5;
    draw_sprite_ext(spr_food_cherries, 0, _prev1_x1 + 40, _prev1_y1 + 45 + _float1, 0.7, 0.7, -15, c_white, 1);
    draw_sprite_ext(spr_food_apple, 0, _prev1_x1 + 115, _prev1_y1 + 65 - _float1, 0.75, 0.75, 12, c_white, 1);
    draw_sprite_ext(spr_food_donut, 0, _prev1_x1 + 75, _prev1_y1 + 115 + _float1 * 0.7, 0.65, 0.65, 0, c_white, 1);
    // Mini Pou mirando hacia arriba
    draw_sprite_ext(spr_pou_emociones, 1, _prev1_x1 + 80, _prev1_y2 - 10, 0.42, 0.42, 0, c_white, 1);
    
    // Contenido descriptivo de la tarjeta 1
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Etiqueta distintiva
    draw_set_color(make_color_rgb(255, 230, 220));
    draw_roundrect(_c1_x1 + 195, _c1_y1 + 20, _c1_x1 + 310, _c1_y1 + 46, false);
    draw_set_color(make_color_rgb(220, 80, 50));
    draw_set_halign(fa_center);
    draw_text_transformed(_c1_x1 + 252, _c1_y1 + 24, "AGILIDAD", 0.95, 0.95, 0);
    
    // Título y subtítulo
    draw_set_halign(fa_left);
    draw_set_color(_c_pou_text);
    draw_text_transformed(_c1_x1 + 195, _c1_y1 + 54, "Atrapar Comida", 1.45, 1.45, 0);
    draw_set_color(make_color_rgb(140, 110, 80));
    draw_text_transformed(_c1_x1 + 195, _c1_y1 + 88, "(Food Drop)", 1.05, 1.05, 0);
    
    // Descripción
    draw_set_color(make_color_rgb(90, 75, 60));
    draw_text_ext_transformed(_c1_x1 + 195, _c1_y1 + 115, "Mueve a Pou de lado a lado para comer las frutas y postres que caen del cielo. ¡No dejes caer ninguna comida!", 22, 450, 1.0, 1.0, 0);
    
    // Recompensa
    draw_sprite_ext(spr_moneda, 0, _c1_x1 + 205, _c1_y2 - 42, 0.4, 0.4, 0, c_white, 1);
    draw_set_color(make_color_rgb(130, 95, 20));
    draw_set_valign(fa_middle);
    draw_text_transformed(_c1_x1 + 225, _c1_y2 - 42, "+1 Moneda por bocado", 1.05, 1.05, 0);
    
    // Botón JUGAR de la tarjeta 1
    var _btn1_x1 = _c1_x2 - 145;
    var _btn1_y1 = _c1_y2 - 60;
    var _btn1_x2 = _c1_x2 - 20;
    var _btn1_y2 = _c1_y2 - 20;
    draw_set_color(make_color_rgb(200, 185, 165));
    draw_roundrect(_btn1_x1 + 2, _btn1_y1 + 2, _btn1_x2 + 2, _btn1_y2 + 2, false);
    draw_set_color(_h_c1 ? make_color_rgb(95, 185, 75) : _c_pou_green);
    draw_roundrect(_btn1_x1, _btn1_y1, _btn1_x2, _btn1_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_btn1_x1, _btn1_y1, _btn1_x2, _btn1_y2, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text_transformed((_btn1_x1 + _btn1_x2) * 0.5, (_btn1_y1 + _btn1_y2) * 0.5, "JUGAR", 1.2, 1.2, 0);
    
    // ========================================================
    // 2.5 TARJETA 2: JUEGO DE MEMORIA (Memory Match)
    // ========================================================
    var _c2_x1 = 50;
    var _c2_y1 = 470;
    var _c2_x2 = 670;
    var _c2_y2 = 720;
    var _h_c2 = point_in_rectangle(mouse_x, mouse_y, _c2_x1, _c2_y1, _c2_x2, _c2_y2);
    
    // Sombra y fondo de tarjeta 2
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_c2_x1 + 3, _c2_y1 + 4, _c2_x2 + 3, _c2_y2 + 4, false);
    draw_set_color(c_white);
    draw_roundrect(_c2_x1, _c2_y1, _c2_x2, _c2_y2, false);
    draw_set_color(_h_c2 ? make_color_rgb(50, 130, 220) : _c_pou_border);
    draw_roundrect(_c2_x1, _c2_y1, _c2_x2, _c2_y2, true);
    
    // Escuadro de vista previa izquierda (Ilustración cartas)
    var _prev2_x1 = _c2_x1 + 16;
    var _prev2_y1 = _c2_y1 + 16;
    var _prev2_x2 = _prev2_x1 + 160;
    var _prev2_y2 = _c2_y2 - 16;
    draw_set_color(make_color_rgb(235, 245, 255));
    draw_roundrect(_prev2_x1, _prev2_y1, _prev2_x2, _prev2_y2, false);
    draw_set_color(make_color_rgb(195, 220, 245));
    draw_roundrect(_prev2_x1, _prev2_y1, _prev2_x2, _prev2_y2, true);
    
    // Cartas en la vista previa
    var _float2 = dsin(anim_t * 2 + 90) * 4;
    // Carta boca abajo
    draw_sprite_ext(spr_carta_atras, 0, _prev2_x1 + 52, _prev2_y1 + 75 + _float2, 0.72, 0.72, -8, c_white, 1);
    // Carta boca arriba mostrando avión o herradura
    draw_sprite_ext(spr_carta_frente, 0, _prev2_x1 + 115, _prev2_y1 + 125 - _float2, 0.76, 0.76, 6, c_white, 1);
    draw_sprite_ext(spr_game_avion, 0, _prev2_x1 + 115, _prev2_y1 + 125 - _float2, 0.76, 0.76, 6, c_white, 1);
    
    // Contenido descriptivo de la tarjeta 2
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Etiqueta distintiva
    draw_set_color(make_color_rgb(225, 240, 255));
    draw_roundrect(_c2_x1 + 195, _c2_y1 + 20, _c2_x1 + 325, _c2_y1 + 46, false);
    draw_set_color(make_color_rgb(40, 110, 210));
    draw_set_halign(fa_center);
    draw_text_transformed(_c2_x1 + 260, _c2_y1 + 24, "MEMORIA", 0.95, 0.95, 0);
    
    // Título y subtítulo
    draw_set_halign(fa_left);
    draw_set_color(_c_pou_text);
    draw_text_transformed(_c2_x1 + 195, _c2_y1 + 54, "Juego de Memoria", 1.45, 1.45, 0);
    draw_set_color(make_color_rgb(140, 110, 80));
    draw_text_transformed(_c2_x1 + 195, _c2_y1 + 88, "(Memory Match)", 1.05, 1.05, 0);
    
    // Descripción
    draw_set_color(make_color_rgb(90, 75, 60));
    draw_text_ext_transformed(_c2_x1 + 195, _c2_y1 + 115, "Voltea las cartas y encuentra todas las parejas iguales. ¡Un clásico adictivo que desafía tu concentración y rapidez!", 22, 450, 1.0, 1.0, 0);
    
    // Recompensa
    draw_sprite_ext(spr_moneda, 0, _c2_x1 + 205, _c2_y2 - 42, 0.4, 0.4, 0, c_white, 1);
    draw_set_color(make_color_rgb(130, 95, 20));
    draw_set_valign(fa_middle);
    draw_text_transformed(_c2_x1 + 225, _c2_y2 - 42, "+5 Monedas por pareja", 1.05, 1.05, 0);
    
    // Botón JUGAR de la tarjeta 2
    var _btn2_x1 = _c2_x2 - 145;
    var _btn2_y1 = _c2_y2 - 60;
    var _btn2_x2 = _c2_x2 - 20;
    var _btn2_y2 = _c2_y2 - 20;
    draw_set_color(make_color_rgb(200, 185, 165));
    draw_roundrect(_btn2_x1 + 2, _btn2_y1 + 2, _btn2_x2 + 2, _btn2_y2 + 2, false);
    draw_set_color(_h_c2 ? make_color_rgb(95, 185, 75) : _c_pou_green);
    draw_roundrect(_btn2_x1, _btn2_y1, _btn2_x2, _btn2_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_btn2_x1, _btn2_y1, _btn2_x2, _btn2_y2, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text_transformed((_btn2_x1 + _btn2_x2) * 0.5, (_btn2_y1 + _btn2_y2) * 0.5, "JUGAR", 1.2, 1.2, 0);
    
    // ========================================================
    // 2.6 CAJA DE INFORMACIÓN Y RECOMPENSAS
    // ========================================================
    var _info_x1 = 50;
    var _info_y1 = 760;
    var _info_x2 = 670;
    var _info_y2 = 980;
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_info_x1 + 2, _info_y1 + 3, _info_x2 + 2, _info_y2 + 3, false);
    draw_set_color(make_color_rgb(250, 247, 238));
    draw_roundrect(_info_x1, _info_y1, _info_x2, _info_y2, false);
    draw_set_color(make_color_rgb(180, 165, 145));
    draw_roundrect(_info_x1, _info_y1, _info_x2, _info_y2, true);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_c_pou_text);
    draw_text_transformed(_info_x1 + 24, _info_y1 + 20, "¿Por que jugar con Pou?", 1.3, 1.3, 0);
    
    draw_set_color(make_color_rgb(95, 80, 65));
    draw_text_transformed(_info_x1 + 24, _info_y1 + 60, "*  Aumenta la barra de DIVERSION al 100% rapidamente.", 1.05, 1.05, 0);
    draw_text_transformed(_info_x1 + 24, _info_y1 + 95, "*  Gana monedas para comprar comida en la Nevera y ropa.", 1.05, 1.05, 0);
    draw_text_transformed(_info_x1 + 24, _info_y1 + 130, "*  Proximos minijuegos: Hill Drive, Sky Jump y Pelota.", 1.05, 1.05, 0);
    draw_text_transformed(_info_x1 + 24, _info_y1 + 165, "*  Los minijuegos son los mas sencillos y faciles de disfrutar.", 1.05, 1.05, 0);
    
    // ========================================================
    // 2.7 BOTÓN INFERIOR "VOLVER A LA SALA"
    // ========================================================
    var _close_w = 320;
    var _close_h = 48;
    var _cl_x1 = 360 - _close_w * 0.5;
    var _cl_y1 = 1152;
    var _cl_x2 = _cl_x1 + _close_w;
    var _cl_y2 = _cl_y1 + _close_h;
    
    var _h_btn_back = point_in_rectangle(mouse_x, mouse_y, _cl_x1, _cl_y1, _cl_x2, _cl_y2);
    
    draw_set_color(_c_pou_shadow);
    draw_roundrect(_cl_x1, _cl_y1 + 2, _cl_x2, _cl_y2 + 2, false);
    draw_set_color(_h_btn_back ? make_color_rgb(245, 238, 225) : _c_pou_pill);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, false);
    draw_set_color(_c_pou_border);
    draw_roundrect(_cl_x1, _cl_y1, _cl_x2, _cl_y2, true);
    
    draw_set_color(_c_pou_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(360, _cl_y1 + _close_h * 0.5, "<- Volver a la Sala", 1.3, 1.3, 0);
}

// Reset de configuraciones de dibujo
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
