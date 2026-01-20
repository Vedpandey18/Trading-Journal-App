@echo off
echo ========================================
echo   Trading Journal - Frontend
echo ========================================
echo.

cd /d %~dp0

echo Checking Flutter...
C:\flutter\bin\flutter.bat --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Flutter not found at C:\flutter
    echo Please install Flutter or update the path in this script
    pause
    exit /b 1
)

echo.
echo Checking backend connection...
powershell -Command "Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet" >nul 2>&1
if errorlevel 1 (
    echo WARNING: Backend not detected on port 8080
    echo Make sure backend is running before using the app
    echo.
    timeout /t 3 >nul
)

echo.
echo Starting Flutter app in Chrome...
echo Backend URL: http://localhost:8080
echo.
echo Press Ctrl+C to stop
echo.

C:\flutter\bin\flutter.bat run -d chrome

pause
