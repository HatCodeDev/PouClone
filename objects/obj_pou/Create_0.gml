/// @description Emociones y estado de Pou
enum PouEmocion { Normal, Feliz, Serio, Triste, Hambriento, Enfermo }
base_scale = 1.2;
squash_t = 0;
bob_t = random(360);
jump_y = 0;
jump_vy = 0;
home_y = y;

// Variables de interacción física y de expresión
mouth_open = false;
refusing = false;
head_shake_timer = 0;
head_shake_x = 0;
chew_timer = 0;
manual_override = false;

reaction_sounds = [snd_pou_toque, snd_pou_hablar, snd_pou_pregunta];
emocion_nombres = ["Normal", "Feliz", "Serio", "Triste", "Hambriento", "Enfermo"];
sprite_index = spr_pou_emociones;
image_speed = 0;

// Inicialización de estadísticas globales del Pou original
if (!variable_global_exists("pou_hambre")) global.pou_hambre = 35; // Empieza con hambre para alimentar de inmediato
if (!variable_global_exists("pou_salud")) global.pou_salud = 80;
if (!variable_global_exists("pou_diversion")) global.pou_diversion = 70;
if (!variable_global_exists("pou_energia")) global.pou_energia = 85;
if (!variable_global_exists("pou_monedas")) global.pou_monedas = 250;
if (!variable_global_exists("pou_emocion")) global.pou_emocion = PouEmocion.Hambriento;

/// @function cambiar_emocion(_emocion)
/// @param {Real} _emocion Valor de PouEmocion (0 a 5).
cambiar_emocion = function(_emocion) {
    emocion = clamp(floor(_emocion), 0, 5);
    image_index = emocion;
    global.pou_emocion = emocion;
};
cambiar_emocion(global.pou_emocion);
