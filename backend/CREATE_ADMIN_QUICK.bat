@echo off
echo ========================================
echo   Create Admin User - Quick Method
echo ========================================
echo.

echo This will create admin user via API endpoint
echo Make sure backend is running first!
echo.

pause

echo.
echo Creating admin user...
echo.

REM Try to create admin via API
curl -X POST http://localhost:8080/api/admin/create-admin 2>nul

if errorlevel 1 (
    echo.
    echo ERROR: Could not connect to backend
    echo Make sure backend is running on port 8080
    echo.
    echo Alternative: Restart backend to auto-create admin
    echo   cd backend
    echo   mvnw.cmd spring-boot:run
    pause
    exit /b 1
)

echo.
echo Done! Check the response above.
echo.
echo To verify, run in MySQL Workbench:
echo   SELECT * FROM users WHERE username = 'VedPandey18';
echo.

pause
