@echo off
echo ========================================
echo STARTING TRADING JOURNAL APP
echo ========================================
echo.

echo Step 1: Starting Backend Server...
start "Backend Server" cmd /k "cd backend && mvnw.cmd spring-boot:run"

echo.
echo Waiting 30 seconds for backend to start...
timeout /t 30 /nobreak >nul

echo.
echo Step 2: Starting Frontend...
cd frontend
start "Flutter App" cmd /k "flutter run -d chrome"

echo.
echo ========================================
echo Both services are starting!
echo ========================================
echo.
echo Backend: http://localhost:8081
echo Frontend: Will open in Chrome automatically
echo.
echo IMPORTANT: Clear browser cache if you see errors:
echo   1. Press Ctrl+Shift+Delete
echo   2. Select "Cached images and files"
echo   3. Click "Clear data"
echo.
pause
