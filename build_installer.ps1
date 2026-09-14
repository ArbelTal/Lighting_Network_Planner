# PowerShell script to build Inno Setup installer
$ErrorActionPreference = "Stop"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host " Building Lighting Network Planner Installer (Inno Setup)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$isccPath = $null

# Check PATH
$cmd = Get-Command iscc.exe -ErrorAction SilentlyContinue
if ($cmd) {
    $isccPath = $cmd.Source
} else {
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
    )
    foreach ($path in $candidates) {
        if (Test-Path $path) {
            $isccPath = $path
            break
        }
    }
}

if (-not $isccPath) {
    Write-Error "Inno Setup 6 (ISCC.exe) not found! Please install Inno Setup 6."
    exit 1
}

Write-Host "Found Inno Setup compiler: $isccPath" -ForegroundColor Green
$issFile = Join-Path $PSScriptRoot "installer.iss"
Write-Host "Compiling $issFile..." -ForegroundColor Yellow
Write-Host ""

& $isccPath $issFile

if ($LASTEXITCODE -eq 0) {
    $outputExe = Join-Path $PSScriptRoot "Output\LightingNetworkPlanner-Setup-v1.0.0.exe"
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host " Installer built successfully!" -ForegroundColor Green
    Write-Host " File: $outputExe" -ForegroundColor Green
    if (Test-Path $outputExe) {
        $sizeMB = [Math]::Round(((Get-Item $outputExe).Length / 1MB), 2)
        Write-Host " Size: $sizeMB MB" -ForegroundColor Green
    }
    Write-Host "========================================================" -ForegroundColor Green
} else {
    Write-Error "Compilation failed with exit code $LASTEXITCODE."
}
