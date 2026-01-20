# Start Trading Journal Backend
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Trading Journal Backend" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Java
$javaVersion = java -version 2>&1 | Select-String "version"
if ($javaVersion) {
    Write-Host "✓ Java: $javaVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Java not found!" -ForegroundColor Red
    exit 1
}

# Check MySQL
$mysqlService = Get-Service -Name "*mysql*" -ErrorAction SilentlyContinue
if ($mysqlService -and $mysqlService.Status -eq 'Running') {
    Write-Host "✓ MySQL service is running" -ForegroundColor Green
} else {
    Write-Host "⚠ MySQL service not found or not running" -ForegroundColor Yellow
    Write-Host "  Please ensure MySQL is installed and running" -ForegroundColor Yellow
    Write-Host "  The application will try to connect to:" -ForegroundColor Gray
    Write-Host "    - Host: localhost:3306" -ForegroundColor Gray
    Write-Host "    - Database: trading_journal" -ForegroundColor Gray
    Write-Host "    - Username: root" -ForegroundColor Gray
    Write-Host "    - Password: root (check application.properties)" -ForegroundColor Gray
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        exit 1
    }
}

Write-Host ""
Write-Host "Starting Spring Boot application..." -ForegroundColor Yellow
Write-Host "This may take 30-60 seconds on first run" -ForegroundColor Gray
Write-Host ""

# Start the application
Set-Location $PSScriptRoot
.\mvnw.cmd spring-boot:run
