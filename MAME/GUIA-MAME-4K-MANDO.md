# Guía: MAME en 4K con mando, para jugar *Phoenix* (1980)

| Campo | Valor |
|---|---|
| Carpeta | `D:\NEGOCIO\SOFTWARE\JUEGOS\MAME` |
| Fecha | 2026-10-11 |
| Estado | **Escrito y revisado, sin probar en Windows.** Ver §9 |

---

## 1. Qué es MAME

MAME es un emulador gratuito y de código abierto (licencia GPL-2.0 o posterior). Reproduce el hardware
de las máquinas arcade originales, así que el juego se ve y suena **exactamente** como en la máquina:
las mismas figuras y los mismos sonidos.

**El emulador es legal. El juego (la ROM) es aparte:** solo puedes usarlo si tienes derecho sobre una
copia. Esta guía no explica cómo conseguirlo.

---

## 2. Dónde descargarlo (solo de los sitios oficiales)

| Sitio | Dirección |
|---|---|
| Página oficial de descargas | <https://www.mamedev.org/release.html> |
| Publicaciones oficiales en GitHub | <https://github.com/mamedev/mame/releases> |

- Archivo para Windows: **`mameNNNNb_x64.exe`** (NNNN es la versión; por ejemplo, `mame0289b_x64.exe`
  es la 0.289, de julio de 2026). Es un archivo autoextraíble de unos 100 MB; el tamaño exacto lo
  muestra el script antes de descargar.
- **No lo bajes de otros sitios.** Hay páginas que reempaquetan MAME con publicidad o programas no
  deseados.

---

## 3. Instalación automática (recomendada)

En la carpeta `MAME` hay tres archivos preparados:

