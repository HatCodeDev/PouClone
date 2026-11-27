# Módulo 02: Pou: Estados, Física y Emociones
## Anatomía Matemática, Animaciones Sinusoidales y Máquina de Estados Emocionales

---

### 1. El Objeto Central: `obj_pou`
`obj_pou` es el corazón del juego. Representa visual y matemáticamente a la mascota virtual en todas las habitaciones del hogar.

#### Constantes y Dimensiones Anatómicas:
- **Sprite:** `spr_pou_emociones` ($500 \times 360$ px nativos).
- **Punto de Origen:** $(X=250, Y=360)$, ubicado en la base central inferior de su cuerpo.
- **Escala Base:** `base_scale = 1.2`.
- **Posición de Descanso (`home_y`):** $Y = 780$.

---

### 2. Deformación Elástica en Tiempo Real (Squash & Stretch)
Para que Pou no se sienta estático ni rígido como una imagen plana, su escala se calcula dinámicamente cada frame en `obj_pou/Draw_0.gml` mediante la superposición de tres ondas sinusoidales:

$$\text{Factor Respiración: } \Delta_{\text{breath}} = \sin(\text{bob\_t}) \times 0.03$$
$$\text{Factor Reacción al Toque: } \Delta_{\text{react}} = \sin(\text{squash\_t} \times 180^\circ) \times 0.12 \times \text{squash\_t}$$
$$\text{Factor Deglución: } \Delta_{\text{chew}} = \sin\left(\frac{\text{chew\_timer}}{20} \times 180^\circ\right) \times 0.07$$

#### Escalas Resultantes:
$$\text{Escala Horizontal: } S_x = \text{base\_scale} \times (1 - \Delta_{\text{breath}} + \Delta_{\text{react}} + \Delta_{\text{chew}})$$
$$\text{Escala Vertical: } S_y = \text{base\_scale} \times (1 + \Delta_{\text{breath}} - \Delta_{\text{react}} - \Delta_{\text{chew}})$$

> **Ley de Conservación de Volumen:** Observa que cuando $S_y$ se expande, $S_x$ se contrae en la misma proporción, emulando la física elástica de los cuerpos de gelatina o caricatura.

---

### 3. Máquina de Estados de Emociones (`enum PouEmocion`)
Pou cuenta con 6 expresiones faciales reflejadas directamente en los frames de `spr_pou_emociones`:

```gml
enum PouEmocion {
    Normal     = 0, // Mirada tranquila, boca neutra
    Feliz      = 1, // Ojos brillantes, sonrisa abierta amplia
    Serio      = 2, // Ojos entrecerrados, expresión neutral
    Triste     = 3, // Ojos caídos, boca curvada hacia abajo
    Hambriento = 4, // Boca abierta pidiendo alimento
    Enfermo    = 5  // Ojos mareados, mejillas con malestar
}
```

#### Reglas de Transición Automática de Emociones:
En `obj_pou/Step_0.gml`, cada 180 frames (3 segundos a 60 FPS), el juego evalúa las estadísticas vitales para determinar la emoción predominante:
1. Si `global.pou_salud < 35`: Transición a **`Enfermo`**.
2. Si `global.pou_hambre < 30`: Transición a **`Hambriento`**.
3. Si `global.pou_energia < 25` o `global.pou_diversion < 30`: Transición a **`Triste`**.
4. Si todas las necesidades están por encima del 75%: Transición a **`Feliz`**.
5. En cualquier otro caso: Transición a **`Normal`**.

---

### 4. Sistema de Manchas de Suciedad Dinámicas
En lugar de cambiar simplemente el color de Pou a marrón, el juego simula manchas de lodo procedurales e independientes:

```gml
global.pou_dirt_spots = [
    { ox: -70, oy: -210, r: 24, dirty: 1.0 }, // Frente izquierda
    { ox:  65, oy: -195, r: 21, dirty: 1.0 }, // Frente derecha
    { ox: -125, oy: -120, r: 27, dirty: 1.0 }, // Costado izquierdo
    { ox:  120, oy: -115, r: 25, dirty: 1.0 }, // Costado derecho
    { ox:  -50, oy:  -40, r: 24, dirty: 1.0 }, // Abdomen izquierdo
    { ox:   55, oy:  -35, r: 25, dirty: 1.0 }  // Abdomen derecho
];
```

Cada mancha se dibuja con 3 círculos concéntricos (borde oscuro, relleno chocolate y brillo specular) y su posición relativa se multiplica por la escala elástica de Pou para que se mueva orgánicamente al respirar.

---

### 5. Calibración Anatómica Milimétrica de Accesorios
Para solucionar el histórico problema donde sombreros y lentes se desfasaban o flotaban sobre la boca, se midieron los centros ópticos reales en píxeles:

| Accesorio | Altura Relativa al Origen ($Y=360$) | Fórmula en Código GML | Escala Recomendada |
| :--- | :--- | :--- | :--- |
| **Lentes** | $Y_{\text{ojos}} = -228.5$ px | `y + jump_y - 228.5 * _sy` | `_sx * 0.72, _sy * 0.72` |
| **Bigotes** | $Y_{\text{bigote}} = -173.0$ px | `y + jump_y - 173.0 * _sy` | `_sx * 0.75, _sy * 0.75` |
| **Ropa / Pajaritas** | $Y_{\text{cuello}} = -95.0$ px | `y + jump_y - 95.0 * _sy` | `_sx * 0.85, _sy * 0.85` |
| **Sombreros Estándar** | $Y_{\text{cabeza}} = -330.0$ px | `y + jump_y - 330.0 * _sy` | `_sx * 0.78, _sy * 0.78` |
| **Sombrero Bruja / Fiesta**| $Y_{\text{cabeza}} = -345.0$ px | `y + jump_y - 345.0 * _sy` | `_sx * 0.80, _sy * 0.80` |
| **Galera Copa** | $Y_{\text{cabeza}} = -320.0$ px | `y + jump_y - 320.0 * _sy` | `_sx * 0.76, _sy * 0.76` |
