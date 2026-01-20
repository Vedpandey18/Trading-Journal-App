@echo off
echo ========================================
echo Flutter Setup Check
echo ========================================
echo.

REM Check if Flutter is available
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Flutter is installed!
    echo.
    flutter --version
    echo.
    echo To run the app:
    echo   flutter pub get
    echo   flutter run
    pause
    exit /b 0
)

echo [INFO] Flutter is not in PATH
echo.
echo ========================================
echo Setup Options
echo ========================================
echo.
echo Option 1: Install Flutter SDK
echo   1. Download: https://docs.flutter.dev/get-started/install/windows
echo   2. Extract to C:\flutter
echo   3. Add C:\flutter\bin to PATH
echo   4. Restart terminal
echo.
echo Option 2: Use Android Studio (Easier)
echo   1. Download: https://developer.android.com/studio
echo   2. Install Flutter plugin
echo   3. Open frontend folder
echo   4. Click Run
echo.
echo Option 3: Use VS Code
echo   1. Download: https://code.visualstudio.com/
echo   2. Install Flutter extension
echo   3. Open frontend folder
echo   4. Press F5
echo.
echo ========================================
echo.
echo See QUICK_FLUTTER_SETUP.md for details
echo.
pause
