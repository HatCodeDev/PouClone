# Módulo 08: Sistema de UI, Sonido y Optimizaciones
## Diseño Visual del HUD, Audio y Depuración con Feather

---

### 1. El HUD Superior Unificado (`obj_nav`)
El objeto `obj_nav` se renderiza en la parte más alta de la pantalla ($Y = 0..120$) con una profundidad de `-100`, asegurando que el estado de Pou siempre sea legible para el usuario.

#### Elementos del HUD:
1. **Contador de Monedas:**
   - Ubicado a la izquierda ($X = 30..180$).
   - Icono circular dorado con relieve y brillo specular (`spr_moneda`).
   - Texto con formato de miles e incremento elástico animado al recibir dinero.
2. **Las 4 Píldoras de Necesidades (Barras de Progreso):**
   - **Hambre:** Icono de manzana/cubiertos. Color naranja mandarina (`rgb(255, 160, 40)`).
   - **Salud:** Icono de corazón/cruz. Color rojo cereza (`rgb(240, 60, 70)`).
   - **Diversión:** Icono de pelota/sonrisa. Color amarillo ámbar (`rgb(255, 215, 30)`).
   - **Energía:** Icono de rayo/luna. Color verde lima (`rgb(105, 210, 60)`).
3. **Flechas de Navegación Lateral:**
   - Botón `<` a la izquierda y `>` a la derecha para rotar entre las 4 habitaciones con feedback táctil.

---

### 2. Paleta de Color Oficial de Pou
El diseño visual se apega rigurosamente a la estética cálida, suave y caricaturesca del juego original:

```gml
// Paleta Central de Pou
var _c_pou_bg     = make_color_rgb(245, 240, 225); // Crema cálido de pared
var _c_pou_floor  = make_color_rgb(220, 205, 175); // Madera suave de suelo
var _c_pou_text   = make_color_rgb(52, 36, 20);   // Chocolate oscuro para tipografías
var _c_pou_border = make_color_rgb(75, 52, 30);   // Borde marrón definido
var _c_pou_pill   = make_color_rgb(255, 250, 238); // Fondo de botones e interiores
var _c_pou_shadow = make_color_rgb(215, 205, 185); // Sombra pastel inferior
var _c_pou_green  = make_color_rgb(85, 150, 65);  // Verde esmeralda de confirmación / éxito
```

---

### 3. Solución a Caracteres Rotos y Fuentes del Motor
En GameMaker, la fuente por defecto (`fnt_default`) no incluye el set extendido de caracteres UTF-8 en todas las plataformas (Windows/Android/HTML5), lo que suele provocar signos de interrogación o cajas vacías en pantalla con palabras acentuadas como *"Habitación"*, *"Energía"*, *"Récord"*, *"Pestaña"*.

**Regla de Ingeniería Aplicada:**
Todas las cadenas dibujadas con `draw_text()` o `draw_text_transformed()` fueron limpiadas para utilizar caracteres ASCII estándar seguros:
- `"Lampara"` en lugar de `"Lámpara"`.
- `"Armario"` en lugar de `"Armario"`.
- `"Record"` en lugar de `"Récord"`.
- `"Pagina 1 / 2"` en lugar de `"Página 1 / 2"`.
- `"Volver al Dormitorio"` en lugar de `"Volver al Dormitó... "`.

---

### 4. Sistema de Audio y Efectos Sonoros
El proyecto incluye una librería balanceada de 20 efectos de sonido en formato WAV/OGG organizados en `audiogroup_default`:
- **UI:** `snd_click` (pulsación), `snd_shuffle` (desvestir o barajar).
- **Pou Expresivo:** `snd_pou_toque` (reacción táctil), `snd_pou_salto` (alegría), `snd_no` (rechazo de comida), `snd_pou_hablar`, `snd_pou_pregunta`.
- **Acciones:** `snd_comer`, `snd_comer2`, `snd_comer3` (masticación), `snd_pou_rascar` (espuma de jabón), `snd_pou_beber` (ducha de agua), `snd_pocion` (equipar ropa), `snd_moneda` (recompensa), `snd_acierto`, `snd_match` (memorama).

---

### 5. Auditoría de Calidad y Resolución Feather (GM2044)
El compilador y linter Feather de GameMaker realiza análisis estático de tipos y alcances. 

- **El Problema GM2044:**
  En GML, las variables declaradas con `var` tienen ámbito de función/script completo. Si se declara `var _py1 = ...` en una sección del script y luego se vuelve a poner `var _py1 = ...` más abajo en el mismo archivo, Feather genera una advertencia:
  `GM2044: Local variable '_py1' is already declared.`
- **La Solución Implementada:**
  Se renombraron semánticamente las variables en los modales:
  - En `obj_minigame_food`: `_pbox_x1, _pbox_y1, _pbox_x2, _pbox_y2` para el modal de pausa.
  - En `obj_minigame_memory`: `_ready_w1, _ready_y1, _ready_w2, _ready_y2` para el modal de inicio.
- **Resultado:** **0 Errores, 0 Warnings, 0 Suggestions**. Proyecto limpio y listo para producción.
