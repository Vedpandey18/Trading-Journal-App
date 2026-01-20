@echo off
echo ========================================
echo Starting Trading Journal Frontend
echo ========================================
echo.
echo Make sure backend is running first!
echo Backend URL: http://localhost:8081
echo.
echo Press Ctrl+C to stop
echo.

cd frontend
call C:\flutter\bin\flutter.bat run -d chrome

pause
