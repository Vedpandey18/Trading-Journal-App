# Quick Backend Status Check
Write-Host "`n=== Backend Status Check ===" -ForegroundColor Cyan
Write-Host ""

# Check if port 8080 is listening
$portCheck = Test-NetConnection -ComputerName localhost -Port 8080 -InformationLevel Quiet -WarningAction SilentlyContinue

if ($portCheck) {
    Write-Host "✓✓✓ BACKEND IS RUNNING! ✓✓✓" -ForegroundColor Green
    Write-Host ""
    Write-Host "Backend URL: http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Test it with:" -ForegroundColor Yellow
    Write-Host '  $body = ''{"username":"test","email":"test@test.com","password":"test123"}''' -ForegroundColor Gray
    Write-Host '  Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method POST -ContentType "application/json" -Body $body' -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "✗ Backend is NOT running" -ForegroundColor Red
    Write-Host ""
    Write-Host "To start the backend:" -ForegroundColor Yellow
    Write-Host "  1. Open a terminal" -ForegroundColor Gray
    Write-Host "  2. Run: cd backend" -ForegroundColor Gray
    Write-Host "  3. Run: .\mvnw.cmd spring-boot:run" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Look for this message:" -ForegroundColor Yellow
    Write-Host "  'Started TradingJournalApplication'" -ForegroundColor Green
}

Write-Host ""
