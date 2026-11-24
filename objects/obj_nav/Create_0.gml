/// @desc Navegación por carrusel de habitaciones superiores y controladores
arrow_radius = 21;
arrow_l_x = 220;
arrow_r_x = 500;
arrow_y = 39;

// Lista ordenada de habitaciones: Dormitorio <-> Cocina <-> Baño <-> Sala
rooms_list = [
    { target: rm_dormitorio, name: "Dormitorio" },
    { target: rm_cocina,     name: "Cocina" },
    { target: rm_bano,       name: "Bano" }, // Se dibuja como Baño con tilde
    { target: rm_sala,       name: "Sala" }
];

// Detectar habitación actual
current_room_index = 0;
for (var _i = 0; _i < array_length(rooms_list); _i++) {
    if (rooms_list[_i].target == room) {
        current_room_index = _i;
        break;
    }
}
room_title = rooms_list[current_room_index].name;

// Creación dinámica de controladores de cada habitación si no existen
switch (room) {
    case rm_dormitorio:
        if (!instance_exists(obj_dormitorio)) {
            instance_create_layer(0, 0, "Instances", obj_dormitorio);
        }
        break;
    case rm_cocina:
        if (!instance_exists(obj_cocina)) {
            instance_create_layer(0, 0, "Instances", obj_cocina);
        }
        break;
    case rm_bano:
        if (!instance_exists(obj_bano)) {
            instance_create_layer(0, 0, "Instances", obj_bano);
        }
        break;
}

// La room conserva 720x1280; la ventana de escritorio se ajusta a la pantalla.
if (os_type == os_windows) {
    var _scale = min(0.75, (display_get_height() - 140) / 1280);
    window_set_size(round(720 * _scale), round(1280 * _scale));
    window_center();
}
