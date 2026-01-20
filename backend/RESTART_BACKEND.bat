@echo off
echo ========================================
echo RESTARTING BACKEND SERVER
echo ========================================
echo.

echo Stopping any existing backend processes...
taskkill /F /IM java.exe /FI "WINDOWTITLE eq *Backend*" 2>nul
timeout /t 2 /nobreak >nul

echo.
echo Starting backend on port 8081...
echo.
cd /d %~dp0
call mvnw.cmd spring-boot:run
