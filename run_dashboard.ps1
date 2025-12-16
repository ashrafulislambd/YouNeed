# Script to run the Flutter Dashboard
$ErrorActionPreference = "Stop"

Write-Host "Starting YouNeed Dashboard..." -ForegroundColor Cyan

# Check if Flutter is available
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter is not installed or not in your PATH."
    exit 1
}

# Navigate to the project directory
$projectDir = Join-Path $PSScriptRoot "dashboard"

if (Test-Path $projectDir) {
    Push-Location $projectDir
    Write-Host "Running in: $projectDir" -ForegroundColor Gray
    
    # Get dependencies
    Write-Host "Fetching dependencies..." -ForegroundColor Gray
    flutter pub get
    
    # Run
    Write-Host "Launching app..." -ForegroundColor Green
    flutter run -d emulator-5554
    
    Pop-Location
}
else {
    Write-Error "Could not find project directory at $projectDir"
    exit 1
}
