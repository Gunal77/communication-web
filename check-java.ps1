# Quick Java Check Script
Write-Host "Checking Java installation..." -ForegroundColor Cyan
Write-Host ""

# Check if java is in PATH
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "Java found in PATH!" -ForegroundColor Green
    Write-Host $javaVersion
    Write-Host ""
    
    # Check javac
    try {
        $javacVersion = javac -version 2>&1
        Write-Host "Java compiler (javac) found!" -ForegroundColor Green
        Write-Host $javacVersion
    } catch {
        Write-Host "javac not found in PATH" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Java is ready to use!" -ForegroundColor Green
    
} catch {
    Write-Host "Java not found in PATH!" -ForegroundColor Red
    Write-Host ""
    Write-Host "If you just installed Java, you may need to:" -ForegroundColor Yellow
    Write-Host "1. Restart your terminal/PowerShell" -ForegroundColor White
    Write-Host "2. Or restart your computer" -ForegroundColor White
    Write-Host "3. Or manually add Java to PATH" -ForegroundColor White
    Write-Host ""
    Write-Host "Common Java installation paths:" -ForegroundColor Cyan
    Write-Host "  C:\Program Files\Java\jdk-25" -ForegroundColor White
    Write-Host "  C:\Program Files\Java\jdk-25.0.1" -ForegroundColor White
}

