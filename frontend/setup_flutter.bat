@echo off
echo ========================================
echo Flutter Setup Helper
echo ========================================
echo.

REM Check if Flutter is available
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Flutter is already installed!
    echo.
    flutter --version
    echo.
    echo Flutter is ready to use!
    echo.
    echo To run the frontend:
    echo   flutter pub get
    echo   flutter run
    pause
    exit /b 0
)

echo [ERROR] Flutter is not installed or not in PATH
echo.

REM Check common locations
echo Checking common Flutter installation locations...
if exist "C:\flutter\bin\flutter.bat" (
    echo [FOUND] Flutter at C:\flutter
    echo.
    echo To add Flutter to PATH:
    echo   1. Open System Properties -^> Environment Variables
    echo   2. Edit 'Path' variable
    echo   3. Add: C:\flutter\bin
    echo   4. Restart terminal
    echo.
    echo Or use Flutter directly:
    echo   C:\flutter\bin\flutter.bat pub get
    echo   C:\flutter\bin\flutter.bat run
    pause
    exit /b 0
)

echo Flutter not found in common locations.
echo.
echo ========================================
echo Installation Options
echo ========================================
echo.
echo Option 1: Install Flutter SDK
echo   1. Download: https://flutter.dev/docs/get-started/install/windows
echo   2. Extract to C:\flutter
echo   3. Add C:\flutter\bin to PATH
echo   4. Restart terminal
echo.
echo Option 2: Use Android Studio (Easier)
echo   1. Download: https://developer.android.com/studio
echo   2. Install Flutter plugin
echo   3. Open frontend folder
echo   4. Click Run button
echo.
echo Option 3: Use VS Code
echo   1. Download: https://code.visualstudio.com/
echo   2. Install Flutter extension
echo   3. Open frontend folder
echo   4. Press F5 to run
echo.
pause
