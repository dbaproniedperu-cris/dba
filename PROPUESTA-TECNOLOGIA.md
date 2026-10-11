# Propuesta de tecnología — Juegos retro con resolución moderna

| Campo | Valor |
|---|---|
| Proyecto | JUEGOS (`D:\NEGOCIO\SOFTWARE\JUEGOS`) |
| Para | Christian Velarde Valdez |
| Fecha | 2026-10-11 |
| Versión del informe | 1.0 |
| Estado | **Propuesta. No se ha construido nada.** Espera tu elección |

> **Aviso de formato.** Este informe debe seguir `ESTRUCTURA-INFORMES.md`, pero **no pude leerlo**
> (ver §2). Usé una estructura genérica: resumen, alcance, análisis, recomendación, riesgos, qué está
> verificado y qué te toca. En cuanto tenga el documento, lo reacomodo sin cambiar el contenido.

---

## 1. Resumen

**Recomiendo Pygame-ce (Python)** con una **lógica en Python puro que no importa el motor**,
resolución interna **320×180**, lógica a **60 Hz con paso fijo** y posiciones en **enteros con
subpíxeles** (sin coma flotante).

La elijo por las pruebas, no por el motor. Las cuatro capas del estándar, incluidas las pruebas de
imagen en las tres resoluciones, corren sin pantalla y sin tarjeta gráfica, con resultado idéntico bit a
bit en cualquier máquina. Además usa el Python que ya tiene la estación y lo que hay que descargar es
poco.

**Condición de salida (criterio propio):** el primer paso de la porción vertical es medir el tiempo por
cuadro a 3840×2160 en tu estación. Si el percentil 99 pasa de 16,6 ms y no se arregla con el camino por
GPU, cambiamos a **Godot 4**, que es la alternativa fuerte. Así el riesgo principal de Pygame-ce se
mide en el primer día y no después de construir el juego.

---

## 2. Alcance y fuentes

**Leído:** tu mensaje de encargo completo.

