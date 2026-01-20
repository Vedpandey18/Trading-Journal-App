@echo off
echo Starting Trading Journal Frontend...
echo.

REM Check if Flutter is available
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Flutter found. Installing dependencies and running...
    flutter pub get
    flutter run
) else (
    echo Flutter not found in PATH.
    echo.
    echo Please install Flutter or add it to your PATH.
    echo.
    echo Steps to install Flutter:
    echo 1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
    echo 2. Extract to a location (e.g., C:\flutter)
    echo 3. Add C:\flutter\bin to your PATH environment variable
    echo 4. Run: flutter doctor
    echo.
    pause
)
