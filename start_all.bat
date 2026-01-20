@echo off
echo ========================================
echo   Trading Journal - Full Stack
echo ========================================
echo.

REM Check if PowerShell is available
powershell -Command "exit 0" >nul 2>&1
if errorlevel 1 (
    echo ERROR: PowerShell is required
    echo Please use start_all.ps1 instead
    pause
    exit /b 1
)

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0start_all.ps1"

pause
