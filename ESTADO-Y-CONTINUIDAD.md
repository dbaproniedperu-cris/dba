# ESTADO Y CONTINUIDAD — JUEGOS

> **Regla:** después de cada compactación de la conversación, este documento se lee **COMPLETO** antes
> de seguir. Al cerrar cada tramo se **reescribe**: dice la verdad de hoy y no acumula estados viejos.

Última reescritura: **2026-10-11**, tramo 2 (evaluación de un juego del género de *Phoenix*).

---

## §0 Dónde quedó y qué sigue — léelo primero

**Fase actual:** dos entregas, ambas sin código:
1. **Propuesta de tecnología** (`PROPUESTA-TECNOLOGIA.md`).
2. **Evaluación de un juego de naves del género de *Phoenix* (1980)** (`EVALUACION-JUEGO-TIPO-PHOENIX.md`),
   pedida por Christian: estimación de tiempo, controles (teclado, ratón, mando), 2K y 4K. Resultado:
   alcance completo en ≈30–50 h de mi trabajo y ≈8–14 h del suyo, 3–5 semanas de calendario. Es
   criterio propio sin calibrar. **No puede llamarse ni verse como *Phoenix*** (ADR-009). Para un juego
   vertical conviene 640×360 (ADR-008).

**No hay código.** Esperamos las decisiones de Christian.

**Hecho y verificado:**
- Repositorio git creado. En la nube es `dbaproniedperu-cris/dba`, rama
  `claude/retro-games-modern-resolution-lx4ps8`. Su raíz = `D:\NEGOCIO\SOFTWARE\JUEGOS` (ADR-001).
- Creados `ESTADO-Y-CONTINUIDAD.md` (este), `DECISIONES-DE-DISENO.md`, `LEEME.md`, `.gitattributes`,
  `PROPUESTA-TECNOLOGIA.md` y `EVALUACION-JUEGO-TIPO-PHOENIX.md`.
- Comprobada la aritmética de escalas para un juego vertical: las alturas exactas en 1080p, 1440p y
  2160p son las que dividen a 360 (el máximo común divisor).
