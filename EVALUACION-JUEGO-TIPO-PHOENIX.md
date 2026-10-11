# Evaluación — Juego de naves al estilo *Phoenix* (1980), con teclado, ratón y mando, en 2K y 4K

| Campo | Valor |
|---|---|
| Proyecto | JUEGOS (`D:\NEGOCIO\SOFTWARE\JUEGOS`) |
| Para | Christian Velarde Valdez |
| Fecha | 2026-10-11 |
| Versión del informe | 1.0 |
| Estado | **Evaluación. No se programó nada** |

> **Aviso de formato.** Este informe todavía no sigue `ESTRUCTURA-INFORMES.md`, porque no tengo
> acceso a ese documento (`ESTADO-Y-CONTINUIDAD.md`, P1).

---

## 1. Resumen

- **Se puede hacer, y se verá nítido en 2K y 4K.** Es un juego de pocos objetos en pantalla, así que el
  rendimiento no es el problema. La nitidez la da el escalado entero ya propuesto.
- **No puede ser «Phoenix».** Las reglas del proyecto prohíben copiar el nombre, el arte, los sonidos y
  la marca de un juego comercial. Propongo un **juego original del mismo género**: nave abajo, escudo,
  oleadas de aves y una nave nodriza. Tendría nombre, arte y sonido propios, y diferencias de diseño
  deliberadas (§2).
- **Estimación (criterio propio, sin calibrar):**

| Alcance | Mi trabajo | Tu tiempo | Calendario |
|---|---|---|---|
| **A. Mínimo jugable:** 1 tipo de ave + nodriza simple, 3 controles, 2K/4K, pruebas de los 4 niveles | 15–22 h | 4–6 h | 1–2 semanas |
| **B. Completo:** 5 oleadas, récords, menú de opciones, CRT, teclas configurables, guardado, ejecutable para Windows | **30–50 h** | **8–14 h** | **3–5 semanas** |
| **C. Pulido:** música, más animación, ajuste fino de dificultad | B + 15–30 h | B + 4–8 h | B + 1–2 semanas |

- **El calendario lo marca el ciclo contigo, no mi velocidad de escritura.** Tú decides, descargas,
  pruebas en tu monitor y con tu mando, y juegas para ajustar la sensación. Cada vuelta de ese ciclo
  pesa más que cualquier tramo de código.
- **Requisito previo** (no incluido arriba): que elijas la tecnología y autorices las descargas
  (`PROPUESTA-TECNOLOGIA.md` §10). La estimación supone **Pygame-ce**. Con Godot 4 el total sería
  parecido, ±20 %: el editor ahorra tiempo en presentación y las pruebas de imagen lo cuestan.

---

## 2. Derechos: qué se puede tomar y qué no

*Phoenix* (1980) es un juego comercial de Amstar Electronics, distribuido por Centuri y Taito. **No soy
abogado**; esto es criterio propio para no exponer el proyecto.

| Se puede (es género) | No se puede (es expresión o marca) |
|---|---|
| Nave que se mueve en horizontal abajo y dispara hacia arriba | El nombre «Phoenix» o uno parecido |
| Escudo temporal que inmoviliza la nave | Los sprites, colores y formas originales, incluso redibujados «parecidos» |
| Enemigos voladores que bajan en picada | Los sonidos y la música originales |
| Un jefe grande con capas que hay que perforar | Cualquier ROM, captura o recurso extraído |
| Oleadas con dificultad creciente | Reproducir pantalla por pantalla la secuencia exacta de oleadas y el aspecto del original |

**Por qué la última fila importa:** copiar el «aspecto y la sensación» completos de un juego ya trajo
problemas legales a otros clones (el caso de Tetris contra Xio en EE. UU., 2012). Para no quedar en esa
zona, propongo cambiar al menos esto:
- **tema y arte propios** (por ejemplo, insectos, drones o espíritus en vez de aves);
- **un orden de oleadas y unas reglas propias** (por ejemplo, el escudo se recarga con una barra en
  vez de un tiempo fijo, o los enemigos grandes pierden piezas distintas);
- **nombre propio.**

---

