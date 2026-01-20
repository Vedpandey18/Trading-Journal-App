@echo off
echo ========================================
echo   Fix Network Error - Complete Solution
echo ========================================
echo.

cd /d %~dp0

echo Step 1: Checking Backend...
netstat -ano | findstr :8080 >nul
if errorlevel 1 (
    echo [ERROR] Backend is NOT running on port 8080
    echo.
    echo Starting backend now...
    echo.
    start "Trading Journal Backend" cmd /k "cd /d %~dp0backend && mvnw.cmd spring-boot:run"
    echo.
    echo Backend is starting. Please wait 30-60 seconds...
    echo Watch for: "Started TradingJournalApplication"
    echo.
    timeout /t 5 >nul
) else (
    echo [OK] Backend is running on port 8080
)

echo.
echo Step 2: Checking MySQL...
netstat -ano | findstr :3306 >nul
if errorlevel 1 (
    echo [WARNING] MySQL may not be running
) else (
    echo [OK] MySQL is running
)

echo.
echo Step 3: Testing Backend API...
curl -s http://localhost:8080/api/admin/check-admin >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Backend API not responding yet
    echo If backend just started, wait 10-15 seconds and refresh browser
) else (
    echo [OK] Backend API is responding
)

echo.
echo ========================================
echo   Next Steps:
echo ========================================
echo.
echo 1. If backend just started, wait for:
echo    "Started TradingJournalApplication"
echo.
echo 2. Refresh your browser (F5) or restart Flutter
echo.
echo 3. Try logging in again
echo.
echo ========================================
pause
