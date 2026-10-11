<#
  instalar-mame.ps1
  Descarga MAME oficial para Windows x64 desde GitHub (repositorio mamedev/mame),
  verifica tamano y huella SHA-256, lo extrae en .\mame y aplica ajustes-4k-mando.ini.
  Antes de descargar muestra nombre, origen y tamano, y pide confirmacion.

  Uso, en PowerShell, desde la carpeta D:\NEGOCIO\SOFTWARE\JUEGOS\MAME :
    powershell -ExecutionPolicy Bypass -File .\instalar-mame.ps1                  (ultima version)
    powershell -ExecutionPolicy Bypass -File .\instalar-mame.ps1 -Version 0289    (version fija)
    powershell -ExecutionPolicy Bypass -File .\instalar-mame.ps1 -SoloAjustes     (no descarga)
    powershell -ExecutionPolicy Bypass -File .\instalar-mame.ps1 -RutaMame C:\IAPRG\game
        (MAME ya descargado por ti en otra carpeta: no descarga nada; si en esa carpeta
         solo esta el instalador mameNNNNb_x64.exe, lo extrae ahi mismo; luego aplica ajustes)

  Nota: este archivo es solo ASCII a proposito. PowerShell 5.1 lee los .ps1 sin BOM
  como ANSI y romperia las tildes.
