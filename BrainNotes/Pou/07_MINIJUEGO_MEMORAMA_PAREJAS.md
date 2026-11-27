# Módulo 07: Minijuego: Juego de Memoria (Memorama)
## Algoritmo Fisher-Yates, Volteo 3D Cosenoidal y Lógica de Emparejamiento

---

### 1. Visión General del Minijuego (`obj_minigame_memory`)
Ubicado en `rm_minigame_memory`. Es un clásico juego mental de concentración y emparejamiento de cartas (**Memory Match**). Presenta un tablero de $4 \times 4$ cartas (16 cartas en total, correspondientes a 8 parejas idénticas de figuras de Pou y alimentos).

---

### 2. Algoritmo de Barajado Fisher-Yates
Para garantizar una distribución perfectamente aleatoria y matemáticamente imparcial de las cartas en cada partida, se implementa el algoritmo **Fisher-Yates Shuffle**:

```gml
// 1. Inicializar lista con 8 parejas duplicadas (16 elementos)
var _deck = [];
for (var _p = 0; _p < 8; _p++) {
    array_push(_deck, _p);
    array_push(_deck, _p);
}

// 2. Barajado Fisher-Yates (O(n) complejidad lineal)
for (var _i = array_length(_deck) - 1; _i > 0; _i--) {
    var _j = irandom(_i);
    var _temp = _deck[_i];
    _deck[_i] = _deck[_j];
    _deck[_j] = _temp;
}
```

Cada posición del array barajado se asigna a una celda de la matriz de cartas con su respectivo identificador de figura (`pair_id`).

---

### 3. Efecto Visual de Volteo 3D Cosenoidal (`flip_phase`)
En lugar de voltear las cartas instantáneamente (lo cual se ve tosco y plano), el motor simula una rotación tridimensional en el eje Y en 2D:

- La variable `flip_phase` evoluciona suavemente de $0.0$ a $1.0$ a lo largo de 12 frames.
- La escala horizontal efectiva de la carta ($S_x$) se calcula mediante la función coseno:
  $$S_x = \cos(\text{flip\_phase} \times 180^\circ)$$
- **Transición de Textura en el Vértice ($S_x = 0$):**
  - Si $\text{flip\_phase} < 0.5$: Se dibuja el reverso de la carta (`spr_carta_atras`).
  - Si $\text{flip\_phase} \ge 0.5$: Se dibuja el frente blanco de la carta (`spr_carta_frente`) junto con el icono del alimento/juguete centrado.

El resultado es un efecto de rotación de naipes de casino 100% fluido y natural.

---

### 4. Lógica de Selección y Validación de Parejas
El sistema maneja un estado de selección de hasta 2 cartas a la vez:

1. **Primer Clic:**
   - La carta 1 se voltea hacia arriba.
   - Se reproduce el sonido de volteo `snd_click`.
2. **Segundo Clic:**
   - La carta 2 se voltea hacia arriba.
   - El contador de intentos (`moves_count`) se incrementa en $+1$.
   - Se bloquea la interacción del tablero temporalmente mientras se evalúa el resultado.
3. **Evaluación:**
   - **Caso A (Acierto):** Si `card1.pair_id == card2.pair_id`:
     - Ambas cartas se marcan como resueltas permanentemente (`matched = true`).
     - Se reproduce el sonido triunfal `snd_acierto` y `snd_match`.
     - El jugador recibe $+5$ Monedas inmediatas.
     - Se enciende uno de los 8 indicadores circulares en la pastilla de estado.
     - `matched_pairs++`.
   - **Caso B (Fallo):** Si `card1.pair_id != card2.pair_id`:
     - Se reproduce el sonido suave de error `snd_pitch1`.
     - Se inicia un temporizador de espera de 35 frames (0.6 segundos) para que el jugador memorice las posiciones.
     - Ambas cartas se voltean automáticamente boca abajo.

---

### 5. Condición de Victoria y Registro de Récords
Cuando `matched_pairs == 8`:
- El juego cambia al estado `state_victory`.
- Pou salta de alegría en la parte superior.
- Se otorga un bonus especial de $+10$ Monedas.
- La **Diversión** de Pou se recarga al $100\%$ (`global.pou_diversion = 100`).
- **Gestión de Récord:** Si el número de intentos realizados es menor que el récord histórico (`global.memory_best_moves == 0 || moves_count < global.memory_best_moves`), se actualiza como la mejor marca de la partida.
