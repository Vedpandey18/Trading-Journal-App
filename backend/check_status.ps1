# Check Backend Status
Write-Host "Checking Trading Journal Backend Status..." -ForegroundColor Cyan
Write-Host ""

# Check Java processes
$javaProcesses = Get-Process -Name java -ErrorAction SilentlyContinue
if ($javaProcesses) {
    Write-Host "✓ Java processes running: $($javaProcesses.Count)" -ForegroundColor Green
    $javaProcesses | ForEach-Object {
        Write-Host "  - PID: $($_.Id), Started: $($_.StartTime)" -ForegroundColor Gray
    }
} else {
    Write-Host "✗ No Java processes found" -ForegroundColor Red
}

Write-Host ""

# Check if port 8080 is listening
$port8080 = Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue
if ($port8080) {
    Write-Host "✓ Backend is running on http://localhost:8080" -ForegroundColor Green
    Write-Host ""
    Write-Host "API Endpoints:" -ForegroundColor Yellow
    Write-Host "  - POST http://localhost:8080/api/auth/register" -ForegroundColor Gray
    Write-Host "  - POST http://localhost:8080/api/auth/login" -ForegroundColor Gray
    Write-Host "  - GET  http://localhost:8080/api/trades" -ForegroundColor Gray
    Write-Host "  - GET  http://localhost:8080/api/analytics" -ForegroundColor Gray
} else {
    Write-Host "✗ Backend is not responding on port 8080" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible issues:" -ForegroundColor Yellow
    Write-Host "  1. Application is still starting (wait 30-60 seconds)" -ForegroundColor Gray
    Write-Host "  2. MySQL database is not running" -ForegroundColor Gray
    Write-Host "  3. Database connection error (check application.properties)" -ForegroundColor Gray
    Write-Host "  4. Port 8080 is already in use" -ForegroundColor Gray
}

Write-Host ""

# Check MySQL
$mysqlService = Get-Service -Name "*mysql*" -ErrorAction SilentlyContinue
if ($mysqlService) {
    Write-Host "✓ MySQL service found: $($mysqlService.Name) - Status: $($mysqlService.Status)" -ForegroundColor Green
} else {
    Write-Host "⚠ MySQL service not found in common locations" -ForegroundColor Yellow
    Write-Host "  Make sure MySQL is installed and running" -ForegroundColor Gray
}

Write-Host ""
Write-Host "To view logs, check the console where you ran: .\mvnw.cmd spring-boot:run" -ForegroundColor Cyan
