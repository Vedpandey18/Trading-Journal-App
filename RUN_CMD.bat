@echo off
echo ========================================
echo   Trading Journal - Command Prompt
echo ========================================
echo.

REM Navigate to project root
cd /d %~dp0

echo Current directory: %CD%
echo.

echo Choose an option:
echo.
echo 1. Start BOTH Backend and Frontend
echo 2. Start Backend ONLY
echo 3. Start Frontend ONLY
echo 4. Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto start_both
if "%choice%"=="2" goto start_backend
if "%choice%"=="3" goto start_frontend
if "%choice%"=="4" goto end
goto invalid

:start_both
echo.
echo Starting both backend and frontend...
echo.
call start_all.bat
goto end

:start_backend
echo.
echo Starting backend...
echo.
cd backend
call mvnw.cmd spring-boot:run
goto end

:start_frontend
echo.
echo Starting frontend...
echo.
cd frontend
C:\flutter\bin\flutter.bat run -d chrome
goto end

:invalid
echo.
echo Invalid choice! Please run again and select 1-4.
pause
goto end

:end
echo.
pause
