# Comprehensive Check Script for All Components
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPREHENSIVE INSTALLATION CHECK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# 1. Check Java
Write-Host "1. CHECKING JAVA..." -ForegroundColor Yellow
$javaFound = $false

# Check if java is in PATH
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "   [OK] Java found in PATH" -ForegroundColor Green
    Write-Host "   Version: $javaVersion" -ForegroundColor Gray
    $javaFound = $true
} catch {
    Write-Host '   [X] Java not in PATH' -ForegroundColor Red
    
    # Check common installation paths
    $commonJavaPaths = @(
        "$env:ProgramFiles\Java\jdk*",
        "$env:ProgramFiles(x86)\Java\jdk*",
        "C:\Program Files\Java\jdk*",
        "$env:LOCALAPPDATA\Programs\Java\jdk*"
    )
    
    foreach ($path in $commonJavaPaths) {
        $javaDirs = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($javaDirs) {
            Write-Host ('   [OK] Java found at: ' + $javaDirs.FullName) -ForegroundColor Green
            Write-Host ('   [INFO] Add to PATH or set JAVA_HOME: ' + $javaDirs.FullName) -ForegroundColor Yellow
            $javaFound = $true
            break
        }
    }
    
    if (-not $javaFound) {
        Write-Host '   [X] Java not found. Please install JDK.' -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""

# 2. Check MySQL JDBC Driver
Write-Host "2. CHECKING MYSQL JDBC DRIVER..." -ForegroundColor Yellow
$libPath = "src\main\webapp\WEB-INF\lib"
if (Test-Path $libPath) {
    $jarFiles = Get-ChildItem -Path $libPath -Filter "mysql-connector*.jar" -ErrorAction SilentlyContinue
    if ($jarFiles) {
        Write-Host "   [OK] MySQL JDBC Driver found" -ForegroundColor Green
        $jarFiles | ForEach-Object {
            $sizeMB = [math]::Round($_.Length / 1MB, 2)
            Write-Host ('   File: ' + $_.Name + ' (' + $sizeMB + ' MB)') -ForegroundColor Gray
        }
    } else {
        Write-Host ('   [X] MySQL JDBC Driver NOT found in: ' + $libPath) -ForegroundColor Red
        Write-Host '   [INFO] Copy mysql-connector-j-*.jar to this folder' -ForegroundColor Yellow
        $allGood = $false
    }
} else {
    Write-Host ('   [X] lib directory not found: ' + $libPath) -ForegroundColor Red
    $allGood = $false
}

Write-Host ""

# 3. Check Tomcat
Write-Host "3. CHECKING APACHE TOMCAT..." -ForegroundColor Yellow
$tomcatFound = $false
$commonTomcatPaths = @(
    "$env:ProgramFiles\Apache Software Foundation\Tomcat*",
    "$env:ProgramFiles(x86)\Apache Software Foundation\Tomcat*",
    "C:\Program Files\Apache Software Foundation\Tomcat*",
    "C:\apache-tomcat*",
    "$env:USERPROFILE\Downloads\apache-tomcat*",
    "$env:USERPROFILE\Desktop\apache-tomcat*"
)

foreach ($path in $commonTomcatPaths) {
    $tomcatDirs = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($tomcatDirs) {
        $servletApi = Join-Path $tomcatDirs.FullName "lib\servlet-api.jar"
        if (Test-Path $servletApi) {
            Write-Host "   [OK] Tomcat found at: $($tomcatDirs.FullName)" -ForegroundColor Green
            Write-Host "   [OK] servlet-api.jar found" -ForegroundColor Green
            $tomcatFound = $true
            break
        }
    }
}

# Also check Downloads folder more thoroughly
$downloadsPath = "$env:USERPROFILE\Downloads"
if (Test-Path $downloadsPath) {
    $tomcatDirs = Get-ChildItem -Path $downloadsPath -Filter "apache-tomcat*" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($tomcatDirs) {
        $servletApi = Join-Path $tomcatDirs.FullName "lib\servlet-api.jar"
        if (Test-Path $servletApi) {
            Write-Host "   [OK] Tomcat found in Downloads: $($tomcatDirs.FullName)" -ForegroundColor Green
            Write-Host "   [INFO] Consider moving to: C:\apache-tomcat-9.0.xx" -ForegroundColor Yellow
            $tomcatFound = $true
        }
    }
}

if (-not $tomcatFound) {
    Write-Host '   [X] Tomcat not found in common locations' -ForegroundColor Red
    Write-Host '   [INFO] If you downloaded it, extract the ZIP file' -ForegroundColor Yellow
    Write-Host '   [INFO] Common location: C:\apache-tomcat-9.0.xx' -ForegroundColor Yellow
    $allGood = $false
}

Write-Host ""

# 4. Check Database Configuration
Write-Host "4. CHECKING DATABASE CONFIGURATION..." -ForegroundColor Yellow
$dbConfig = "src\main\resources\database.properties"
if (Test-Path $dbConfig) {
    Write-Host "   [OK] database.properties found" -ForegroundColor Green
    $content = Get-Content $dbConfig
    $hasUrl = $content | Select-String -Pattern "db.url"
    $hasUser = $content | Select-String -Pattern "db.username"
    $hasPass = $content | Select-String -Pattern "db.password"
    
    if ($hasUrl -and $hasUser -and $hasPass) {
        Write-Host "   [OK] Database configuration complete" -ForegroundColor Green
    } else {
        Write-Host '   [X] Database configuration incomplete' -ForegroundColor Red
        $allGood = $false
    }
} else {
    Write-Host '   [X] database.properties not found' -ForegroundColor Red
    $allGood = $false
}

Write-Host ""

# 5. Check SQL Schema
Write-Host "5. CHECKING SQL SCHEMA..." -ForegroundColor Yellow
$sqlSchema = "sql\schema.sql"
if (Test-Path $sqlSchema) {
    Write-Host "   [OK] schema.sql found" -ForegroundColor Green
    Write-Host "   [INFO] Run this in MySQL to create database" -ForegroundColor Yellow
} else {
    Write-Host '   [X] schema.sql not found' -ForegroundColor Red
    $allGood = $false
}

Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($allGood) {
    Write-Host "[SUCCESS] All components are ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Make sure MySQL is running" -ForegroundColor White
    Write-Host "2. Run sql/schema.sql in MySQL" -ForegroundColor White
    Write-Host "3. Start Tomcat (run startup.bat from bin folder)" -ForegroundColor White
    Write-Host "4. Run deploy.ps1 to compile and deploy" -ForegroundColor White
} else {
    Write-Host "[ACTION NEEDED] Some components are missing or not configured" -ForegroundColor Yellow
    Write-Host ""
    Write-Host 'Please fix the items marked with [X] above' -ForegroundColor White
}

Write-Host ""

