@echo off
echo ========================================
echo Starting Trading Journal App
echo ========================================
echo.
echo This will start BOTH backend and frontend
echo Backend: http://localhost:8081
echo Frontend: Opens in Chrome automatically
echo.
echo Two windows will open:
echo   1. Backend (Spring Boot)
echo   2. Frontend (Flutter)
echo.
echo Press any key to start...
pause >nul

echo.
echo Starting Backend...
start "Trading Journal Backend" cmd /k "cd /d %~dp0backend && mvnw.cmd spring-boot:run"

echo Waiting for backend to start (30 seconds)...
timeout /t 30 /nobreak >nul

echo.
echo Starting Frontend...
start "Trading Journal Frontend" cmd /k "cd /d %~dp0frontend && C:\flutter\bin\flutter.bat run -d chrome"

echo.
echo ========================================
echo Both services are starting!
echo ========================================
echo.
echo Backend window: Look for "Started TradingJournalApplication"
echo Frontend window: Will open Chrome automatically
echo.
echo To stop:
echo   - Close backend window to stop backend
echo   - Press Ctrl+C in frontend window to stop frontend
echo.
pause
