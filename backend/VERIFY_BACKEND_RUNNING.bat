@echo off
echo ========================================
echo Backend Connection Verification
echo ========================================
echo.

echo Checking if backend is running on port 8081...
netstat -ano | findstr :8081 >nul
if %errorlevel% == 0 (
    echo [OK] Backend is running on port 8081
) else (
    echo [ERROR] Backend is NOT running on port 8081
    echo.
    echo Please start the backend:
    echo   cd backend
    echo   mvnw.cmd spring-boot:run
    echo.
    pause
    exit /b 1
)

echo.
echo Testing backend health endpoint...
curl -s http://localhost:8081/api/health >nul
if %errorlevel% == 0 (
    echo [OK] Backend health check passed
) else (
    echo [WARNING] Backend health check failed
    echo This might be normal if curl is not installed
)

echo.
echo Testing backend auth endpoint...
curl -s http://localhost:8081/api/auth/test >nul
if %errorlevel% == 0 (
    echo [OK] Backend auth endpoint is accessible
) else (
    echo [WARNING] Backend auth endpoint check failed
    echo This might be normal if curl is not installed
)

echo.
echo ========================================
echo Verification Complete
echo ========================================
echo.
echo If backend is running, the frontend should be able to connect.
echo If you still see network errors, try:
echo   1. Refresh the browser (Ctrl+F5)
echo   2. Clear browser cache
echo   3. Restart the frontend
echo.
pause