## 3. Qué hay que construir

### 3.1 El juego (lógica, sin dibujar, con pruebas unitarias)

| Pieza | Dificultad | Notas |
|---|---|---|
| Nave, disparo, escudo con espera de recarga | Baja | El escudo inmoviliza, así que ningún control (ni el ratón) puede moverla mientras está activo |
| Oleada de enemigos pequeños: formación, aleteo, picadas, disparos | Media | Trayectorias en enteros con subpíxeles (ADR-006) para que la repetición sea exacta |
| Oleada de enemigos grandes: nacen de un huevo y tienen partes destructibles que se regeneran | **Media-alta** | Varias zonas de choque por enemigo. Es la pieza que más pruebas pide |
| Nave nodriza: capas que se perforan por bloques y un piloto como blanco | **Media-alta** | Destrucción por celdas; el estado de la nodriza entra en la huella de la repetición |
| Puntaje, vidas, vida extra, ciclo de oleadas con dificultad creciente | Baja | |
| Azar sembrado y repetición de partidas | Baja (la base ya lo prevé) | |

### 3.2 Los controles: teclado, ratón y mando

Los tres se traducen a las **mismas acciones** (izquierda, derecha, disparar, escudo), que es lo que
recibe la lógica. Así una partida grabada se reproduce igual con cualquier control.

| Control | Propuesta | Atención |
|---|---|---|
| Teclado | Flechas o A/D; disparo y escudo configurables | Nada especial |
| **Ratón** | La nave **persigue** la posición X del ratón a su velocidad máxima; clic izquierdo dispara, clic derecho activa el escudo | Si la nave saltara a la posición del ratón, este daría ventaja y el juego no sería justo; por eso persigue. Además, el ratón se convierte a coordenadas lógicas descontando la escala y las bandas negras, y eso se prueba |
| **Mando USB y Bluetooth** | Cruceta o palanca; botones configurables | Se prueba en tu estación con tu mando real; en la nube no hay mandos |
| Cambio en caliente | Se usa el último control que se tocó | |

### 3.3 Resolución: para este juego conviene 640×360, no 320×180

*Phoenix* es de **pantalla vertical**: el campo de juego es más alto que ancho. Para que la escala sea
exacta en 1080p, 1440p y 2160p, la altura interna tiene que dividir a 360, así que solo sirven 180 o
360:

| Opción | Campo de juego vertical | Escala 1080p / 1440p / 2160p | Veredicto |
|---|---|---|---|
| 320×180 | Como mucho 144×180: naves de unos 8 px, demasiado chicas | ×6 / ×8 / ×12 exactas | Descartada para este juego |
| **640×360** | **288×360**, con la misma proporción que el original (0,8). Quedan 176 px a cada lado para puntaje, vidas y arte | **×3 / ×4 / ×6 exactas** | **Recomendada** |
| 208×256 (tamaño del original) | 208×256 | ×4 / ×5 / ×8 con bandas extra | Inexacta; descartada |

Esto **no contradice** la propuesta general de 320×180: la resolución se decide **por juego**, y cada
juego vive en su propia carpeta (ADR-002). Queda como ADR-008 (propuesta).

**En 2K y 4K:** cada píxel lógico ocupa un bloque de 4×4 en 1440p y de 6×6 en 2160p, idéntico y sin
borroso. El filtro CRT se ve mejor en 4K, porque hay 6 líneas físicas por línea lógica para dibujar
las líneas de barrido.

### 3.4 Lo demás

Pantalla de título, pausa, tabla de récords con iniciales (que se escriban con los tres controles),
menú de opciones (CRT, pantalla completa sin bordes, volumen y teclas configurables), guardado de
récords y configuración con versión y escritura atómica, y ejecutable para Windows.

### 3.5 Arte y sonido originales

| Opción | Calidad | Tiempo |
|---|---|---|
| **Los genero yo:** sprites como datos o scripts que producen PNG; efectos de sonido sintetizados por código, al estilo *sfxr* | Correcta y coherente, sin firma artística | Incluido en la estimación (unas 4–8 h) |
| Los hace un artista o los compras con licencia libre declarada | Mejor | Aparte; depende de la persona o de la licencia |

