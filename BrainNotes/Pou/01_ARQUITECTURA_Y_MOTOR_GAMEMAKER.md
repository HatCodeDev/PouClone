# Módulo 01: Arquitectura y Motor GameMaker
## Fundamentos del Motor, Ciclo de Vida y Flujo de Ejecución

---

### 1. Entorno de Ejecución y Configuración de Pantalla
- **Motor:** GameMaker 2024.14.4 (LTS compatible).
- **Lenguaje:** GameMaker Language (GML).
- **Resolución Objetivo:** $720 \times 1280$ píxeles (formato vertical estándar de smartphones 9:16).
- **Adaptabilidad a Escritorio (Windows):**
  Para permitir pruebas fluidas en PC sin distorsión ni salirse del monitor, los objetos principales implementan el escalado dinámico en su evento `Create`:
  ```gml
  if (os_type == os_windows) {
      var _scale = min(0.75, (display_get_height() - 140) / 1280);
      window_set_size(round(720 * _scale), round(1280 * _scale));
      window_center();
  }
  ```

---

### 2. Estructura de Salas (Rooms) y Orden de Ejecución
El proyecto organiza las escenas de manera modular en `PouClone.yyp`:

```
Rooms/
├── rm_sala                 (Punto de partida del juego, estancia principal y acceso a minijuegos)
├── rm_cocina               (Alimentación, nevera interactiva y comida física)
├── rm_bano                 (Ducha, jabón, burbujas y mecánica de suciedad)
├── rm_dormitorio           (Descanso, lámpara nocturna y armario probador)
├── rm_minigame_food        (Minijuego: Atrapar Comida / Food Drop)
└── rm_minigame_memory      (Minijuego: Memorama de Cartas / Memory Match)
```

#### Flujo de Navegación entre Habitaciones:
La navegación circular entre las habitaciones principales se controla a través del objeto persistente de navegación `obj_nav`:
$$\text{rm\_sala} \longleftrightarrow \text{rm\_cocina} \longleftrightarrow \text{rm\_bano} \longleftrightarrow \text{rm\_dormitorio} \longleftrightarrow \text{rm\_sala}$$

Los minijuegos se abren desde la **Sala** y cuentan con un botón directo `<- Volver a la Sala` que retorna el control a `rm_sala` conservando monedas y diversión ganadas.

---

### 3. Jerarquía de Objetos y Profundidades (`depth`)
Para evitar solapamientos incorrectos de capas y artefactos visuales, el proyecto implementa una convención estricta de profundidades (`depth`):

| Capa / Elemento | Valor de `depth` | Propósito |
| :--- | :--- | :--- |
| **Fondo de la Habitación** | Capa Room (fondo) | Papel tapiz y suelo |
| **Objetos de Fondo** (Lámpara, Armario cerrado, Ducha en reposo) | `10` a `20` | Permanecen detrás de Pou |
| **Sombra en el Suelo** | `obj_pou` (draw inicial) | Se dibuja con `alpha = 0.2` |
| **Personaje Principal (`obj_pou`)** | `0` | Cuerpo, boca, ojos y accesorios |
| **Objetos Interactivos de Mano** (Comida arrastrada, Jabón, Ducha activa) | `-10` | Flotan por encima de Pou |
| **HUD Superior y Barras de Estado (`obj_nav`)** | `-100` | Siempre visibles sobre el juego |
| **Modales y Ventanas Emergentes** (Nevera, Armario, Menú de Juegos) | `-1000` | Oscurecen y bloquean la interacción de fondo |

---

### 4. Persistencia de Datos y Variables Globales
Los atributos de Pou deben mantenerse sincronizados sin importar a qué habitación viaje el jugador o si entra a un minijuego:

```gml
// 1. Estadísticas Vitales
global.pou_hambre     = 35;   // 0 a 100 (inicia bajo para invitar a comer de inmediato)
global.pou_salud      = 80;   // 0 a 100
global.pou_diversion  = 70;   // 0 a 100
global.pou_energia    = 85;   // 0 a 100
global.pou_suciedad   = 100;  // 0 a 100 (inicia sucio para probar el baño)
global.pou_monedas    = 250;  // Monedero del jugador
global.pou_emocion    = PouEmocion.Hambriento;

// 2. Personalización y Ropa
global.pou_sombrero   = -1;   // Sprite del sombrero o -1
global.pou_lentes     = -1;   // Sprite de lentes o -1
global.pou_ropa       = -1;   // Sprite de pajarita/ropa o -1
global.pou_bigote     = -1;   // Sprite de bigote o -1

// 3. Entorno y Récords
global.pou_lamp_on          = true; // Lámpara del dormitorio
global.food_drop_highscore  = 0;    // Récord de comida atrapada
global.memory_best_moves    = 0;    // Mejor récord en memorama
```

---

### 5. Ciclo de Ejecución Típico de un Frame en GML
1. **`Begin Step`**: Reinicio de banderas de entrada y timers.
2. **`Step`**:
   - Detección de clics/taps con el mouse (`mouse_check_button_pressed`).
   - Actualización física: arrastre de objetos, decaimiento de necesidades por tiempo (`decay_timer`), rebotes y oscilaciones.
3. **`Draw`**:
   - Renderizado del fondo y sombras.
   - Cálculo de deformación elástica de Pou (`_sx`, `_sy`) y renderizado del cuerpo.
   - Renderizado milimétrico de accesorios acoplados al personaje.
   - Renderizado de partículas y HUD superior.
