# Flutter Setup Helper Script
# This script helps you set up Flutter for the Trading Journal app

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Setup Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already installed
Write-Host "Checking for Flutter installation..." -ForegroundColor Yellow
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterPath) {
    Write-Host "✓ Flutter is already installed!" -ForegroundColor Green
    Write-Host "  Location: $($flutterPath.Source)" -ForegroundColor Gray
    Write-Host ""
    
    # Check Flutter version
    Write-Host "Checking Flutter version..." -ForegroundColor Yellow
    flutter --version
    Write-Host ""
    
    # Check Flutter doctor
    Write-Host "Running Flutter doctor..." -ForegroundColor Yellow
    flutter doctor
    Write-Host ""
    
    Write-Host "Flutter is ready to use!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To run the frontend:" -ForegroundColor Cyan
    Write-Host "  cd frontend" -ForegroundColor White
    Write-Host "  flutter pub get" -ForegroundColor White
    Write-Host "  flutter run" -ForegroundColor White
    exit 0
}

Write-Host "✗ Flutter is not installed or not in PATH" -ForegroundColor Red
Write-Host ""

# Check common installation locations
Write-Host "Checking common Flutter installation locations..." -ForegroundColor Yellow
$commonPaths = @(
    "C:\flutter",
    "C:\src\flutter",
    "$env:USERPROFILE\flutter",
    "$env:LOCALAPPDATA\flutter"
)

$foundFlutter = $false
foreach ($path in $commonPaths) {
    $flutterBat = Join-Path $path "bin\flutter.bat"
    if (Test-Path $flutterBat) {
        Write-Host "✓ Found Flutter at: $path" -ForegroundColor Green
        Write-Host ""
        Write-Host "To add Flutter to PATH:" -ForegroundColor Cyan
        Write-Host "  1. Open System Properties → Environment Variables" -ForegroundColor White
        Write-Host "  2. Edit 'Path' variable" -ForegroundColor White
        Write-Host "  3. Add: $path\bin" -ForegroundColor White
        Write-Host "  4. Restart terminal" -ForegroundColor White
        Write-Host ""
        Write-Host "Or use Flutter directly:" -ForegroundColor Cyan
        Write-Host "  & '$flutterBat' pub get" -ForegroundColor White
        Write-Host "  & '$flutterBat' run" -ForegroundColor White
        $foundFlutter = $true
        break
    }
}

if (-not $foundFlutter) {
    Write-Host "Flutter not found in common locations." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Installation Options" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Option 1: Install Flutter SDK (Command Line)" -ForegroundColor Yellow
    Write-Host "  1. Download Flutter SDK:" -ForegroundColor White
    Write-Host "     https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Cyan
    Write-Host "  2. Extract to C:\flutter (or your preferred location)" -ForegroundColor White
    Write-Host "  3. Add C:\flutter\bin to PATH environment variable" -ForegroundColor White
    Write-Host "  4. Restart terminal and run this script again" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Option 2: Use Android Studio (Easier)" -ForegroundColor Yellow
    Write-Host "  1. Download Android Studio:" -ForegroundColor White
    Write-Host "     https://developer.android.com/studio" -ForegroundColor Cyan
    Write-Host "  2. Install Flutter plugin:" -ForegroundColor White
    Write-Host "     File → Settings → Plugins → Search 'Flutter' → Install" -ForegroundColor White
    Write-Host "  3. Open frontend folder in Android Studio" -ForegroundColor White
    Write-Host "  4. Click Run button" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Option 3: Use VS Code" -ForegroundColor Yellow
    Write-Host "  1. Download VS Code:" -ForegroundColor White
    Write-Host "     https://code.visualstudio.com/" -ForegroundColor Cyan
    Write-Host "  2. Install Flutter extension" -ForegroundColor White
    Write-Host "  3. Open frontend folder" -ForegroundColor White
    Write-Host "  4. Press F5 to run" -ForegroundColor White
    Write-Host ""
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Quick Setup" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Would you like to open Flutter download page?" -ForegroundColor Yellow
    Write-Host "  (This will open the download page in your browser)" -ForegroundColor Gray
    Write-Host ""
    $download = Read-Host "Open Flutter download page? (y/n)"
    
    if ($download -eq 'y') {
        Start-Process "https://docs.flutter.dev/get-started/install/windows"
        Write-Host ""
        Write-Host "After downloading and extracting Flutter:" -ForegroundColor Cyan
        Write-Host "  1. Extract to C:\flutter" -ForegroundColor White
        Write-Host "  2. Run this command in PowerShell (as Administrator):" -ForegroundColor White
        Write-Host "     [Environment]::SetEnvironmentVariable('Path', `$env:Path + ';C:\flutter\bin', 'User')" -ForegroundColor Cyan
        Write-Host "  3. Restart terminal" -ForegroundColor White
        Write-Host "  4. Run this script again to verify" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "For more help, see: frontend/FLUTTER_SETUP_GUIDE.md" -ForegroundColor Gray
