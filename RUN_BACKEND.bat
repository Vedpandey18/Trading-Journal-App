@echo off
echo ========================================
echo Starting Trading Journal Backend
echo ========================================
echo.
echo Backend will run on: http://localhost:8081
echo Keep this window open!
echo.
echo Press Ctrl+C to stop
echo.

cd backend
call mvnw.cmd spring-boot:run

pause
