/// @desc Inicialización del cuarto de Baño / Ducha (Jabón, Ducha, Espuma, Agua y Limpieza)
depth = -50;

// Estado del Jabón
jabon_home_x = 200;
jabon_home_y = 1000;
jabon_x = jabon_home_x;
jabon_y = jabon_home_y;
jabon_dragging = false;
jabon_drag_ox = 0;
jabon_drag_oy = 0;
jabon_scale = 1.25;
jabon_angle = 0;
prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;

// Estado de la Ducha
ducha_home_x = 520;
ducha_home_y = 995;
ducha_x = ducha_home_x;
ducha_y = ducha_home_y;
ducha_dragging = false;
ducha_drag_ox = 0;
ducha_drag_oy = 0;
ducha_scale = 1.3;
ducha_angle = 0;

// Control de arrastre general
is_dragging = false;
active_tool = "";

// Cooldowns de audio y generación
rub_sound_cooldown = 0;
water_sound_cooldown = 0;
soap_spawn_cooldown = 0;

// Arreglos de partículas interactivas
bubbles = [];      // Burbujas de jabón sobre Pou
water_drops = [];  // Gotas de agua que caen de la regadera
splashes = [];     // Salpicaduras al impactar agua/burbujas
sparkles = [];     // Estrellitas brillantes cuando queda limpio

// Celebración al dejar a Pou 100% limpio
celebration_timer = 0;
celebration_text = "";
celebration_alpha = 0;
was_dirty = (global.pou_suciedad > 20);

float_t = 0;
