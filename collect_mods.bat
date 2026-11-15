@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

rem SCRIPT_DIR - folder where this script is located (root)
set "SCRIPT_DIR=%~dp0"

rem Mods folder (located next to this script)
set "MODS_DIR=%SCRIPT_DIR%mods"

rem Output file for the keep list (in the root folder)
set "KEEP_LIST=%SCRIPT_DIR%mods_keep.txt"

if not exist "%MODS_DIR%" (
    echo ERROR: Mods folder "%MODS_DIR%" not found.
    pause
    exit /b 1
)

echo Scanning mods folder: %MODS_DIR%
echo.

rem Remove the old keep list file
if exist "%KEEP_LIST%" del "%KEEP_LIST%"

rem Collect all files from the mods folder
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