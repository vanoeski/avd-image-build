$ErrorActionPreference = 'Stop'

Write-Host 'Downloading VDOT...'
$url = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip'
$zip = 'C:\\vdot.zip'
$extract = 'C:\\vdot'

Invoke-WebRequest -Uri $url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $extract -Force

Write-Host 'Running VDOT...'
$vdotPath = Get-ChildItem -Path $extract -Filter 'Windows_VDOT.ps1' -Recurse | Select-Object -First 1

Set-ExecutionPolicy Bypass -Scope Process -Force
& $vdotPath.FullName -Optimizations All -AdvancedOptimizations All -AcceptEULA

Write-Host 'VDOT complete.'