- Tabla de escalado entero calculada con un script (`PROPUESTA-TECNOLOGIA.md` §4 y Anexo A).
- Comprobado con comandos que los documentos compartidos de `D:\NEGOCIO\` **no son accesibles** desde la
  sesión en la nube (`PROPUESTA-TECNOLOGIA.md` §2).

**Construido sin probar:** nada (no hay código).

**NO hecho, y por qué:**
- **No leí los documentos compartidos** (`ESTANDAR-DESARROLLO.md`, `CAMBIOS-COMPARTIDOS.md`,
  `ESTRUCTURA-INFORMES.md`, `PERFIL-CHRISTIAN.md`, `PERFIL-PROFESIONAL.md`): no están en esta máquina.
- **No anoté la fila «por medir» en `ESTANDAR-DESARROLLO.md` §10**: no tengo el archivo. El texto
  propuesto está en §4.
- **No actualicé los perfiles**: no tengo los archivos. Lo aprendido está en §4.

**Lo que le toca a Christian, en orden:**
1. **Darme acceso a los documentos compartidos.** Lo más simple es adjuntarlos al chat. Otra opción
   es dejarlos en una carpeta `_COMPARTIDOS-SOLO-LECTURA\` de este repositorio, aunque eso crea una
   copia que puede quedar desactualizada; es mejor adjuntarlos en cada sesión.
2. Elegir **tecnología** (recomendada: Pygame-ce; alternativa: Godot 4) y **resolución interna**
   (recomendada: 320×180 en general; 640×360 para un juego vertical).
2b. Si se hace el juego de naves: elegir **alcance** (A, B o C), **tema y nombre propios**, y quién
   hace el **arte y el sonido** (`EVALUACION-JUEGO-TIPO-PHOENIX.md` §7).
3. Autorizar las **descargas** de la tabla de `PROPUESTA-TECNOLOGIA.md` §10 que correspondan.
4. Ejecutar en la estación `py --version` y `py -m pip --version` y pasarme la salida.
5. Clonar o actualizar el repositorio en `D:\NEGOCIO\SOFTWARE\JUEGOS` (comandos en §3).

**Lo que sigue para mí cuando Christian elija:**
1. Leer los documentos compartidos y realinear la propuesta y este documento.
2. Porción vertical en su propia carpeta (ADR-002). **Primer paso: medir el tiempo por cuadro a
   3840×2160** (condición de salida de `PROPUESTA-TECNOLOGIA.md` §6.2).
3. Una pantalla y un personaje que se mueve y choca, con las pruebas de los cuatro niveles en verde.

---

## §1 Qué es el proyecto y sus decisiones cerradas

Juegos originales de estética retro (8 y 16 bits) que se ven con píxel perfecto en pantallas de 1080p,
1440p y 2160p: resolución interna baja y fija, escalado entero con vecino más cercano, bandas negras
cuando no es múltiplo exacto, lógica con paso fijo separada del dibujo, opcionales modernos que se
apagan, y rendimiento en 4K por debajo de 16,6 ms por cuadro, medido.

**Decisiones cerradas** (detalle en `DECISIONES-DE-DISENO.md`):
- ADR-001: documentación e implementación en `JUEGOS`, un solo repositorio git, commits en español.
- ADR-002: **cada juego en su propia carpeta** dentro de `JUEGOS`.
- ADR-003: fin de línea LF forzado (huellas SHA-256 estables).

**Propuestas, esperan a Christian:** ADR-004 (320×180), ADR-005 (base común copiada con versión),
ADR-006 (60 Hz, paso fijo, enteros con subpíxeles), ADR-007 (tecnología), ADR-008 (resolución por
juego; 640×360 para juegos verticales), ADR-009 (género sí, expresión no).

**Reglas del encargo que no cambian:** solo arte y música originales o con licencia libre declarada;
nada se descarga sin permiso; se escribe en español; se propone antes de construir; lo que funciona no
se rompe (primero el candado, después el cambio).

---

## §2 Documentos y orden de lectura

1. Este documento, completo.
2. `D:\NEGOCIO\ESTANDAR-DESARROLLO.md` (§2 niveles de prueba, §3 topes, §9 lista, §10 tabla). **Pendiente de acceso.**
3. `D:\NEGOCIO\CAMBIOS-COMPARTIDOS.md`. **Pendiente de acceso.**
4. `D:\NEGOCIO\ESTRUCTURA-INFORMES.md`, antes de escribir cualquier informe formal. **Pendiente de acceso.**
5. `D:\NEGOCIO\PERFIL-CHRISTIAN.md` y `PERFIL-PROFESIONAL.md`. **Pendiente de acceso.**
6. `DECISIONES-DE-DISENO.md`.
7. `PROPUESTA-TECNOLOGIA.md`.
7b. `EVALUACION-JUEGO-TIPO-PHOENIX.md`.
8. `LEEME.md` de la raíz y, cuando exista, el `LEEME.md` de cada juego.
9. `D:\NEGOCIO\ESTANDAR-BD.md`: solo si algún día se usa SQL Server (hoy no).

---

## §3 Cómo se construye, se prueba y se entrega

**Todavía no hay construcción ni pruebas.** Se definen en la porción vertical, según la tecnología que
se elija.

**Obtener el repositorio en la estación** (PowerShell, si `D:\NEGOCIO\SOFTWARE\JUEGOS` no existe o está
vacía):
```
git clone -b claude/retro-games-modern-resolution-lx4ps8 https://github.com/dbaproniedperu-cris/dba D:\NEGOCIO\SOFTWARE\JUEGOS
```
Si la carpeta ya tiene archivos, **no clonar encima**: avísame y vemos cómo juntarlos.

**Actualizar:**
```
cd D:\NEGOCIO\SOFTWARE\JUEGOS
git pull origin claude/retro-games-modern-resolution-lx4ps8
```

**Comprobar las huellas de la entrega** (deben coincidir con §7):
```
Get-FileHash -Algorithm SHA256 .gitattributes, DECISIONES-DE-DISENO.md, EVALUACION-JUEGO-TIPO-PHOENIX.md, LEEME.md, PROPUESTA-TECNOLOGIA.md
```
En la nube o en Linux: `sha256sum .gitattributes DECISIONES-DE-DISENO.md EVALUACION-JUEGO-TIPO-PHOENIX.md LEEME.md PROPUESTA-TECNOLOGIA.md`.
PowerShell muestra la huella en mayúsculas; se compara sin distinguir mayúsculas.

---

## §4 Pendientes con dueño

| # | Pendiente | Dueño | Estado |
|---|---|---|---|
| P1 | Dar acceso a los documentos compartidos | Christian | Abierto |
| P2 | Elegir tecnología y resolución | Christian | Abierto |
| P3 | Autorizar descargas | Christian | Abierto (depende de P2) |
| P4 | Pasar la salida de `py --version` y `py -m pip --version` | Christian | Abierto |
| P5 | Anotar la fila del proyecto en `ESTANDAR-DESARROLLO.md` §10 | Claude (o Christian si no me da acceso) | Bloqueado por P1 |
| P6 | Realinear `PROPUESTA-TECNOLOGIA.md` a `ESTRUCTURA-INFORMES.md` y a la lista §9 | Claude | Bloqueado por P1 |
| P7 | Agregar a los perfiles lo aprendido (abajo) | Claude | Bloqueado por P1 |
| P8 | Porción vertical: medir 4K primero y luego construir | Claude | Bloqueado por P2 y P3 |
| P9 | Juego de naves: decidir alcance, tema y nombre, y arte | Christian | Abierto |
| P10 | Recalibrar la estimación del juego de naves con las horas reales del tramo 1 | Claude | Bloqueado por P8 |

**Fila propuesta para `ESTANDAR-DESARROLLO.md` §10** (adaptarla a las columnas reales de la tabla):

> JUEGOS · `D:\NEGOCIO\SOFTWARE\JUEGOS` · tecnología: por decidir · unitarias: por medir · contrato: por
> medir · arquitectura y tamaño: por medir (topes se fijan tras la porción vertical) · candados (imagen
> 1080p/1440p/2160p, repetición, rendimiento 4K < 16,6 ms): por medir

**Para los perfiles, sección «JUEGOS»** (cuando tenga acceso):
- Christian organiza cada juego en su propia carpeta dentro de la carpeta base del proyecto
  (instrucción del 2026-10-11).
- Algunas sesiones corren en la nube sin acceso a `D:\`. Los documentos compartidos hay que pasarlos
  explícitamente.

---

## §5 Trampas encontradas

| # | Trampa | Cómo se evita |
|---|---|---|
| T1 | La sesión de Claude puede correr en la nube y no ver `D:\NEGOCIO\` | Comprobarlo con comandos al empezar y pedir los documentos; no suponer su contenido |
| T2 | En la nube no hay lanzador `py`: es `python3` (3.13 en esta sesión). En la estación es `py` | Escribir los comandos de §3 para la estación y anotar el equivalente |
| T3 | Git en Windows convierte a CRLF y cambia las huellas SHA-256 | `.gitattributes` con `eol=lf` (ADR-003) |
| T4 (anticipada) | Windows con escalado al 125 % o 150 % estira la ventana con bilineal si el proceso no declara DPI | Declarar *per-monitor DPI aware*; probarlo en la porción vertical |

---

## §6 Entornos

| | Estación de Christian | Sesión en la nube (Claude) |
|---|---|---|
| Sistema | Windows | Linux (contenedor temporal) |
| Python | `py` (versión por confirmar, P4) | `python3` 3.13 |
| Node | Instalado, fuera del PATH | `/opt/node22` (v22) |
| JDK / Git | Sí / Sí | Sí / Sí |
| Carpeta del proyecto | `D:\NEGOCIO\SOFTWARE\JUEGOS` | `/home/user/dba` (raíz del repositorio) |
| Pantalla 4K / GPU | Por confirmar | No hay: las mediciones de rendimiento se hacen en la estación |

---

## §7 Estado al cerrar

- **Fecha:** 2026-10-11
- **Versión:** 0.0.2. Solo documentación (propuesta de tecnología y evaluación del juego de naves); sin código.
- **Pruebas:** no hay todavía (no hay código).
- **Huellas SHA-256:**

| Archivo | SHA-256 |
|---|---|
| `.gitattributes` | `6a0cae3e0ec19ca2f2ad0bc560d84e247736193eacfd08c4b89e739cd71c45f8` |
| `DECISIONES-DE-DISENO.md` | `05a35a943239a00b377df202b5abf0a530c66a5a5f5fe258780ebb7b45fba348` |
| `EVALUACION-JUEGO-TIPO-PHOENIX.md` | `2b9e2c7a16c689c845094af8635cb09c82086e9e83a035d8176e1485ec7429d5` |
| `LEEME.md` | `fa86612e3c7aa584a0b023a3d01d32033f7ae0ce9d966548b5d498f7a3998a45` |
| `PROPUESTA-TECNOLOGIA.md` | `2c455e9b832be27e503286500383a3fa4f8e07ff0b714b3a726861288ffd34a4` |

- **Commit:** el que agrega este archivo en la rama `claude/retro-games-modern-resolution-lx4ps8`. Se
  consulta con `git log -1 --format=%H -- ESTADO-Y-CONTINUIDAD.md`. No va escrito aquí porque un
  archivo no puede contener la huella del commit que lo incluye.
