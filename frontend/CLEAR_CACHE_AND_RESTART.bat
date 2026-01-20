@echo off
echo ========================================
echo CLEARING CACHE AND RESTARTING FRONTEND
echo ========================================
echo.

echo Step 1: Clearing Flutter build cache...
cd /d %~dp0
flutter clean
echo.

echo Step 2: Getting dependencies...
flutter pub get
echo.

echo Step 3: Starting Flutter app...
echo.
echo IMPORTANT: After app starts, clear browser cache:
echo   1. Press Ctrl+Shift+Delete
echo   2. Select "Cached images and files"
echo   3. Click "Clear data"
echo   4. Refresh browser (Ctrl+F5)
echo.
flutter run -d chrome
