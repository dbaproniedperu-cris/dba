@echo off
rem Abre Phoenix en MAME con los ajustes aplicados por instalar-mame.ps1.
rem Requiere roms\phoenix.zip (copia legal, sin descomprimir) dentro de la carpeta de MAME.
rem Busca MAME primero en la carpeta "mame" junto a este archivo y luego en C:\IAPRG\game.
set "MAME_DIR=%~dp0mame"
if not exist "%MAME_DIR%\mame.exe" set "MAME_DIR=C:\IAPRG\game"
if not exist "%MAME_DIR%\mame.exe" (
  echo Falta MAME. Ejecuta primero instalar-mame.ps1
  pause
  exit /b 1
)
cd /d "%MAME_DIR%"
mame.exe phoenix
if errorlevel 1 pause
