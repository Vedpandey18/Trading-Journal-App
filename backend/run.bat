@echo off
echo Starting Trading Journal Backend...
echo.

REM Check if Maven is available
where mvn >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Maven found. Building and running...
    mvn spring-boot:run
) else (
    echo Maven not found in PATH.
    echo.
    echo Please install Maven or add it to your PATH.
    echo.
    echo Alternatively, you can:
    echo 1. Install Maven from https://maven.apache.org/download.cgi
    echo 2. Or use an IDE like IntelliJ IDEA or Eclipse to run the application
    echo 3. Or use the Maven wrapper (mvnw) if available
    echo.
    pause
)