**No leído:** los documentos compartidos de `D:\NEGOCIO\` (`ESTANDAR-DESARROLLO.md`,
`CAMBIOS-COMPARTIDOS.md`, `ESTRUCTURA-INFORMES.md`, los dos perfiles). Esta sesión corre en un
contenedor en la nube, no en tu estación, y no tiene acceso al disco `D:`. No lo supongo, lo comprobé:

```
find / -maxdepth 6 -name "ESTANDAR-DESARROLLO.md"   → sin resultados
find / -maxdepth 4 -iname "*NEGOCIO*"               → sin resultados
/mnt/user-data/uploads                              → vacío (no hay adjuntos)
git ls-remote origin                                → repositorio remoto vacío
```

Todo lo que se apoya en el estándar (§9, §10, la estructura de informes) queda **pendiente de
alinear**. Las demás decisiones de este informe se toman sobre tu encargo.

---

## 3. Las exigencias con las que comparo

| # | Exigencia (tu punto 4 y 5) | Cómo la mido |
|---|---|---|
| E1 | Píxel perfecto: escalado entero con vecino más cercano y bandas negras | ¿El motor lo trae de serie o hay que hacerlo a mano? ¿Se puede probar automáticamente? |
| E2 | Rendimiento en 4K por debajo de 16,6 ms por cuadro | Coste del escalado final y de la lógica |
| E3 | Paso de tiempo fijo separado del dibujo | ¿Viene de serie? ¿Se puede hacer determinista? |
| E4 | Opcionales: CRT, pantalla completa sin bordes, mandos, guardado, teclas | ¿Qué trae el motor? |
| E5 | Pruebas de los cuatro niveles, automatizables | Lógica sin dibujar, imágenes sin GPU, repeticiones, arquitectura |
| E6 | Distribución en Windows | Tamaño, herramientas, problemas conocidos |
| E7 | Licencia | Comercial sin regalías, obligaciones |
| E8 | Encaje con la estación | Qué hay instalado y cuánto hay que descargar |

---

## 4. Resolución interna: 320×180

Tabla calculada en esta sesión (`python3`, script en el Anexo A). Escala entera máxima y bandas negras
(ancho × alto) en las pantallas comunes:

| Pantalla | 320×180 | 384×216 | 480×270 | 640×360 |
|---|---|---|---|---|
| 1280×720 | ×4  exacto | ×3  bandas 128×72 | ×2  bandas 320×180 | ×2  exacto |
| 1366×768 | ×4  bandas 86×48 | ×3  bandas 214×120 | ×2  bandas 406×228 | ×2  bandas 86×48 |
| 1600×900 | ×5  exacto | ×4  bandas 64×36 | ×3  bandas 160×90 | ×2  bandas 320×180 |
| **1920×1080** | **×6  exacto** | ×5  exacto | ×4  exacto | **×3  exacto** |
| 1920×1200 | ×6  bandas 0×120 | ×5  bandas 0×120 | ×4  bandas 0×120 | ×3  bandas 0×120 |
| 2560×1080 | ×6  bandas 640×0 | ×5  bandas 640×0 | ×4  bandas 640×0 | ×3  bandas 640×0 |
| **2560×1440** | **×8  exacto** | ×6  bandas 256×144 | ×5  bandas 160×90 | **×4  exacto** |
| 2560×1600 | ×8  bandas 0×160 | ×6  bandas 256×304 | ×5  bandas 160×250 | ×4  bandas 0×160 |
| 3440×1440 | ×8  bandas 880×0 | ×6  bandas 1136×144 | ×5  bandas 1040×90 | ×4  bandas 880×0 |
| **3840×2160** | **×12 exacto** | ×10 exacto | ×8  exacto | **×6  exacto** |

**Recomiendo 320×180.** Motivos:

1. **Es exacta en más pantallas.** Las dos cumplen tus tres resoluciones objetivo, pero 320×180 además
   es exacta en 720p y 900p. En 900p, 640×360 deja 320×180 píxeles de bandas.
2. **Es la escala del 16 bits.** Las consolas de 16 bits dibujaban unos 256–320 × 224 píxeles.
   320×180 es esa misma densidad en formato 16:9. Con 640×360 el píxel queda la mitad de grande y el
   arte deja de verse retro, o hay que dibujarlo a doble tamaño, lo que es trabajar a 320×180 con más
   costo.
3. **Es un patrón probado en juegos de píxel publicados.** *Celeste*, por ejemplo, usa 320×180.
4. **Tiene 4 veces menos píxeles por dibujar** (57 600 frente a 230 400). Esto importa si el dibujo
   interno es por CPU, como en Pygame-ce.

**Lo que se pierde:** el texto tiene que ser una fuente de píxel pequeña (5×7 u 8×8) y cabe menos
información en pantalla. Para un juego de 8 o 16 bits es lo normal. Para el estilo 8 bits puro se puede
usar la misma 320×180 con una paleta y un tamaño de sprite más limitados. No hace falta otra resolución.

---

## 5. Comparación de tecnologías

Leyenda: **[P]** patrón probado (documentado o de uso amplio), **[C]** criterio propio, **[?]** por
verificar en tu estación.

| Criterio | Godot 4 | MonoGame | LÖVE | **Pygame-ce** | TypeScript + WebGL |
|---|---|---|---|---|---|
| Lenguaje | GDScript (o C#) | C# | Lua | Python | TypeScript |
| E1 Escalado entero y bandas | **De serie**: modo de estiramiento `viewport` con escala entera y filtro *nearest* [P][?] | A mano: *RenderTarget* 320×180 + `PointClamp` (unas 30 líneas) [P] | A mano: *Canvas* + `setDefaultFilter("nearest")` [P] | A mano: superficie 320×180 + escalado en GPU [P][?] | A mano, **con la trampa de `devicePixelRatio`** en Windows al 125 % o 150 % [P] |
| E2 4K < 16,6 ms | Sobrado [P] | Sobrado [P] | Sobrado [P] | **Riesgo:** el escalado debe ir por GPU; por CPU, 4K son 33 MB por cuadro [C][?] | Sobrado en navegador; con Electron depende [C] |
| E3 Paso fijo | De serie (`_physics_process`, 60 Hz) [P] | `IsFixedTimeStep` mezcla actualizar y dibujar; mejor un acumulador propio [P] | Se reescribe `love.run` [P] | Acumulador propio (patrón *Fix Your Timestep*) [P] | Acumulador sobre `requestAnimationFrame` [P] |
| E4 Mandos USB/Bluetooth | De serie [P] | SDL2 (DesktopGL) [P] | SDL2 [P] | SDL2 (`pygame._sdl2.controller`) [P] | API Gamepad del navegador, mapeo irregular [P] |
| E4 Pantalla completa sin bordes | De serie [P] | `IsBorderless` [P] | De serie [P] | `FULLSCREEN_DESKTOP` de SDL2 [P][?] | API Fullscreen [P] |
| E4 Filtro CRT | Sombreador de serie [P] | Efecto HLSL, compilado por MGCB [P] | Sombreador GLSL [P] | Capa de líneas por GPU; sombreador real solo con OpenGL aparte [C][?] | Sombreador GLSL [P] |
| E5 Unitarias de lógica sin dibujar | Dentro de Godot sin pantalla (GUT o gdUnit4, de terceros) [P] | xUnit sobre biblioteca .NET pura, excelente [P] | `busted` con un Lua aparte (otra descarga) [P] | **pytest, excelente** [P] | Vitest, excelente [P] |
| E5 Pruebas de imagen sin GPU | **Débil:** sin pantalla Godot no dibuja; necesita GPU y el resultado puede variar con el controlador [P][?] | Necesita GPU [P] | Necesita ventana y GPU [P] | **Fuerte:** se dibuja por CPU sin pantalla (`SDL_VIDEODRIVER=dummy`), idéntico bit a bit [P] | Fuerte con Playwright y Chromium por software [P] |
| E5 Arquitectura (lógica sin motor) | Por convención; GDScript vive dentro del motor [C] | Fuerte: proyecto .NET sin referencia al motor [P] | Por convención [C] | Fuerte: prueba que analiza los `import` [P] | Fuerte: reglas de importación [P] |
| E6 Distribución Windows | Exportador de serie; ejecutable de unos 70–100 MB [?] | `dotnet publish` autocontenido, unos 60–80 MB [?] | `love.exe` + `.love` fusionados, unos 10–15 MB [P] | PyInstaller en carpeta, unos 30–60 MB; **falsos positivos de antivirus conocidos** [P] | Electron, más de 150 MB; o navegador [P] |
| E7 Licencia | MIT [P] | MS-PL [P] | zlib [P] | **LGPL 2.1**: se cumple distribuyendo en carpeta (`onedir`) con las bibliotecas reemplazables [P] | Apache 2.0 / MIT (Electron) [P] |
| E8 Encaje con la estación | Descarga del editor (unos 60 MB) y plantillas de exportación (cerca de 1 GB) [?] | SDK .NET (unos 200 MB) si no está; no consta que esté [?] | Descarga pequeña, más Lua para pruebas | **Python ya está**; faltan `pygame-ce` y `pytest` (unos 12 MB) [?] | Node está fuera del PATH; Electron y dependencias pesan [P] |
| Juegos comerciales | Muchos [P] | Muchos (*Stardew Valley*, *Celeste* en XNA/FNA) [P] | Varios (*Balatro*) [P] | Pocos [P] | Algunos (web) [P] |
| Editor visual | **Sí** | No | No | No (niveles en JSON propio o con Tiled) | No |

---

## 6. Recomendación y por qué

### 6.1 Recomiendo Pygame-ce, con una arquitectura que no depende de él

Tus exigencias de pruebas pesan más que las de herramientas. Lo que resolvió la comparación:

1. **Las pruebas de imagen son el candado más difícil, y Pygame-ce es donde salen más baratas y
   fiables.** La escena se dibuja por CPU a 320×180 en una superficie, sin ventana. El escalado
   entero a 1920×1080, 2560×1440 y 3840×2160 es una operación determinista. Se compara bit a bit
   con la referencia en tu estación, en la nube o en cualquier otra máquina [P]. En Godot,
   MonoGame y LÖVE esa prueba necesita GPU y puede cambiar de un controlador a otro.
2. **Lógica en Python puro.** El paquete `logica/` no importa `pygame`, y una prueba de arquitectura
   lo hace cumplir leyendo los `import` de cada archivo [P]. Las unitarias y las repeticiones corren
   con `pytest`, sin motor.
3. **Usa lo que ya tienes.** Python está en la estación. Para empezar basta con `pygame-ce` y `pytest`.
4. **Licencia sin costo.** LGPL 2.1 se cumple distribuyendo en carpeta, no en un solo `.exe`. Eso
   además reduce los falsos positivos del antivirus [P].

**Lo que se acepta con esta elección:**
- No hay editor visual. Los niveles se hacen en JSON propio, o en Tiled si lo autorizas más adelante.
- El techo de rendimiento de la lógica en Python es más bajo. Basta para la escala de un juego de
  8 o 16 bits (cientos de entidades, no decenas de miles) [C].
- Hay menos juegos comerciales hechos así. Es una apuesta por la verificabilidad y no por la
  popularidad [C].

### 6.2 El riesgo principal y cómo se corta

El escalado final a 4K tiene que hacerlo la GPU. La superficie de 320×180 se sube como textura,
unos 230 KB por cuadro, y se dibuja ampliada con vecino más cercano. Pygame-ce lo permite con la
bandera `SCALED` o con su módulo `_sdl2.video`, que su documentación todavía marca como experimental
[?]. **No lo he medido.** Por eso el primer paso de la porción vertical es esa medición: si no cumple,
cambiamos de tecnología antes de escribir el juego.

### 6.3 La alternativa: Godot 4

Si prefieres **editor visual, animaciones y mapas de tiles de serie** para juegos más grandes, Godot 4 es
la mejor opción: MIT, escala entera de serie y paso fijo de serie. El costo está en las pruebas: las de
imagen necesitan GPU, y la lógica en GDScript se separa del motor solo por disciplina. Si la eliges,
propongo hacer la lógica en clases sin nodos (`RefCounted`) y las pruebas de imagen con captura en tu
estación, con tolerancia cero y la versión de controlador anotada.

**Descarto** MonoGame (el mismo problema de GPU en las pruebas, más el SDK .NET y la cadena de
contenido MGCB), LÖVE (Lua, que también necesita GPU para las pruebas de imagen) y TypeScript + WebGL
(la trampa de `devicePixelRatio` contra el píxel perfecto en Windows con escalado, y una distribución
pesada).

---

## 7. Arquitectura propuesta (vale para cualquier tecnología)

```
JUEGOS\                       ← carpeta base = repositorio git
├── <JUEGO-1>\                ← cada juego en su propia carpeta (decisión tuya, ADR-002)
│   ├── logica\               ← Python puro: estados, física, colisiones, puntaje, guardado. NO importa pygame
│   ├── presentacion\         ← pygame-ce: ventana, escalado, entrada, sonido, CRT
│   ├── datos\                ← niveles, configuración por defecto (JSON con campo "version")
│   ├── recursos\             ← arte y sonido originales, con LICENCIAS.md
│   ├── pruebas\              ← unitarias, contrato, arquitectura, candados (imagen, repetición, rendimiento)
│   └── LEEME.md
└── COMUN\ (cuando haga falta) ← base reutilizable; cada juego COPIA una versión fija (ADR-005)
```

Piezas clave:

- **Paso fijo [P]:** un acumulador de tiempo que avanza la lógica en pasos de 1/60 s, con un máximo de
  pasos por cuadro para que la lógica no se descontrole si un cuadro se atrasa. El dibujo va a la
  frecuencia del monitor y muestra el último estado. **Sin interpolación** [C]: en una cuadrícula de
  320×180 una posición intermedia se redondea al mismo píxel, así que no aporta y complica.
- **Posiciones en enteros con subpíxeles [P]** (por ejemplo, 1 píxel = 16 unidades), como en las
  consolas originales. Sin coma flotante, la misma entrada da exactamente el mismo resultado en
  cualquier máquina. Eso es lo que permite que la prueba de repetición compare bit a bit.
- **Azar con semilla [P]:** un generador propio y sembrado dentro del estado del juego. Nunca el
  azar global.
- **Entrada como datos [P]:** cada paso recibe un conjunto de acciones (izquierda, salto…), no
  teclas. Las teclas configurables y los mandos se traducen a acciones en `presentacion`. Una partida
  grabada es la lista de acciones por paso.
- **Guardado y configuración [P]:** JSON con campo `version` y una cadena de migraciones
  (v1→v2→…). Un archivo de versión desconocida se rechaza con un mensaje claro. El guardado es
  atómico: se escribe a un temporal y luego se reemplaza. Va en `%APPDATA%\<juego>\`.
- **DPI de Windows [P][?]:** el proceso tiene que declararse *per-monitor DPI aware*. Si no, Windows al
  125 % o 150 % estira la ventana con filtro bilineal y **arruina el píxel perfecto sin que el código
  tenga la culpa**. Se verifica en la porción vertical.

### Las cuatro capas de pruebas con esta arquitectura

| Nivel | Qué prueba | Cómo |
|---|---|---|
| Unitarias | Colisiones, física, puntaje, estados, guardado | `pytest` sobre `logica/`, sin `pygame` |
| Contrato | Niveles, partidas guardadas, configuración | Archivos de ejemplo de cada versión en `pruebas/contrato/`: los viejos cargan o se rechazan con el mensaje esperado |
| Arquitectura y tamaño | `logica/` no importa `pygame`; topes de tamaño | Análisis de `import` con `ast`; topes **medidos primero** en la porción vertical y fijados después |
| Candados | Imagen en 1080p, 1440p y 2160p; repetición; rendimiento | Escena fija comparada bit a bit con un PNG de referencia, más una comprobación independiente: cada píxel lógico es un bloque k×k uniforme (atrapa el borroso aunque la referencia esté mal). Repetición: entradas grabadas que deben dar la huella del estado final. Rendimiento: tiempo por cuadro medido, con percentiles 50, 99 y máximo |

---

## 8. Riesgos y trampas anticipadas

| Riesgo | Efecto | Mitigación |
|---|---|---|
| El escalado por GPU de Pygame-ce no rinde o falla en la estación | No se cumple E2 | Medirlo primero; si no cumple, pasar a Godot 4 (§6.2) |
| Windows estira la ventana por DPI | Imagen borrosa con el código correcto | Declarar el DPI y probarlo al 100 % y al 150 % |
| Monitor de 144 Hz con lógica a 60 Hz | Algunos cuadros duran 2 refrescos y otros 3 (vibración leve) | Es lo esperado sin interpolación; G-Sync o FreeSync lo eliminan. Lo anoto como límite conocido [C] |
| Antivirus marca el ejecutable de PyInstaller | El usuario no puede abrirlo | Distribuir en carpeta, no en un solo `.exe`; firmar si se publica |
| Conversión CRLF de Git en Windows | Las huellas SHA-256 no coinciden entre la nube y la estación | `.gitattributes` fuerza LF (ADR-003, ya aplicado) |
| No leí el estándar | Algún punto de esta propuesta podría contradecirlo | Revisarlo apenas tenga acceso (§10) |

---

## 9. Verificado y no verificado

**Verificado en esta sesión:**
- La tabla de escalado de §4, calculada con el script del Anexo A.
- Que los documentos compartidos no son accesibles desde esta sesión (comandos de §2).
- Que el repositorio estaba vacío al empezar.

**Sin verificar** (dato de documentación o experiencia, no medido aquí): todo lo marcado **[?]**,
los tamaños de descarga, los tiempos de cuadro y el comportamiento por DPI. **No se instaló ni se
descargó nada.**

---

## 10. Lo que te toca decidir

1. **Tecnología:** Pygame-ce (recomendada) o Godot 4 (alternativa).
2. **Resolución interna:** 320×180 (recomendada) o 640×360.
3. **Descargas**, solo cuando elijas. Los tamaños son aproximados y se confirman antes de bajar:

| Si eliges | Archivo | Origen | Tamaño aprox. |
|---|---|---|---|
| Pygame-ce | `pygame-ce` (rueda `win_amd64` de tu versión de Python) | PyPI (`pypi.org`) | 10–12 MB |
| Pygame-ce | `pytest` y sus dependencias (`pluggy`, `iniconfig`, `packaging`, `colorama`) | PyPI | ~1 MB |
| Pygame-ce, al distribuir | `pyinstaller` y sus dependencias | PyPI | ~5 MB |
| Godot 4 | Editor Godot 4.x estable, Windows 64 bits (`.zip`) | `godotengine.org` / GitHub `godotengine/godot` | ~60 MB |
| Godot 4, al distribuir | Plantillas de exportación (`.tpz`) | ídem | ~1 GB |

4. **Ejecuta en la estación** y pásame la salida: `py --version` y `py -m pip --version`. Sirve para
   saber si hay rueda de `pygame-ce` para tu versión de Python.

---

## Anexo A — Script de la tabla de escalado

```python
pantallas=[(1280,720),(1366,768),(1600,900),(1920,1080),(1920,1200),(2560,1080),(2560,1440),(2560,1600),(3440,1440),(3840,2160)]
internas=[(320,180),(384,216),(480,270),(640,360)]
for W,H in pantallas:
    for w,h in internas:
        k=min(W//w,H//h)                 # escala entera máxima que cabe
        bx,by=W-w*k,H-h*k                # bandas negras totales (ancho, alto)
```

Se ejecutó con Python 3.13 en el contenedor de la sesión. La versión completa, que imprime la tabla,
estaba en la carpeta temporal de la sesión.