---

## 4. Desglose de la estimación (alcance B, completo)

| # | Tramo | Mi trabajo | Tu parte |
|---|---|---|---|
| 0 | Elegir tecnología, autorizar descargas y darme acceso a los documentos | — | 1–2 h |
| 1 | Base técnica en `COMUN\`: ventana, escala entera, bandas, paso fijo, entrada con 3 controles, DPI de Windows, **medición en 4K**, arnés de pruebas de 4 niveles | 6–10 h | 1–2 h (correr en la estación, monitor 2K/4K, mando) |
| 2 | Lógica: nave, escudo, oleadas pequeñas, puntaje, vidas, repetición | 5–8 h | — |
| 3 | Lógica: enemigos grandes con partes y nave nodriza destructible | 6–10 h | — |
| 4 | Presentación: sprites, animación, explosiones, fondo de estrellas, marcador | 4–7 h | 1 h (aprobar el aspecto) |
| 5 | Arte y sonido generados (§3.5) | 4–8 h | 1 h (aprobar) |
| 6 | Menús, récords, opciones, CRT, guardado, teclas | 3–5 h | — |
| 7 | **Ajuste de jugabilidad**: velocidades, dificultad, sensación | 2–4 h | **3–5 h (jugar y opinar; es lo más incierto)** |
| 8 | Ejecutable para Windows, informe de pruebas, huella SHA-256 | 1–2 h | 1–2 h (probarlo en limpio) |
| | **Total B** | **≈ 31–54 h** (resumido como 30–50) | **≈ 9–14 h** |

**Supuestos:**
- La medición del tramo 1 sale bien. Si Pygame-ce no cumple 16,6 ms en 4K, se cambia a Godot 4 y se
  suman unas 4–8 h de reorientación.
- Cada tramo cierra con todas las pruebas en verde, informe y commit, como manda el encargo. Esa
  disciplina ya está incluida: es más o menos un 25–30 % del total.
- Tú respondes en uno o dos días. Si cada vuelta tarda una semana, el calendario se estira en
  proporción, aunque las horas no cambien.

---

## 5. Riesgos

| Riesgo | Efecto en la estimación | Mitigación |
|---|---|---|
| Que la «sensación» no convenza: picadas, ritmo, escudo | La parte más difícil de acotar; puede sumar 5–10 h | Ajustes en archivo de datos (sin tocar código) y repeticiones para comparar |
| Arte generado por código que no te guste | +4–10 h o un artista | Aprobar 2–3 sprites de muestra antes de hacer el resto |
| Pygame-ce no rinde en 4K | +4–8 h (cambio a Godot) | Se mide en el tramo 1, antes de escribir el juego |
| Mando Bluetooth con mapeo raro | +1–3 h | Prueba con tu mando en el tramo 1 |
| Sin acceso a los documentos del estándar | Retrabajo de formato | Que me los pases antes del tramo 1 |
| Semejanza excesiva con el original | Riesgo legal y rehacer arte | Las diferencias de §2 se definen antes del arte |

---

## 6. Qué tan confiable es esta estimación

- **Criterio propio, sin medir.** No hay todavía ningún tramo cerrado en este proyecto que me dé mi
  velocidad real con este estándar de pruebas.
- **La calibro al cerrar el tramo 1:** comparo las horas reales con las estimadas y te reenvío la
  estimación corregida antes de seguir.
- **Verificado:** la aritmética de escalas de §3.3. Las alturas que dividen exactamente a 1080, 1440
  y 2160 son las que dividen a 360 (el máximo común divisor), y 640×360 escala ×3, ×4 y ×6.

---

## 7. Lo que te toca decidir

1. **Alcance:** A (mínimo jugable), B (completo) o C (pulido).
2. **Tema y nombre propios**, o que te proponga 3 opciones.
3. **Arte y sonido:** los genero yo, o hay artista o recursos con licencia.
4. **Resolución para este juego:** 640×360 con campo vertical de 288×360 (recomendada).
5. Lo pendiente de antes: tecnología, descargas y acceso a los documentos compartidos.
