# Start Trading Journal Backend and Database
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Trading Journal - Starting Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check MySQL
Write-Host "Checking MySQL..." -ForegroundColor Yellow
$mysqlServices = Get-Service -Name "*mysql*" -ErrorAction SilentlyContinue
if ($mysqlServices) {
    foreach ($service in $mysqlServices) {
        if ($service.Status -eq 'Running') {
            Write-Host "✓ MySQL is running: $($service.Name)" -ForegroundColor Green
        } else {
            Write-Host "⚠ MySQL service found but not running: $($service.Name)" -ForegroundColor Yellow
            Write-Host "  Please start MySQL from XAMPP/WAMP or MySQL Workbench" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "⚠ MySQL service not found in Windows services" -ForegroundColor Yellow
    Write-Host "  Make sure MySQL is installed and running" -ForegroundColor Gray
    Write-Host "  Start it from:" -ForegroundColor Gray
    Write-Host "    - XAMPP Control Panel" -ForegroundColor Gray
    Write-Host "    - WAMP Control Panel" -ForegroundColor Gray
    Write-Host "    - MySQL Workbench" -ForegroundColor Gray
}

Write-Host ""

# Check if port 8080 is available
Write-Host "Checking port 8080..." -ForegroundColor Yellow
$port8080 = Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue
if ($port8080) {
    Write-Host "⚠ Port 8080 is already in use!" -ForegroundColor Red
    Write-Host "  Another application is using port 8080" -ForegroundColor Gray
    Write-Host "  Please stop it or change port in application.properties" -ForegroundColor Gray
    exit 1
} else {
    Write-Host "✓ Port 8080 is available" -ForegroundColor Green
}

Write-Host ""

# Start Backend
Write-Host "Starting Spring Boot Backend..." -ForegroundColor Yellow
Write-Host "This will take 30-60 seconds on first run" -ForegroundColor Gray
Write-Host "Watch for: 'Started TradingJournalApplication'" -ForegroundColor Green
Write-Host ""

Set-Location $PSScriptRoot
.\mvnw.cmd spring-boot:run
