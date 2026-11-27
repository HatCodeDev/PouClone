# Módulo 05: Módulo de Dormitorio, Sueño y Armario
## Ciclo Circadiano, Probador en Vivo en Tiempo Real y Catálogo de Ropa

---

### 1. Visión General del Módulo (`obj_dormitorio`)
El dormitorio (`rm_dormitorio`) cumple dos funciones fundamentales en la vida de Pou:
1. **El Ciclo de Sueño y Recuperación de Energía:** Mediante el control de la lámpara de noche.
2. **El Armario y Probador de Ropa (Wardrobe):** Personalización visual completa con vista previa instantánea en vivo.

---

### 2. La Lámpara Nocturna y Ciclo de Sueño
Ubicada a la izquierda en $(X=180, Y=1110)$.

Al hacer clic sobre la lámpara (`point_distance <= 55`):
- Alterna el estado `global.pou_lamp_on = !global.pou_lamp_on;` con sonido `snd_click`.

#### Comportamiento con la Lámpara Apagada:
1. **Filtro de Oscuridad:**
   Se dibuja un rectángulo negro azulado con opacidad $82\%$ sobre toda la pantalla:
   ```gml
   draw_set_alpha(0.82);
   draw_set_color(make_color_rgb(12, 16, 32));
   draw_rectangle(0, 0, room_width, room_height, false);
   ```
   Se añade un halo suave alrededor de la lámpara para que el jugador pueda encontrarla y encenderla con facilidad.
2. **Ojos Cerrados de Pou:**
   En `obj_pou/Draw_0.gml`, se detecta que la luz está apagada y se dibujan párpados cerrados exactamente alineados sobre sus cuencas oculares:
   ```gml
   var _eye_y = _py - 228.5 * _sy;
   draw_set_color(make_color_rgb(52, 36, 20));
   draw_line_width(_px - 46, _eye_y, _px - 8, _eye_y, 4.5);
   draw_line_width(_px + 8, _eye_y, _px + 46, _eye_y, 4.5);
   ```
3. **Generación de Letras "Zzz":**
   Cada 32 frames se genera una partícula "Z" que asciende desde la cabeza de Pou hacia la esquina superior derecha, rotando y desvaneciéndose.
4. **Recuperación de Energía:**
   $$\text{global.pou\_energia} = \min(100, \text{global.pou\_energia} + 0.08)$$

---

### 3. El Armario y Probador en Vivo (Live Dressing Room)
El armario físico está ubicado a la derecha en $(X=540, Y=1110)$.

Al abrirlo (`closet_open = true`), la pantalla se transforma en un vestidor profesional con dos zonas ergonómicas:

#### Zona 1: El Probador Superior ($Y=110..500$)
- **Alfombra Circular:** Dibujada con doble elipse cálida en la base ($X=360, Y=475$).
- **Pou en Tiempo Real:** Pou se muestra al centro en escala $0.92$. Está despierto y sonriente (`PouEmocion.Feliz`).
- **Rebote al Probarse Ropa:** Al seleccionar cualquier prenda, Pou realiza un salto festivo con deformación sinusoidal:
  ```gml
  var _bounce_offset = sin(preview_bounce * pi) * 26;
  var _bounce_sx = 1.0 + sin(preview_bounce * pi) * 0.10;
  var _bounce_sy = 1.0 - sin(preview_bounce * pi) * 0.10;
  ```
- **Botón "Desvestir Todo":** Permite reiniciar todos los accesorios a `-1` con un solo toque y sonido `snd_shuffle`.

#### Zona 2: Catálogo Paginado y Pestañas ($Y=515..1240$)
Cuatro pestañas organizadas horizontalmente:
- **Pestaña 0: Sombreros** (7 opciones: Galera Copa, Gorro Fiesta, Gorro Invierno, Gorra Azul, Bruja, Negro, Ninguno).
- **Pestaña 1: Lentes** (5 opciones: Lentes Oro, Lentes Sol Azul, Rojo Clásico, Gafas Negras, Ninguno).
- **Pestaña 2: Ropa / Pajaritas** (5 opciones: Pajarita Roja, Negra, Azul, Oro, Ninguno).
- **Pestaña 3: Bigotes** (3 opciones: Bigote Clásico, Bigote Rizado, Ninguno).

---

### 4. Lógica de Toggle y Botón "Puesto"
En `obj_dormitorio/Step_0.gml`, cada tarjeta detecta si el ítem pulsado ya está equipado:
- Si ya está equipado: Se desequipa (se pone en `-1`), reproduciendo `snd_click`.
- Si no está equipado: Se equipa en la variable global respectiva (`global.pou_sombrero`, `global.pou_lentes`, `global.pou_ropa`, `global.pou_bigote`), Pou salta y se reproduce `snd_pocion`.
- En la interfaz gráfica, la tarjeta equipada se resalta con fondo verde pastel (`rgb(240, 255, 240)`), borde esmeralda y el botón cambia a **"Puesto"**.