| Archivo | Qué hace |
|---|---|
| `instalar-mame.ps1` | Busca la última versión oficial en GitHub y te muestra **nombre, origen, tamaño y huella** antes de bajar nada. Pide confirmación, descarga, comprueba tamaño y huella SHA-256, extrae en `MAME\mame\` y aplica los ajustes |
| `ajustes-4k-mando.ini` | Los ajustes de 4K y mando, explicados línea por línea. Puedes editarlo |
| `jugar-phoenix.bat` | Abre el juego directamente |

**Pasos:**

1. Actualiza el repositorio en tu estación (`git pull`; ver `ESTADO-Y-CONTINUIDAD.md` §3).
2. Abre PowerShell en `D:\NEGOCIO\SOFTWARE\JUEGOS\MAME` y ejecuta:
   ```
   powershell -ExecutionPolicy Bypass -File .\instalar-mame.ps1
   ```
   `-ExecutionPolicy Bypass` permite correr este script una vez sin cambiar la configuración de
   seguridad de Windows.
3. Revisa lo que muestra (archivo, origen, tamaño) y responde **S**.
4. Copia tu copia legal del juego, **`phoenix.zip` sin descomprimir**, en `MAME\mame\roms\`.
5. Doble clic en **`jugar-phoenix.bat`**.

**Variantes:**
- Versión fija en lugar de la última: `.\instalar-mame.ps1 -Version 0289`
- Volver a aplicar los ajustes después de editar `ajustes-4k-mando.ini`:
  `.\instalar-mame.ps1 -SoloAjustes`. El `mame.ini` original queda guardado como `mame.ini.original`.

### 3.1 Si ya lo descargaste tú (tu caso: `C:\IAPRG\game`)

Ejecuta en PowerShell, desde `D:\NEGOCIO\SOFTWARE\JUEGOS\MAME`:
```
powershell -ExecutionPolicy Bypass -File .\instalar-mame.ps1 -RutaMame C:\IAPRG\game
```
- **No descarga nada.** Trabaja sobre tu carpeta.
- Si en `C:\IAPRG\game` está **solo el instalador** (`mameNNNNb_x64.exe`), te muestra su tamaño
  y su huella SHA-256, pide confirmación y lo extrae ahí mismo.
- Si **ya está extraído** (existe `C:\IAPRG\game\mame.exe`), pasa directo a los ajustes.
- Si `mame.exe` quedó en una subcarpeta (por ejemplo, `C:\IAPRG\game\mame0289b_x64\`), indica
  esa subcarpeta en `-RutaMame`.
- Después: pon tu `phoenix.zip` en `C:\IAPRG\game\roms\` y abre `jugar-phoenix.bat`, que busca
  MAME en `MAME\mame\` y, si no lo encuentra ahí, en `C:\IAPRG\game`.
- Comprueba que lo bajaste de un sitio oficial (§2). Si tienes dudas, compara la huella que muestra
  el script con la que publica GitHub para ese archivo.

### 3.2 Instalación manual

Si el script falla: descarga el `.exe` del §2, haz doble clic, elige como
destino `D:\NEGOCIO\SOFTWARE\JUEGOS\MAME\mame` y después ejecuta `.\instalar-mame.ps1 -SoloAjustes`.

---

## 4. Los ajustes de 4K, explicados

| Ajuste | Valor | Para qué |
|---|---|---|
| `window` | `0` | Pantalla completa |
| `switchres` | `0` | **No cambia la resolución de tu escritorio**: el 4K se queda en 4K y MAME escala dentro |
| `keepaspect` | `1` | Respeta la proporción de la pantalla original |
| `unevenstretch` | `0` | **Solo escalas enteras**: cada píxel del juego es un bloque idéntico. El sobrante queda en bandas negras |
| `filter` | `0` | Sin suavizado bilineal (el que deja borroso) |
| `video` | `bgfx` | Motor de video moderno (DirectX 11/12 o Vulkan) |
| `bgfx_screen_chains` | `unfiltered` | Píxeles nítidos. **Cámbialo a `crt-geom` para el efecto de pantalla de tubo** |
| `waitvsync` | `1` | Sincroniza con el monitor y evita cortes en la imagen |
| `joystickprovider` | `winhybrid` | Reconoce a la vez mandos Xbox (XInput) y PlayStation o genéricos (DirectInput) |
| `joystick_deadzone` | `0.20` | Zona muerta de la palanca, para que la nave no se mueva sola |
| `skip_gameinfo` | `1` | Se salta la pantalla de información al abrir |
| `plugin` | `hiscore` | Guarda tus récords entre partidas |

**Qué esperar en 4K.** *Phoenix* es de pantalla vertical (208×256 píxeles), así que verás una franja
vertical al centro con bandas negras a los lados, como en la máquina. En 3840×2160 cada píxel del juego
mide unos 7 u 8 píxeles de tu monitor, todos iguales y sin borroso. Es mi cálculo; la escala exacta la
elige MAME.

**Efecto CRT.** Hay dos maneras:
- **Fijo:** en `ajustes-4k-mando.ini` cambia `unfiltered` por `crt-geom` y ejecuta
  `.\instalar-mame.ps1 -SoloAjustes`.
- **En vivo:** dentro del juego, `Tab` → *Slider Controls* → *Screen 0 Effect* (los nombres del
  menú pueden variar un poco según la versión).

---

## 5. Mandos USB y Bluetooth

1. **Conéctalo antes de abrir MAME.** Si es Bluetooth, emparéjalo primero en *Configuración de
   Windows → Bluetooth y dispositivos*.
2. Mandos **Xbox** o compatibles con XInput: funcionan directamente.
3. Mandos **PlayStation** (DualShock 4, DualSense) y genéricos: los reconoce `winhybrid`. Los botones
   pueden quedar en otro orden; se arregla en el paso 5.
4. **Si Steam está abierto, ciérralo.** Steam Input puede interceptar el mando y duplicar o cambiar las
   pulsaciones.
5. **Asignar botones**, una sola vez. Dentro del juego:
   `Tab` → *Input Settings* → *Input Assignments (this system)*. Elige la acción, pulsa **Enter** y
   pulsa el botón del mando.
   - *P1 Button 1*: **disparo**
   - *P1 Button 2*: **escudo**
   - *Coin 1*: **moneda** (por ejemplo, el botón *Select* o *Share*)
   - *1 Player Start*: **empezar** (por ejemplo, *Start* u *Options*)
   MAME guarda esto solo, en `MAME\mame\cfg\phoenix.cfg`.
6. **Jugar sin teclado:** en *Input Assignments (general)* → *User Interface* asigna *Config Menu*
   (el menú `Tab`) y *Exit* a botones del mando que no uses en el juego.

---

## 6. Teclas útiles

| Tecla | Acción |
|---|---|
| `5` | Insertar moneda |
| `1` | Empezar partida de 1 jugador |
| Flechas | Mover la nave |
| `Ctrl` izquierdo | Disparo (botón 1) |
| `Alt` izquierdo | Escudo (botón 2) |
| `P` | Pausa |
| `Tab` | Menú de configuración |
| `Alt` + `Enter` | Alternar ventana o pantalla completa |
| `F11` | Muestra la velocidad (debe decir 100 %) |
| `Esc` | Salir |

---

## 7. Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| La imagen se ve borrosa | Quedó activo el suavizado, o Windows está escalando la ventana | Revisa que `filter` sea `0` y la cadena `unfiltered`. Si sigue: clic derecho en `mame.exe` → Propiedades → Compatibilidad → *Cambiar configuración de PPP alto* → marca *Invalidar el comportamiento de escalado* → *Aplicación* |
| «Required files are missing» | Falta el juego, o la versión del juego no corresponde a la de MAME | Debe ser `phoenix.zip` sin descomprimir, en `mame\roms\`, y de una versión compatible con tu versión de MAME |
| La nave se mueve sola | Palanca gastada | Sube `joystick_deadzone` a `0.30` y aplica con `-SoloAjustes` |
| El mando no responde | Steam abierto, o mando conectado después de abrir MAME | Cierra Steam, conecta el mando y vuelve a abrir el juego |
| Tirones leves en un monitor de 144 o 240 Hz | El juego corre a unos 60 Hz | Pon el monitor a 60 Hz o activa G-Sync/FreeSync |
| Windows SmartScreen avisa al instalar | Es normal en programas poco descargados | Si el script dijo «Huella verificada», el archivo es el oficial |
| Aviso «La opción 'x' no existe» al instalar | Esa opción cambió de nombre en tu versión de MAME | El resto se aplica igual. Avísame el nombre y lo corrijo |

---

## 8. Qué queda en la carpeta

```
JUEGOS\MAME\
├── GUIA-MAME-4K-MANDO.md      ← esta guía                      (en git)
├── instalar-mame.ps1          ← instalador                     (en git)
├── ajustes-4k-mando.ini       ← ajustes de 4K y mando          (en git)
├── jugar-phoenix.bat          ← abre el juego                  (en git)
├── .gitignore                 ← impide subir MAME y las ROM a git
├── descargas\                 ← el .exe descargado             (NO va a git)
└── mame\                      ← MAME instalado                 (NO va a git)
    ├── mame.exe, mame.ini, mame.ini.original
    ├── roms\phoenix.zip       ← tu copia legal                 (NO va a git)
    └── cfg\phoenix.cfg        ← tus botones, lo crea MAME
