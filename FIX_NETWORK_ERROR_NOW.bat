@echo off
echo ========================================
echo FIXING NETWORK ERROR - COMPLETE SOLUTION
echo ========================================
echo.

echo Step 1: Checking backend status...
netstat -ano | findstr :8081 >nul
if %errorlevel% == 0 (
    echo [OK] Backend is running on port 8081
    echo.
    echo IMPORTANT: Backend needs to be RESTARTED to load new HealthController
    echo.
    echo Please:
    echo   1. Go to backend terminal
    echo   2. Press Ctrl+C to stop backend
    echo   3. Run: mvnw.cmd spring-boot:run
    echo   4. Wait for "Started TradingJournalApplication"
    echo.
) else (
    echo [ERROR] Backend is NOT running
    echo.
    echo Starting backend...
    cd backend
    start "Backend Server" cmd /k "mvnw.cmd spring-boot:run"
    cd ..
    echo.
    echo Backend is starting... Please wait 30 seconds
    timeout /t 30 /nobreak >nul
)

echo.
echo Step 2: Testing backend connection...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8081/api/auth/login' -Method OPTIONS -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop; Write-Host '[OK] Backend is responding' -ForegroundColor Green } catch { Write-Host '[WARNING] Backend may not be fully started yet' -ForegroundColor Yellow }"

echo.
echo Step 3: Configuration Check...
echo.
echo Backend Port: 8081
echo Frontend API URL: http://localhost:8081/api
echo.
echo ========================================
echo FIXES TO APPLY:
echo ========================================
echo.
echo 1. RESTART BACKEND (Required!)
echo    - Stop current backend (Ctrl+C)
echo    - Run: cd backend ^&^& mvnw.cmd spring-boot:run
echo.
echo 2. CLEAR BROWSER CACHE
echo    - Press Ctrl+Shift+Delete
echo    - Select "Cached images and files"
echo    - Click "Clear data"
echo.
echo 3. RESTART FRONTEND
echo    - In Flutter terminal, press 'R' for hot restart
echo    - Or close and restart: flutter run -d chrome
echo.
echo 4. TEST CONNECTION
echo    - Open browser: http://localhost:8081/api/health
echo    - Should see: {"status":"UP","message":"Backend is running"}
echo.
echo ========================================
pause
