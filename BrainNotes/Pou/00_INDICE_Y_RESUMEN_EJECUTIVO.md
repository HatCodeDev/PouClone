# Guía de Estudio y Documentación Técnica: PouClone
## Índice General y Resumen Ejecutivo del Proyecto

---

### 1. Resumen Ejecutivo
**PouClone** es una recreación móvil y de escritorio de alta fidelidad del clásico videojuego virtual pet **Pou**, desarrollada en **GameMaker 2024.14.4** utilizando **GML (GameMaker Language)**. El proyecto reproduce con precisión matemática y artística las mecánicas centrales del juego original:
- Ciclo de vida y necesidades vitales de la mascota virtual (Hambre, Salud, Diversión, Energía).
- Expresiones faciales y estados de ánimo dinámicos (Normal, Feliz, Serio, Triste, Hambriento, Enfermo).
- Cuatro habitaciones completas e interconectadas: **Sala**, **Cocina**, **Baño (Ducha)** y **Dormitorio**.
- Dos minijuegos completamente jugables con HUD, estados, combos, récords y economía: **Atrapar Comida (Food Drop)** y **Juego de Memoria (Memorama)**.
- Un sistema de personalización y probador en vivo con **11 nuevos accesorios** en 4 categorías (Sombreros, Lentes, Ropa/Pajaritas, Bigotes) con alineación anatómica milimétrica.
- Código limpio, modular, documentado y libre de advertencias de linter (**0 Errores, 0 Warnings en Feather**).

---

### 2. Matriz de Cumplimiento de la Rúbrica de Evaluación

| Criterio de la Rúbrica | Implementación en PouClone | Archivos Clave | Estado |
| :--- | :--- | :--- | :--- |
| **Arquitectura de Escenas** | 4 habitaciones principales + 2 salas de minijuegos con navegación fluida por botones superiores | `rm_sala`, `rm_cocina`, `rm_bano`, `rm_dormitorio`, `rm_minigame_*`, `obj_nav` | **Cumplido 100%** |
| **Gestión de Estados y Necesidades** | 4 barras de progreso dinámicas, decaimiento por tiempo y recuperación por acciones | `global.pou_hambre`, `pou_salud`, `pou_diversion`, `pou_energia`, `obj_nav/Draw_0.gml` | **Cumplido 100%** |
| **Física y Reactividad del Personaje** | Respiración sinusoide, squash & stretch al clic, deglución suave, parpadeo y negación con cabeza | `obj_pou/Create_0.gml`, `obj_pou/Step_0.gml`, `obj_pou/Draw_0.gml` | **Cumplido 100%** |
| **Alimentación y Cocina** | Nevera interactiva con 10 alimentos, arrastre táctil, mordiscos por colisión con boca, rechazo si está lleno | `obj_cocina/Create_0.gml`, `Step_0.gml`, `Draw_0.gml` | **Cumplido 100%** |
| **Baño e Higiene** | Manchas de suciedad dinámicas, enjabonado con generación de burbujas, enjuague con ducha móvil | `obj_bano/Create_0.gml`, `Step_0.gml`, `Draw_0.gml` | **Cumplido 100%** |
| **Dormitorio, Lámpara y Sueño** | Lámpara interactiva ON/OFF, oscuridad de cuarto, párpados cerrados, partículas Zzz y recarga de energía | `obj_dormitorio/Create_0.gml`, `Step_0.gml`, `Draw_0.gml` | **Cumplido 100%** |
| **Armario y Personalización** | Probador en vivo con Pou reactivo, 4 pestañas, 11 accesorios nuevos, toggle equipar/desequipar y paginación | `obj_dormitorio/Step_0.gml`, `Draw_0.gml`, `obj_pou/Draw_0.gml` | **Cumplido 100%** |
| **Minijuego 1: Food Drop** | Máquina de estados (Ready, Playing, Paused, GameOver), spawner progresivo, 4 vidas, combos, High Score | `obj_minigame_food/Create_0.gml`, `Step_0.gml`, `Draw_0.gml` | **Cumplido 100%** |
| **Minijuego 2: Memorama** | Barajado Fisher-Yates, 16 cartas, animación de volteo 3D cosenoidal, contador de intentos y récords | `obj_minigame_memory/Create_0.gml`, `Step_0.gml`, `Draw_0.gml` | **Cumplido 100%** |
| **Economía de Monedas** | Ganancia de monedas en minijuegos, recompensas por acierto, persistencia global y UI en HUD | `global.pou_monedas`, `obj_nav/Draw_0.gml` | **Cumplido 100%** |
| **Calidad de Código y Estilo** | Tipado Feather limpio (GM2044 solucionado), nombres semánticos, constantes ASCII para fuentes | Todos los archivos GML | **Cumplido 100%** |

---

### 3. Estructura de los Documentos de Estudio

Esta carpeta de documentación se compone de 10 módulos técnicos diseñados para servir como material de estudio y defensa de proyecto:

- **[01. Arquitectura y Motor GameMaker](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/01_ARQUITECTURA_Y_MOTOR_GAMEMAKER.md):** Estructura del proyecto, ciclo de eventos, capas, resolución nativa (720x1280) y persistencia global.
- **[02. Pou: Estados, Física y Emociones](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/02_POU_ESTADOS_FISICA_Y_EMOCIONES.md):** Anatomía matemática, animaciones sinusoidales, colisiones y máquina de emociones.
- **[03. Módulo de Cocina y Alimentación](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/03_MODULO_COCINA_Y_ALIMENTACION.md):** Drag & drop, detección de ingestión por proximidad a la boca, fases de mordiscos y saciedad.
- **[04. Módulo de Baño y Limpieza](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/04_MODULO_BANO_Y_LIMPIEZA.md):** Fricción del jabón, sistema de partículas de espuma y chorro de agua de ducha.
- **[05. Módulo de Dormitorio, Sueño y Armario](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/05_MODULO_DORMITORIO_SUENO_Y_ARMARIO.md):** Ciclo circadiano, oscurecimiento, probador en vivo y alineación trigonométrica de ropa.
- **[06. Minijuego: Atrapar Comida (Food Drop)](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/06_MINIJUEGO_ATRAPAR_COMIDA.md):** Detección continua de colisiones, curvas de aceleración, corazones de vida y economía.
- **[07. Minijuego: Juego de Memoria (Memorama)](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/07_MINIJUEGO_MEMORAMA_PAREJAS.md):** Algoritmo de barajado Fisher-Yates, proyección 3D simulada en 2D y lógica de turnos.
- **[08. Sistema UI, Sonido y Optimizaciones](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/08_SISTEMA_UI_SONIDO_Y_OPTIMIZACIONES.md):** Renderizado de HUD, compatibilidad de fuentes ASCII, audio procedural y depuración Feather.
- **[09. Guía de Defensa y Preguntas de Examen](file:///C:/Users/misae/OneDrive/Documentos/BrainNotes/Pou/09_GUIA_DE_DEFENSA_Y_PREGUNTAS_EXAMEN.md):** Banco de preguntas clave con respuestas técnicas fundamentadas en el código fuente.
