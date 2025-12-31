# JSP Servlet Application Setup Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "JSP Servlet Application Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Java
Write-Host "Step 1: Checking Java installation..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "Java found!" -ForegroundColor Green
    Write-Host $javaVersion
} catch {
    Write-Host "Java not found in PATH!" -ForegroundColor Red
    Write-Host "Please install JDK 8 or higher from: https://www.oracle.com/java/technologies/downloads/" -ForegroundColor Yellow
    Write-Host "Or set JAVA_HOME environment variable" -ForegroundColor Yellow
}

Write-Host ""

# Step 2: Check if lib directory exists
Write-Host "Step 2: Checking WEB-INF/lib directory..." -ForegroundColor Yellow
$libPath = "src\main\webapp\WEB-INF\lib"
if (Test-Path $libPath) {
    Write-Host "lib directory exists" -ForegroundColor Green
    $jarFiles = Get-ChildItem -Path $libPath -Filter "*.jar" -ErrorAction SilentlyContinue
    if ($jarFiles) {
        Write-Host "Found JAR files:" -ForegroundColor Green
        $jarFiles | ForEach-Object { Write-Host "  - $($_.Name)" }
    } else {
        Write-Host "No JAR files found in lib directory!" -ForegroundColor Red
        Write-Host "Please download MySQL JDBC Driver:" -ForegroundColor Yellow
        Write-Host "  https://dev.mysql.com/downloads/connector/j/" -ForegroundColor Cyan
        Write-Host "  Copy mysql-connector-j-*.jar to: $libPath" -ForegroundColor Yellow
    }
} else {
    Write-Host "Creating lib directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $libPath | Out-Null
    Write-Host "lib directory created" -ForegroundColor Green
}

Write-Host ""

# Step 3: Check database.properties
Write-Host "Step 3: Checking database configuration..." -ForegroundColor Yellow
$dbConfig = "src\main\resources\database.properties"
if (Test-Path $dbConfig) {
    Write-Host "database.properties found" -ForegroundColor Green
    Write-Host "Current configuration:" -ForegroundColor Cyan
    Get-Content $dbConfig | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    Write-Host "Please update credentials if needed!" -ForegroundColor Yellow
} else {
    Write-Host "database.properties not found!" -ForegroundColor Red
}

Write-Host ""

# Step 4: Check SQL schema
Write-Host "Step 4: Checking SQL schema..." -ForegroundColor Yellow
$sqlSchema = "sql\schema.sql"
if (Test-Path $sqlSchema) {
    Write-Host "schema.sql found" -ForegroundColor Green
    Write-Host "Run this SQL script in MySQL to create the database" -ForegroundColor Yellow
} else {
    Write-Host "schema.sql not found!" -ForegroundColor Red
}

Write-Host ""

# Step 5: Check Tomcat
Write-Host "Step 5: Checking for Tomcat..." -ForegroundColor Yellow
$commonTomcatPaths = @(
    "$env:ProgramFiles\Apache Software Foundation\Tomcat*",
    "$env:ProgramFiles(x86)\Apache Software Foundation\Tomcat*",
    "C:\Program Files\Apache Software Foundation\Tomcat*",
    "C:\apache-tomcat*"
)

$tomcatFound = $false
foreach ($path in $commonTomcatPaths) {
    $tomcatDirs = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
    if ($tomcatDirs) {
        Write-Host "Tomcat found at:" -ForegroundColor Green
        $tomcatDirs | ForEach-Object { Write-Host "  $($_.FullName)" }
        $tomcatFound = $true
        break
    }
}

if (-not $tomcatFound) {
    Write-Host "Tomcat not found in common locations" -ForegroundColor Yellow
    Write-Host "Download from: https://tomcat.apache.org/download-90.cgi" -ForegroundColor Cyan
}

Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. Install/Setup MySQL and run sql/schema.sql" -ForegroundColor White
Write-Host "2. Download MySQL JDBC Driver to WEB-INF/lib/" -ForegroundColor White
Write-Host "3. Update database.properties with your MySQL credentials" -ForegroundColor White
Write-Host "4. Install Apache Tomcat" -ForegroundColor White
Write-Host "5. Compile Java classes (need servlet-api.jar from Tomcat)" -ForegroundColor White
Write-Host "6. Deploy webapp folder to Tomcat's webapps directory" -ForegroundColor White
Write-Host "7. Start Tomcat and access: http://localhost:8080/communication-web/" -ForegroundColor White
Write-Host ""
Write-Host "See SETUP_GUIDE.txt for detailed instructions" -ForegroundColor Cyan

