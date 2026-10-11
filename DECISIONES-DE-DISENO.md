# Decisiones de diseño — JUEGOS

Registro al estilo ADR. Cada decisión tiene su estado, su motivo, lo que se descartó y **lo que se rompe
si alguien la revierte sin saberlo**. Las decisiones no se borran: si una cambia, se marca como
**Reemplazada por ADR-nnn** y se agrega la nueva.

Estados posibles: **Propuesta** (espera a Christian), **Cerrada** (vigente), **Reemplazada**.

---

## ADR-001 — Documentación e implementación en la misma carpeta base y un solo repositorio git
- **Estado:** Cerrada (encargo de Christian, 2026-10-11).
- **Decisión:** la documentación y la implementación viven en `D:\NEGOCIO\SOFTWARE\JUEGOS`, que es la raíz
  de **un** repositorio git. Los commits se escriben en español.
- **Motivo:** el encargo lo indica así. Además, un solo repositorio permite que un commit selle a la
  vez la documentación y el código de una entrega.
- **Descartado:** un repositorio por juego. Haría falta coordinar varios repositorios para un cambio en
  la base común, y el estado general quedaría repartido.
- **Si se revierte sin saberlo:** las huellas y los commits del §7 de `ESTADO-Y-CONTINUIDAD.md` dejan de
  apuntar a un solo lugar.
- **En la nube:** la raíz del repositorio `dbaproniedperu-cris/dba` (rama
  `claude/retro-games-modern-resolution-lx4ps8`) **es** la carpeta `JUEGOS`. Al clonarlo en
  `D:\NEGOCIO\SOFTWARE\JUEGOS` queda todo en su sitio.

## ADR-002 — Cada juego en su propia carpeta dentro de la carpeta base
- **Estado:** Cerrada (instrucción de Christian, 2026-10-11).
- **Decisión:** `JUEGOS\<NOMBRE-JUEGO>\` contiene todo lo de ese juego: código, recursos, pruebas,
  informe de pruebas y su `LEEME.md`. En la raíz quedan solo los documentos generales (este archivo,
  `ESTADO-Y-CONTINUIDAD.md`, `LEEME.md`, propuestas) y, si hace falta, la base común (ADR-005).
- **Motivo:** así cada juego se construye, se prueba y se entrega por separado, y uno no rompe a otro.
- **Descartado:** un árbol único con todos los juegos mezclados (`src/juego1`, `src/juego2`…).
- **Si se revierte sin saberlo:** las pruebas y los topes de tamaño de un juego empiezan a medir a los
  demás, y no se puede entregar un juego sin arrastrar a los otros.
- **Convención propuesta:** las versiones se etiquetan por juego: `<juego>-vX.Y.Z`.

## ADR-003 — Fin de línea LF forzado con `.gitattributes`
- **Estado:** Cerrada (2026-10-11).
- **Decisión:** `* text=auto eol=lf`, y los binarios se marcan como `binary`.
- **Motivo:** cada entrega se sella con SHA-256. Git en Windows con `core.autocrlf=true` extrae los textos
  con CRLF, y la huella que se calcula en la estación no coincidiría con la sellada en otra máquina.
- **Descartado:** dejarlo a la configuración de cada máquina.
- **Si se revierte sin saberlo:** las huellas «fallan» en la estación aunque el contenido sea idéntico, y
  se pierde tiempo buscando una corrupción que no existe.

## ADR-004 — Resolución interna 320×180 con escalado entero y bandas negras
- **Estado:** **Propuesta** (ver `PROPUESTA-TECNOLOGIA.md` §4).
- **Decisión:** el juego dibuja a 320×180. Se presenta con la mayor escala entera que cabe en la
  pantalla, con vecino más cercano y bandas negras en el sobrante.
- **Motivo:** es exacta en 720p, 900p, 1080p, 1440p y 2160p (×4, ×5, ×6, ×8, ×12). Es la densidad de
  los 16 bits en 16:9 y tiene 4 veces menos píxeles que 640×360.
- **Descartado:** 640×360 (inexacta en 900p y con el píxel la mitad de grande); escalado fraccionario
  o bilineal (píxeles de distinto tamaño o borrosos).
- **Si se revierte sin saberlo:** todo el arte, las imágenes de referencia de las pruebas y los
  diseños de nivel quedan con una escala equivocada.

## ADR-005 — Base común copiada con versión, no referenciada
- **Estado:** **Propuesta** (criterio propio).
- **Decisión:** cuando haya código reutilizable (escalado, paso fijo, entrada, guardado, CRT), vivirá
  en `JUEGOS\COMUN\` con versión. Cada juego **copia** una versión fija a su carpeta y anota la versión
  y la huella de la copia.
- **Motivo:** «lo que funciona no se rompe». Si un juego terminado importara `COMUN` en vivo, un cambio
  pensado para el juego nuevo podría romperlo sin que nadie lo notara.
- **Descartado:** importar `COMUN` directamente desde cada juego.
- **Si se revierte sin saberlo:** las pruebas de un juego viejo pueden empezar a fallar, o peor,
  pasar con un comportamiento distinto, por un cambio hecho para otro juego.

## ADR-006 — Lógica a 60 Hz con paso fijo, posiciones enteras con subpíxeles y sin interpolación
- **Estado:** **Propuesta** (ver `PROPUESTA-TECNOLOGIA.md` §7).
- **Decisión:** un acumulador avanza la lógica en pasos de 1/60 s, con un máximo de pasos por cuadro.
  Las posiciones y velocidades son enteros (1 px = 16 unidades). El azar es sembrado y forma parte
  del estado. El dibujo muestra el último estado, sin interpolar.
- **Motivo:** el juego corre igual a 60, 144 o 240 Hz. El determinismo bit a bit hace posibles las
  pruebas de repetición.
- **Descartado:** un paso variable (`dt`), que hace la física distinta según el monitor; la coma
  flotante en la lógica, que puede variar entre máquinas y compiladores; la interpolación, que no
  aporta en una cuadrícula de 320×180.
- **Si se revierte sin saberlo:** las repeticiones grabadas dejan de reproducir igual y el candado de
  repetición falla o, peor, se relaja para que pase.

## ADR-007 — Tecnología
- **Estado:** **Propuesta**. Pygame-ce recomendada y Godot 4 como alternativa (`PROPUESTA-TECNOLOGIA.md`).
  **La decide Christian.**
