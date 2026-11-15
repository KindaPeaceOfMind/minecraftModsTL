@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

rem SCRIPT_DIR - папка, где лежит этот скрипт (корень)
set "SCRIPT_DIR=%~dp0"

rem Папка с модами (находится рядом со скриптом)
set "MODS_DIR=%SCRIPT_DIR%mods"

rem Файл для сохранения списка (в корне)
set "KEEP_LIST=%SCRIPT_DIR%mods_keep.txt"

if not exist "%MODS_DIR%" (
    echo ERROR: Mods folder "%MODS_DIR%" not found.
    pause
    exit /b 1
)

echo Scanning mods folder: %MODS_DIR%
echo.

rem Очищаем старый файл списка
if exist "%KEEP_LIST%" del "%KEEP_LIST%"

rem Собираем все файлы из папки mods
set "COUNT=0"
for %%F in ("%MODS_DIR%\*") do (
    echo %%~nxF>>"%KEEP_LIST%"
    echo   Found: %%~nxF
    set /a COUNT+=1
)

echo.
echo ----------------------------------------
echo Total files collected: !COUNT!
echo List saved to: %KEEP_LIST%
echo.
echo You can now edit this file to remove mods you want to delete.
echo Then run download_and_update.bat to apply changes.
echo ----------------------------------------
pause
endlocal