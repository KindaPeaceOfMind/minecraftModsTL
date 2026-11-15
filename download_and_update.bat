@echo off
chcp 65001 >nul
setlocal

:: ================= SETTINGS =================
:: 1. Repository ZIP URL. Replace USER, REPO and branch (main/master)!
set "REPO_URL=https://github.com/KindaPeaceOfMind/minecraftModsTL/archive/refs/heads/main.zip"
:: 2. Target folder = folder where this script is located
set "TARGET_DIR=%~dp0"
:: =============================================

set "TEMP_ZIP=%TEMP%\github_repo_download.zip"
set "TEMP_EXTRACT=%TEMP%\github_repo_extracted"

echo [1/5] Preparing folders...
if not exist "%TEMP_EXTRACT%" mkdir "%TEMP_EXTRACT%"

echo [2/5] Downloading repository...
curl -L -s -o "%TEMP_ZIP%" "%REPO_URL%"
if %errorlevel% neq 0 (
    echo ERROR: Failed to download archive. Check URL and internet connection.
    pause
    exit /b 1
)

:: Check: Verify if the downloaded file is a ZIP archive
echo [2.5/5] Checking archive format...
:: ZIP archive signature starts with "PK" (hex: 50 4B)
findstr /C:"PK" "%TEMP_ZIP%" >nul
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Downloaded file is NOT a ZIP archive!
    echo This usually means the REPO_URL is incorrect or the repository is private.
    echo.
    echo --- First 10 lines of the downloaded file: ---
    type "%TEMP_ZIP%" | more +0 | findstr /n "^" | findstr /b "^[1-9]:" | findstr /v "^10:"
    echo ------------------------------------------------
    echo.
    echo Please check your REPO_URL and try again.
    pause
    exit /b 1
)

echo [3/5] Extracting files...
tar -xf "%TEMP_ZIP%" -C "%TEMP_EXTRACT%"

echo [4/5] Moving files to target folder...
for /d %%i in ("%TEMP_EXTRACT%\*") do (
    xcopy "%%i\*" "%TARGET_DIR%" /E /Y /Q /H /I >nul
)
del "%TEMP_ZIP%" >nul 2>&1
rmdir /s /q "%TEMP_EXTRACT%" >nul 2>&1

echo [5/5] Running clean_mods.bat...
set "BAT_PATH=%TARGET_DIR%clean_mods.bat"
if exist "%BAT_PATH%" (
    call "%BAT_PATH%"
) else (
    echo.
    echo ERROR: clean_mods.bat not found!
    echo Expected path: %BAT_PATH%
)

echo.
echo Script finished.
pause
endlocal