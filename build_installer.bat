@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo  Building Lighting Network Planner Installer (Inno Setup)
echo ========================================================
echo.

set "ISCC_PATH="

:: 1. Check in PATH
where iscc.exe >nul 2>&1
if !errorlevel! equ 0 (
    set "ISCC_PATH=iscc.exe"
    goto found
)

:: 2. Check standard Inno Setup installation paths
if exist "%LocalAppData%\Programs\Inno Setup 6\ISCC.exe" (
    set "ISCC_PATH=%LocalAppData%\Programs\Inno Setup 6\ISCC.exe"
    goto found
)

if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" (
    set "ISCC_PATH=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
    goto found
)

if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" (
    set "ISCC_PATH=%ProgramFiles%\Inno Setup 6\ISCC.exe"
    goto found
)

echo [ERROR] Inno Setup 6 (ISCC.exe) was not found!
echo Please make sure Inno Setup 6 is installed.
echo Checked locations:
echo  - PATH
echo  - %LocalAppData%\Programs\Inno Setup 6\ISCC.exe
echo  - %ProgramFiles(x86)%\Inno Setup 6\ISCC.exe
echo  - %ProgramFiles%\Inno Setup 6\ISCC.exe
echo.
pause
exit /b 1

:found
echo Found Inno Setup compiler: "!ISCC_PATH!"
echo Compiling installer.iss...
echo.

"!ISCC_PATH!" "%~dp0installer.iss"

if !errorlevel! neq 0 (
    echo.
    echo [ERROR] Compilation failed!
    pause
    exit /b !errorlevel!
)

echo.
echo ========================================================
echo  Installer built successfully!
echo  Location: %~dp0Output\LightingNetworkPlanner-Setup-v1.0.0.exe
echo ========================================================
echo.
pause
