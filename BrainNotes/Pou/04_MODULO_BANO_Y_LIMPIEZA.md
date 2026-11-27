# Módulo 04: Módulo de Baño y Limpieza
## Fricción del Jabón, Generación de Burbujas y Enjuague por Ducha

---

### 1. Visión General del Módulo (`obj_bano`)
En el baño (`rm_bano`), Pou llega acumulando suciedad (`global.pou_suciedad`) representada por manchas de lodo en su cuerpo. 

La mecánica de higiene consta de **dos fases complementarias**:
1. **Fase 1: Enjabonar:** Pasar el jabón sobre las manchas para cubrirlas de espuma y disolver el lodo.
2. **Fase 2: Enjuagar:** Acercar la regadera o ducha para que el chorro de agua retire la espuma y el lodo, dejando a Pou reluciente.

---

### 2. Mecánica del Jabón (`spr_jabon`)
El jabón reposa en la repisa izquierda a $(X=180, Y=1110)$.

#### Algoritmo de Detección de Fricción:
Cuando el jugador arrastra el jabón con el ratón sobre el cuerpo de Pou:
$$\text{point\_in\_triangle o distancia con el centro de Pou} \le 160 \text{ px}$$

- Si el ratón se mueve con suficiente velocidad ($\Delta_{\text{mouse}} > 2$ px):
  - Pou emite el sonido de cosquillas/frote `snd_pou_rascar`.
  - Se generan partículas de espuma y burbujas (`spr_burbujas`) en las coordenadas del contacto.
  - Para cada mancha en `global.pou_dirt_spots`, si el jabón pasa cerca de ella ($\text{distancia} \le 50$ px), el nivel de suciedad de esa mancha individual decrece progresivamente:
    $$\text{spot.dirty} = \max(0, \text{spot.dirty} - 0.04)$$

---

### 3. Sistema de Partículas de Burbujas de Espuma
Las burbujas generadas no son estáticas. Cada burbuja creada en el array `bubbles` posee su propio comportamiento físico:

```gml
array_push(bubbles, {
    x: soap_x + random_range(-20, 20),
    y: soap_y + random_range(-15, 15),
    vx: random_range(-0.5, 0.5),
    vy: random_range(-1.2, -0.4),  // Flotabilidad ascendente suave
    scale: random_range(0.4, 0.8),
    alpha: 1.0,
    life: irandom_range(60, 110)
});
```

En cada frame, las burbujas flotan suavemente hacia arriba, oscilan ligeramente y se desvanecen con `alpha` decreciente hasta morir.

---

### 4. Mecánica de la Ducha Móvil (`spr_ducha`)
La ducha reposa en el soporte derecho a $(X=540, Y=1110)$.

Al tomarla y colocarla por encima de Pou ($Y_{\text{ducha}} < Y_{\text{pou}} - 80$):
- La alcachofa de la ducha comienza a emitir un chorro continuo de gotas de agua azul translúcida.
- Se reproduce en loop el sonido de agua corriendo `snd_pou_beber`.
- Las gotas de agua caen con aceleración vertical ($V_y = 12$ px/frame).
- Al colisionar las gotas de agua con el cuerpo de Pou:
  - Explotan en pequeñas salpicaduras.
  - Arrastran y eliminan todas las burbujas de espuma activas.
  - Disminuyen rápidamente la suciedad global:
    $$\text{global.pou\_suciedad} = \max(0, \text{global.pou\_suciedad} - 0.6)$$

#### Feedback de Limpieza Completa:
Cuando `global.pou_suciedad` llega a 0:
- Todas las manchas se apagan por completo (`dirty = 0`).
- Pou emite destellos brillantes blancos (specular stars).
- Salta de alegría con `snd_pou_salto` y pasa automáticamente a la emoción **`Feliz`**.
- El jugador recibe una bonificación de salud y diversión.
