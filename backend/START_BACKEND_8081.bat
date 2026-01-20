@echo off
echo ========================================
echo   Starting Trading Journal Backend
echo   Port: 8081
echo ========================================
echo.

cd /d %~dp0

echo Checking prerequisites...
echo.

REM Check Java
java -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java not found!
    pause
    exit /b 1
)
echo [OK] Java found

REM Check Maven Wrapper
if not exist "mvnw.cmd" (
    echo ERROR: Maven Wrapper not found!
    pause
    exit /b 1
)
echo [OK] Maven Wrapper found

echo.
echo Starting Spring Boot backend on port 8081...
echo Database: trading_journal
echo.
echo This may take 30-60 seconds on first run
echo Watch for: "Started TradingJournalApplication"
echo.
echo Press Ctrl+C to stop
echo.

mvnw.cmd spring-boot:run

pause
