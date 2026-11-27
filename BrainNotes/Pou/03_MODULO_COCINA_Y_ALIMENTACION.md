# Módulo 03: Módulo de Cocina y Alimentación
## Mecánicas de Drag & Drop, Ingestión por Mordiscos y Gestión de Saciedad

---

### 1. Visión General del Módulo (`obj_cocina`)
En la cocina (`rm_cocina`), el jugador tiene como objetivo principal alimentar a Pou para restaurar su barra de **Hambre** (`global.pou_hambre`) y su **Salud** (`global.pou_salud`).

El módulo se compone de:
1. **La Nevera Interactiva:** Un gabinete refrigerador con animación de apertura que alberga el catálogo de alimentos.
2. **El Alimento Físico:** Un objeto que el usuario puede tomar y arrastrar libremente por la pantalla hacia la boca de Pou.
3. **Mecánica de Mordiscos Graduales:** Los alimentos no desaparecen de golpe; se consumen en 3 mordiscos sucesivos con encogimiento elástico.

---

### 2. Catálogo de Alimentos de la Nevera
El catálogo ofrece 10 variedades de alimentos con distintos aportes calóricos y de salud:

```gml
fridge_items = [
    { name: "Manzana",    sprite: spr_food_apple,      nutricion: 18, salud: 5 },
    { name: "Platano",    sprite: spr_food_banana,     nutricion: 15, salud: 4 },
    { name: "Brocoli",    sprite: spr_food_broccoli,   nutricion: 12, salud: 10 },
    { name: "Hamburguesa",sprite: spr_food_burger,     nutricion: 35, salud: -2 },
    { name: "Zanahoria",  sprite: spr_food_carrot,     nutricion: 14, salud: 6 },
    { name: "Pastel",     sprite: spr_food_cheesecake, nutricion: 30, salud: -3 },
    { name: "Cerezas",    sprite: spr_food_cherries,   nutricion: 10, salud: 4 },
    { name: "Pollo",      sprite: spr_food_chicken,    nutricion: 32, salud: 3 },
    { name: "Dona",       sprite: spr_food_donut,      nutricion: 25, salud: -2 },
    { name: "Jugo",       sprite: spr_food_juice,      nutricion: 16, salud: 4 }
];
```

---

### 3. Física de Arrastre Táctil (Drag & Drop)
Cuando el jugador toca un alimento en la mesa o lo selecciona de la nevera:
- `dragging = true`: El alimento sigue directamente las coordenadas del cursor (`mouse_x, mouse_y`).
- Se le aplica una escala ligeramente mayor ($1.15 \times$) y una rotación dinámica suave proporcional a la velocidad del ratón para dar sensación de ligereza.
- Si el jugador suelta el alimento lejos de la boca de Pou, el alimento regresa suavemente a su posición de descanso sobre el plato mediante una interpolación lineal (**`lerp`**):
  $$X_{t+1} = \text{lerp}(X_t, X_{\text{home}}, 0.2)$$
  $$Y_{t+1} = \text{lerp}(Y_t, Y_{\text{home}}, 0.2)$$

---

### 4. Detección de Colisión con la Boca de Pou
La boca de Pou se ubica anatómicamente a:
$$X_{\text{boca}} = \text{pou.x}$$
$$Y_{\text{boca}} = \text{pou.y} - 173 \times S_y$$

Cuando la distancia entre el alimento y la boca es menor a 70 píxeles:
$$\text{point\_distance}(X_{\text{comida}}, Y_{\text{comida}}, X_{\text{boca}}, Y_{\text{boca}}) \le 70$$

Se activa el ciclo de ingestión:
1. **Comprobación de Saciedad:**
   - Si `global.pou_hambre >= 100`: Pou rechaza el alimento. Cierra la boca, activa una animación de negación con la cabeza (`head_shake_x = sin(...) * 18`) y emite el sonido característico de disgusto `snd_no`.
2. **Fases de Mordisco:**
   - Si tiene hambre, cada contacto efectivo descuenta un mordisco (`bites_left--`).
   - Se reproduce aleatoriamente un sonido de mordisco (`snd_comer`, `snd_comer2`, `snd_comer3`).
   - Se activan partículas de migajas volando alrededor de la boca.
   - Pou entra en estado de deglución (`pou.chew_timer = 20`), comprimiendo y expandiendo su cuello rítmicamente.
   - La comida se escala al $66\%$ en el primer mordisco, al $33\%$ en el segundo, y al tercero se consume por completo.
3. **Actualización de Estadísticas:**
   - `global.pou_hambre = min(100, global.pou_hambre + item.nutricion);`
   - `global.pou_salud  = clamp(global.pou_salud + item.salud, 0, 100);`
