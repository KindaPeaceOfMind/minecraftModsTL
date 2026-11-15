@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

rem SCRIPT_DIR - папка, где лежит этот скрипт (корень)
set "SCRIPT_DIR=%~dp0"

rem Папка с модами (находится рядом со скриптом)
set "MODS_DIR=%SCRIPT_DIR%mods"

rem Файл со списком модов, которые нужно оставить (в корне)
set "KEEP_LIST=%SCRIPT_DIR%mods_keep.txt"

if not exist "%MODS_DIR%" (
    echo ERROR: Mods folder "%MODS_DIR%" not found.
    pause
    exit /b 1
)

if not exist "%KEEP_LIST%" (
    echo ERROR: File "%KEEP_LIST%" not found.
    echo Please run collect_mods.bat first.
    pause
    exit /b 1
)

cd /d "%MODS_DIR%"

echo Mods folder: %MODS_DIR%
echo Keep list:   %KEEP_LIST%
echo.
echo Files NOT in the list (will be DELETED):
echo ----------------------------------------
set "COUNT=0"
for %%F in (*) do (
    findstr /X /C:"%%~nxF" "%KEEP_LIST%" >nul
    if errorlevel 1 (
        echo   %%~nxF
        set /a COUNT+=1
    )
)
echo ----------------------------------------
echo Total to delete: !COUNT!
echo.

if !COUNT!==0 (
    echo Nothing to delete - all files are in the list.
    pause
    exit /b 0
)

choice /C YN /M "Delete these files"
if errorlevel 2 (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
echo Deleting...
for %%F in (*) do (
    findstr /X /C:"%%~nxF" "%KEEP_LIST%" >nul
    if errorlevel 1 (
        del /F /Q "%%F"
        echo   Deleted: %%~nxF
    )
)

echo.
echo Done.
pause
endlocal