#>
param(
    [string]$Version = "",
    [switch]$SoloAjustes,
    [string]$RutaMame = ""
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Base      = $PSScriptRoot
$Destino   = Join-Path $Base "mame"
if ($RutaMame) { $Destino = (Resolve-Path $RutaMame).Path; $SoloAjustes = $true }
$Descargas = Join-Path $Base "descargas"
$Ajustes   = Join-Path $Base "ajustes-4k-mando.ini"
$MameExe   = Join-Path $Destino "mame.exe"
$MameIni   = Join-Path $Destino "mame.ini"

function Crear-ConfigBase {
    Push-Location $Destino
    try { & .\mame.exe -createconfig | Out-Null } finally { Pop-Location }
    if (-not (Test-Path $MameIni)) { throw "MAME no genero mame.ini en $Destino" }
}

function Extraer-Instalador([string]$archivo) {
    # El instalador oficial es un autoextraible 7-Zip: -o<carpeta> y -y (sin preguntas)
    New-Item -ItemType Directory -Force $Destino | Out-Null
    Write-Host "Extrayendo $archivo en $Destino ..."
    Start-Process -FilePath $archivo -ArgumentList "-o`"$Destino`"", "-y" -Wait | Out-Null
    if (-not (Test-Path $MameExe)) {
        throw "No aparecio mame.exe. Extraelo a mano: doble clic en $archivo y elige la carpeta $Destino. Luego vuelve a ejecutar este script."
    }
}

function Aplicar-Ajustes {
    if (-not (Test-Path $MameExe)) { throw "No existe $MameExe. Ejecuta el script sin -SoloAjustes." }
    if (-not (Test-Path $MameIni)) { Crear-ConfigBase }

    $copia = "$MameIni.original"
    if (-not (Test-Path $copia)) { Copy-Item $MameIni $copia }

    $lineas   = [IO.File]::ReadAllLines($MameIni)
    $omitidas = 0
    Write-Host ""
    Write-Host "Aplicando ajustes de ajustes-4k-mando.ini:"
    foreach ($a in [IO.File]::ReadAllLines($Ajustes)) {
        $t = $a.Trim()
        if ($t -eq "" -or $t.StartsWith("#")) { continue }
        $partes = $t -split '\s+', 2
        $clave  = $partes[0]
        $valor  = if ($partes.Count -gt 1) { $partes[1] } else { "" }
        $patron = "^" + [regex]::Escape($clave) + "\s"
        $i = -1
        for ($k = 0; $k -lt $lineas.Count; $k++) {
            if ($lineas[$k] -match $patron) { $i = $k; break }
        }
        if ($i -lt 0) {
            Write-Warning "La opcion '$clave' no existe en esta version de MAME; se omite."
            $omitidas++
            continue
        }
        $lineas[$i] = "{0,-26}{1}" -f $clave, $valor
        Write-Host ("  {0,-22} = {1}" -f $clave, $valor)
    }
    [IO.File]::WriteAllLines($MameIni, $lineas, (New-Object Text.UTF8Encoding($false)))
    Write-Host ""
    Write-Host "Listo. mame.ini actualizado (copia del original en mame.ini.original)."
    if ($omitidas -gt 0) { Write-Warning "$omitidas opcion(es) omitidas: revisa los avisos de arriba." }
}

if (-not $SoloAjustes) {
    if (Test-Path $MameExe) {
        throw "Ya existe $MameExe. Para reinstalar, borra la carpeta 'mame' primero (tus ROM y configuraciones estan ahi: respaldalas)."
    }

    if ($Version) { $api = "https://api.github.com/repos/mamedev/mame/releases/tags/mame$Version" }
    else          { $api = "https://api.github.com/repos/mamedev/mame/releases/latest" }
    $rel = Invoke-RestMethod -Uri $api -Headers @{ "User-Agent" = "instalar-mame.ps1" }

    # Versiones recientes (0.289): mameNNNNb_x64.exe; 0.280 y anteriores: mameNNNNb_64bit.exe
    $asset = $rel.assets | Where-Object { $_.name -match '^mame\d+b_x64\.exe$' } | Select-Object -First 1
    if (-not $asset) { $asset = $rel.assets | Where-Object { $_.name -match '^mame\d+b_64bit\.exe$' } | Select-Object -First 1 }
    if (-not $asset) { throw "No encontre el binario de Windows x64 en la version $($rel.tag_name)." }

    $huella = $null
    if ($asset.digest -and ($asset.digest -match '^sha256:([0-9a-fA-F]{64})$')) { $huella = $Matches[1].ToLower() }

    Write-Host ""
    Write-Host "Archivo : $($asset.name)"
    Write-Host "Origen  : $($asset.browser_download_url)"
    Write-Host ("Tamano  : {0:N1} MB ({1} bytes)" -f ($asset.size / 1MB), $asset.size)
    Write-Host "Version : $($rel.tag_name), publicada $($rel.published_at)"
    if ($huella) { Write-Host "SHA-256 publicada por GitHub: $huella" }
    else         { Write-Host "GitHub no publica huella para este archivo: se mostrara la calculada." }
    Write-Host ""
    $r = Read-Host "Descargar e instalar en $Destino ? (S/N)"
    if ($r -notmatch '^[sS]') { Write-Host "Cancelado. No se descargo nada."; exit 0 }

    New-Item -ItemType Directory -Force $Descargas | Out-Null
    $archivo = Join-Path $Descargas $asset.name
    # Sin barra de progreso: en PowerShell 5.1 la barra hace la descarga muchisimo mas lenta.
    $ProgressPreference = "SilentlyContinue"
    Write-Host "Descargando..."
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archivo -UseBasicParsing

    $largo = (Get-Item $archivo).Length
    if ($largo -ne $asset.size) {
        Remove-Item $archivo
        throw "Tamano descargado ($largo) distinto al publicado ($($asset.size)). Archivo borrado."
    }
    $calc = (Get-FileHash -Algorithm SHA256 $archivo).Hash.ToLower()
    Write-Host "SHA-256 calculada: $calc"
    if ($huella -and $calc -ne $huella) {
        Remove-Item $archivo
        throw "La huella no coincide con la publicada. Archivo borrado. No se instala."
    }
    if ($huella) { Write-Host "Huella verificada: coincide con la publicada." }

    Extraer-Instalador $archivo
    Crear-ConfigBase
}

if ($RutaMame -and -not (Test-Path $MameExe)) {
    $inst = Get-ChildItem -Path $Destino -File | Where-Object { $_.Name -match '^mame\d+b_(x64|64bit)\.exe$' } | Select-Object -First 1
    if (-not $inst) { throw "En $Destino no hay mame.exe ni el instalador mameNNNNb_x64.exe." }
    $calc = (Get-FileHash -Algorithm SHA256 $inst.FullName).Hash.ToLower()
    Write-Host ""
    Write-Host "Instalador encontrado: $($inst.Name)  ($([math]::Round($inst.Length / 1MB, 1)) MB)"
    Write-Host "SHA-256: $calc"
    Write-Host "(Si lo bajaste de un sitio que no es mamedev.org o github.com/mamedev, no sigas.)"
    $r = Read-Host "Extraerlo en $Destino ? (S/N)"
    if ($r -notmatch '^[sS]') { Write-Host "Cancelado."; exit 0 }
    Extraer-Instalador $inst.FullName
}

Aplicar-Ajustes
Write-Host ""
Write-Host "Pon tu copia legal del juego (phoenix.zip, sin descomprimir) en: $(Join-Path $Destino 'roms')"
Write-Host "Luego abre jugar-phoenix.bat"
