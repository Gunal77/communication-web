# Verify MySQL JDBC Driver Installation
Write-Host "Checking for MySQL JDBC Driver..." -ForegroundColor Cyan
Write-Host ""

$libPath = "src\main\webapp\WEB-INF\lib"
$jarFiles = Get-ChildItem -Path $libPath -Filter "mysql-connector*.jar" -ErrorAction SilentlyContinue

if ($jarFiles) {
    Write-Host "MySQL JDBC Driver found!" -ForegroundColor Green
    Write-Host ""
    $jarFiles | ForEach-Object {
        Write-Host "  File: $($_.Name)" -ForegroundColor White
        Write-Host "  Size: $([math]::Round($_.Length / 1MB, 2)) MB" -ForegroundColor White
        Write-Host "  Path: $($_.FullName)" -ForegroundColor Gray
        Write-Host ""
    }
    Write-Host "Driver is ready to use!" -ForegroundColor Green
} else {
    Write-Host "MySQL JDBC Driver NOT found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "1. Download MySQL Connector/J from:" -ForegroundColor White
    Write-Host "   https://dev.mysql.com/downloads/connector/j/" -ForegroundColor Cyan
    Write-Host "2. Select 'Platform Independent' from dropdown" -ForegroundColor White
    Write-Host "3. Download the ZIP file" -ForegroundColor White
    Write-Host "4. Extract and find the JAR file (mysql-connector-j-*.jar)" -ForegroundColor White
    Write-Host "5. Copy the JAR file to:" -ForegroundColor White
    Write-Host "   $libPath" -ForegroundColor Cyan
    Write-Host ""
    
    if (Test-Path $libPath) {
        Write-Host "lib directory exists: $libPath" -ForegroundColor Green
    } else {
        Write-Host "Creating lib directory..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Force -Path $libPath | Out-Null
        Write-Host "Created: $libPath" -ForegroundColor Green
    }
}

