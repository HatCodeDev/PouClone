# Módulo 09: Guía de Defensa y Preguntas de Examen
## Banco de Preguntas Técnicas, Justificaciones de Diseño y Respuestas Clave

---

### Pregunta 1: ¿Por qué los accesorios de Pou se veían caídos o superpuestos en la boca en versiones anteriores y cómo se solucionó matemáticamente?
**Respuesta:**
En `obj_pou/Draw_0.gml`, la fórmula vertical dividía el offset por la escala base (`y + jump_y - 228 * (_sy / base_scale)`). Como `base_scale = 1.2`, el término `_sy / base_scale` se cancelaba a $1.0$. Pou se escalaba a $1.2$ pero los accesorios se posicionaban como si Pou tuviera escala $1.0$, generando un desfase hacia abajo de **$46.2$ píxeles** en los lentes (quedando sobre la boca) y de **$30$ píxeles** en los sombreros (tapando los ojos).

Se corrigió midiendo los centros anatómicos del sprite de $500 \times 360$ px y multiplicando directamente por la escala elástica vertical real $\_sy$:
- **Lentes (Centro Ocular):** `y + jump_y - 228.5 * _sy` (escala $0.72$).
- **Sombreros (Corona Superior):** `y + jump_y - _hat_y_off * _sy` ($320..345$ px según modelo).
- **Bigote:** `y + jump_y - 173.0 * _sy` (escala $0.75$).
- **Pajarita / Ropa:** `y + jump_y - 95.0 * _sy` (escala $0.85$).

---

### Pregunta 2: ¿Cómo garantiza el minijuego de memoria que el barajado de cartas sea completamente imparcial y no se repitan parejas indebidas?
**Respuesta:**
Se implementa el **Algoritmo de Barajado Fisher-Yates (Knuth Shuffle)** en `obj_minigame_memory/Create_0.gml`.
Se genera un array lineal de 16 posiciones con exactamente 2 copias de cada uno de los 8 identificadores (`pair_id = 0..7`). Luego se itera en reversa desde el índice $n-1$ hasta $1$, intercambiando cada elemento con una posición aleatoria $j \in [0, i]$. Este algoritmo garantiza una permutación equiprobable con complejidad temporal lineal $O(n)$ sin sesgo de memoria.

---

### Pregunta 3: ¿Qué técnica se utilizó para simular el volteo 3D de las cartas en el memorama si GameMaker es un motor 2D?
**Respuesta:**
Se utiliza una deformación geométrica cosenoidal en la escala horizontal ($S_x$) controlada por la variable continua `flip_phase`:
$$S_x = \cos(\text{flip\_phase} \times 180^\circ)$$
A la mitad de la transición (`flip_phase = 0.5`), la carta alcanza un ancho aparente de $0$ píxeles (el canto de la carta). En ese instante exacto se intercambia la textura que se renderiza: antes de $0.5$ se dibuja el reverso (`spr_carta_atras`) y a partir de $0.5$ se dibuja el anverso con la figura (`spr_carta_frente`). Esto produce una ilusión visual de rotación sobre el eje Y tridimensional idéntica a una carta física.

---

### Pregunta 4: ¿Cómo se resolvió el problema del "tunneling" o alimentos que atravesaban la boca de Pou a alta velocidad en Food Drop?
**Respuesta:**
En arcades de caída rápida, si la velocidad supera los 10 px/frame, un objeto puede pasar de $Y = 970$ a $Y = 985$ entre dos frames consecutivos sin haber estado en el píxel exacto de colisión.
Para solucionarlo, la detección de colisión en `obj_minigame_food/Step_0.gml` no verifica un solo punto, sino un **volumen continuo de intercepción**:
```gml
var _dx = abs(_f.x - pou_x);
if (_dx <= 85 && _f.y >= 980 && _f.y <= 1115) {
    // Captura garantizada
}
```
Además, la escala de Pou se redujo de $1.15$ ($575$ px) a $0.48$ ($170$ px), proporcionando al jugador una hitbox justa y ágil para reaccionar.

---

### Pregunta 5: ¿Cómo funciona la arquitectura de persistencia entre las 4 habitaciones y los 2 minijuegos?
**Respuesta:**
A través de un sistema de variables globales centralizadas (`global.pou_hambre`, `global.pou_salud`, `global.pou_diversion`, `global.pou_energia`, `global.pou_monedas`).
El objeto de navegación `obj_nav` y el HUD se instancian en cada habitación o son persistentes, consultando y actualizando las mismas variables globales. Cuando el jugador gana monedas o diversión en un minijuego, estas se acumulan directamente en las variables globales, de modo que al regresar a la sala mediante `room_goto(rm_sala)` el progreso persiste intacto.

---

### Pregunta 6: ¿Por qué ocurría el error de GameMaker con `$GMSprite` en los archivos `.yy` y cómo se previene?
**Respuesta:**
Los archivos `.yy` de GameMaker son archivos JSON enriquecidos que requieren campos de metadatos de tipo al inicio de cada registro (ejemplo: `"$GMSprite": "v2"`, `"$GMSequence": "v1"`).
Al generar archivos con herramientas de terminal en entornos Linux/Bash, si la cadena JSON no se aísla de la expansión de variables de Bash, este interpreta `$GMSprite` como una variable de entorno vacía y la sustituye por `""`. Al leer el JSON, GameMaker no encuentra el Type Tag y arroja el error de parsing. La solución es asegurar que todos los `$TypeTags` se escriban literalmente sin evaluación de variables.