```

---

## 9. Verificado y no verificado

**Verificado:**
- Los archivos `instalar-mame.ps1`, `jugar-phoenix.bat` y `ajustes-4k-mando.ini` contienen solo
  caracteres ASCII, así que PowerShell 5.1 y `cmd` no rompen las tildes.
- La regla de `.gitattributes` extrae los `.bat` con fin de línea CRLF en toda máquina.

**No verificado** (esta sesión corre en Linux, sin PowerShell, y su red no llega a `mamedev.org` ni a
la API de GitHub para MAME):
- **El script no se ha ejecutado nunca.** La primera vez puede fallar en algún detalle; si pasa,
  mándame el texto del error.
- Que la versión actual de MAME se llame `mameNNNNb_x64.exe` (la 0.289 sí, según la página oficial).
- Que GitHub publique la huella SHA-256 del archivo. Si no la publica, el script muestra la calculada
  y sigue.
- Que el autoextraíble acepte `-o` y `-y` (es lo normal en 7-Zip). Si no, el script te da los pasos
  manuales.
- Los nombres exactos de las opciones y de los menús en tu versión. Si una opción no existe, el script
  lo avisa en lugar de fallar en silencio.
- El resultado visual en 4K y el reconocimiento de tu mando: solo se comprueban en tu estación.
