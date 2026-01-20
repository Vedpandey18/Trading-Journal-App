@echo off
echo ========================================
echo   Trading Journal - Start Everything
echo ========================================
echo.

cd /d %~dp0

echo Step 1: Checking MySQL...
netstat -ano | findstr :3306 >nul
if errorlevel 1 (
    echo WARNING: MySQL may not be running on port 3306
    echo Please start MySQL service
    echo.
    timeout /t 3 >nul
) else (
    echo [OK] MySQL is running
)

echo.
echo Step 2: Checking port 8080...
netstat -ano | findstr :8080 >nul
if not errorlevel 1 (
    echo WARNING: Port 8080 is already in use!
    echo.
    choice /C YN /M "Continue anyway"
    if errorlevel 2 exit /b 1
)

echo.
echo Step 3: Starting Backend...
echo This will open in a new window
echo.
start "Trading Journal Backend" cmd /k "cd /d %~dp0backend && mvnw.cmd spring-boot:run"

echo.
echo Waiting 10 seconds for backend to start...
timeout /t 10 >nul

echo.
echo Step 4: Starting Frontend...
echo This will open in a new window
echo.
start "Trading Journal Frontend" cmd /k "cd /d %~dp0frontend && C:\flutter\bin\flutter.bat run -d chrome"

echo.
echo ========================================
echo   Both services are starting!
echo ========================================
echo.
echo Backend: http://localhost:8080
echo Frontend: Will open in Chrome
echo.
echo Wait for backend to fully start (30-60 seconds)
echo Look for: "Started TradingJournalApplication"
echo.
pause
