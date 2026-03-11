$ErrorActionPreference = 'Stop'

Write-Host 'Downloading FSLogix...'
$url = 'https://aka.ms/fslogix_download'
$zip = 'C:\\fslogix.zip'
$extract = 'C:\\fslogix'

Invoke-WebRequest -Uri $url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $extract -Force

Write-Host 'Installing FSLogix...'
& "$extract\\x64\\Release\\FSLogixAppsSetup.exe" /install /quiet /norestart

Write-Host 'Waiting for install to complete...'
Start-Sleep -Seconds 30

Write-Host 'FSLogix install complete.'
