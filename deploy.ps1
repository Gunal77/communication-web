# Deployment Script for JSP Servlet Application
param(
    [string]$TomcatPath = "",
    [string]$JavaHome = ""
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deployment Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Find Java
if ($JavaHome -eq "") {
    if ($env:JAVA_HOME) {
        $JavaHome = $env:JAVA_HOME
        Write-Host "Using JAVA_HOME: $JavaHome" -ForegroundColor Green
    } else {
        Write-Host "JAVA_HOME not set. Please provide Java path:" -ForegroundColor Yellow
        Write-Host "  .\deploy.ps1 -JavaHome 'C:\Program Files\Java\jdk-11'" -ForegroundColor Cyan
        exit 1
    }
}

# Find Tomcat
if ($TomcatPath -eq "") {
    $commonPaths = @(
        "$env:ProgramFiles\Apache Software Foundation\Tomcat*",
        "$env:ProgramFiles(x86)\Apache Software Foundation\Tomcat*",
        "C:\Program Files\Apache Software Foundation\Tomcat*",
        "C:\apache-tomcat*"
    )
    
    foreach ($path in $commonPaths) {
        $tomcatDirs = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($tomcatDirs) {
            $TomcatPath = $tomcatDirs.FullName
            Write-Host "Found Tomcat at: $TomcatPath" -ForegroundColor Green
            break
        }
    }
    
    if ($TomcatPath -eq "") {
        Write-Host "Tomcat not found. Please provide Tomcat path:" -ForegroundColor Yellow
        Write-Host "  .\deploy.ps1 -TomcatPath 'C:\apache-tomcat-9.0.xx'" -ForegroundColor Cyan
        exit 1
    }
}

# Check for servlet-api.jar
$servletApi = Join-Path $TomcatPath "lib\servlet-api.jar"
if (-not (Test-Path $servletApi)) {
    Write-Host "servlet-api.jar not found at: $servletApi" -ForegroundColor Red
    exit 1
}

# Check for MySQL connector
$mysqlConnector = Get-ChildItem -Path "src\main\webapp\WEB-INF\lib\mysql-connector*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $mysqlConnector) {
    Write-Host "MySQL JDBC Driver not found in WEB-INF/lib/" -ForegroundColor Red
    Write-Host "Please download and add mysql-connector-j-*.jar" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Step 1: Compiling Java classes..." -ForegroundColor Yellow

# Create classes directory
$classesDir = "src\main\webapp\WEB-INF\classes"
New-Item -ItemType Directory -Force -Path $classesDir | Out-Null

# Compile Java files
$javaFiles = Get-ChildItem -Path "src\main\java" -Filter "*.java" -Recurse
$classpath = "$servletApi;$($mysqlConnector.FullName)"

$javac = Join-Path $JavaHome "bin\javac.exe"
if (-not (Test-Path $javac)) {
    Write-Host "javac.exe not found at: $javac" -ForegroundColor Red
    exit 1
}

Write-Host "Compiling with: $javac" -ForegroundColor Cyan
Write-Host "Classpath: $classpath" -ForegroundColor Cyan

& $javac -cp $classpath -d $classesDir -encoding UTF-8 $javaFiles.FullName

if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Compilation successful!" -ForegroundColor Green
Write-Host ""

# Copy resources
Write-Host "Step 2: Copying resources..." -ForegroundColor Yellow
$resourcesSource = "src\main\resources"
$resourcesDest = Join-Path $classesDir "..\..\..\resources"
if (Test-Path $resourcesSource) {
    Copy-Item -Path "$resourcesSource\*" -Destination $resourcesDest -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Resources copied" -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 3: Deploying to Tomcat..." -ForegroundColor Yellow

$webappDest = Join-Path $TomcatPath "webapps\communication-web"
if (Test-Path $webappDest) {
    Write-Host "Removing existing deployment..." -ForegroundColor Yellow
    Remove-Item -Path $webappDest -Recurse -Force
}

Write-Host "Copying webapp to: $webappDest" -ForegroundColor Cyan
Copy-Item -Path "src\main\webapp\*" -Destination $webappDest -Recurse -Force

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Make sure MySQL is running" -ForegroundColor White
Write-Host "2. Start Tomcat (if not running)" -ForegroundColor White
Write-Host "3. Access: http://localhost:8080/communication-web/" -ForegroundColor White
Write-Host ""
Write-Host "Default credentials:" -ForegroundColor Cyan
Write-Host "  Admin: admin / admin123" -ForegroundColor White
Write-Host "  Officer: officer1 / officer123" -ForegroundColor White

