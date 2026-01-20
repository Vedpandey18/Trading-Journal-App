# ============================================
# Trading Journal - Start Backend & Frontend
# ============================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Trading Journal - Full Stack" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Flutter
Write-Host "Checking Flutter..." -ForegroundColor Yellow
$flutterPath = "C:\flutter\bin\flutter.bat"
if (-not (Test-Path $flutterPath)) {
    Write-Host "ERROR: Flutter not found at $flutterPath" -ForegroundColor Red
    Write-Host "Please install Flutter or update the path in this script" -ForegroundColor Yellow
    pause
    exit 1
}
Write-Host "Flutter found" -ForegroundColor Green

# Check Maven Wrapper
Write-Host ""
Write-Host "Checking Maven Wrapper..." -ForegroundColor Yellow
$mvnwPath = "backend\mvnw.cmd"
if (-not (Test-Path $mvnwPath)) {
    Write-Host "ERROR: Maven Wrapper not found" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "Maven Wrapper found" -ForegroundColor Green

# Check MySQL (optional check)
Write-Host ""
Write-Host "Checking MySQL connection..." -ForegroundColor Yellow
try {
    $mysqlTest = Test-NetConnection -ComputerName localhost -Port 3306 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    if ($mysqlTest) {
        Write-Host "MySQL is running" -ForegroundColor Green
    } else {
        Write-Host "MySQL not detected (backend will try to connect)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Could not check MySQL" -ForegroundColor Yellow
}

# Check if port 8080 is available
Write-Host ""
Write-Host "Checking port 8080..." -ForegroundColor Yellow
$port8080 = Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
if ($port8080) {
    Write-Host "Port 8080 is already in use!" -ForegroundColor Red
    Write-Host "Please stop the existing backend or change the port" -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit 1
    }
} else {
    Write-Host "Port 8080 is available" -ForegroundColor Green
}

# Start Backend
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Backend (Spring Boot)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Starting backend in new window..." -ForegroundColor Yellow
Write-Host "Backend URL: http://localhost:8080" -ForegroundColor Gray
Write-Host "This may take 30-60 seconds on first run" -ForegroundColor Gray
Write-Host ""

# Start backend in a new minimized window
$currentDir = Get-Location
$backendDir = Join-Path $currentDir "backend"
$backendScript = "cd '$backendDir'; Write-Host 'Starting Spring Boot Backend...' -ForegroundColor Cyan; Write-Host 'Watch for: Started TradingJournalApplication' -ForegroundColor Green; .\mvnw.cmd spring-boot:run"

Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendScript -WindowStyle Minimized

# Wait for backend to start
Write-Host "Waiting for backend to start..." -ForegroundColor Yellow
$backendReady = $false
$maxAttempts = 30
$attempt = 0

while (-not $backendReady -and $attempt -lt $maxAttempts) {
    Start-Sleep -Seconds 2
    $attempt++
    $backendReady = Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    
    if ($backendReady) {
        Write-Host "Backend is running!" -ForegroundColor Green
        break
    } else {
        Write-Host "  Waiting... ($attempt/$maxAttempts)" -ForegroundColor Gray
    }
}

if (-not $backendReady) {
    Write-Host ""
    Write-Host "Backend is taking longer than expected" -ForegroundColor Yellow
    Write-Host "It may still be starting. Check the backend window." -ForegroundColor Yellow
    Write-Host "Continuing with frontend startup..." -ForegroundColor Yellow
    Write-Host ""
}

# Start Frontend
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Frontend (Flutter)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Starting Flutter app in Chrome..." -ForegroundColor Yellow
Write-Host "Backend URL: http://localhost:8080" -ForegroundColor Gray
Write-Host ""

# Change to frontend directory and run Flutter
Set-Location frontend

Write-Host "Running: flutter run -d chrome" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop both frontend and backend" -ForegroundColor Yellow
Write-Host ""

# Run Flutter
& $flutterPath run -d chrome

# Cleanup message
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Application Stopped" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: Backend is still running in the other window." -ForegroundColor Yellow
Write-Host "Close that window to stop the backend." -ForegroundColor Yellow

Set-Location ..
