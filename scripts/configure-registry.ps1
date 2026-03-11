$ErrorActionPreference = 'Stop'

Write-Host 'Configuring FSLogix registry settings...'

# FSLogix profile container settings
$fslogixKey = 'HKLM:\\SOFTWARE\\FSLogix\\Profiles'
If (-not (Test-Path $fslogixKey)) { New-Item -Path $fslogixKey -Force }

Set-ItemProperty -Path $fslogixKey -Name 'Enabled'         -Value 1     -Type DWord
Set-ItemProperty -Path $fslogixKey -Name 'VHDLocations'    -Value '\\\\your-storage\\profiles' -Type MultiString
Set-ItemProperty -Path $fslogixKey -Name 'DeleteLocalProfileWhenVHDShouldApply' -Value 1 -Type DWord
Set-ItemProperty -Path $fslogixKey -Name 'FlipFlopProfileDirectoryName' -Value 1 -Type DWord

Write-Host 'Configuring AVD registry tweaks...'

# Disable automatic Windows Update reboots
$auKey = 'HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU'
If (-not (Test-Path $auKey)) { New-Item -Path $auKey -Force }
Set-ItemProperty -Path $auKey -Name 'NoAutoRebootWithLoggedOnUsers' -Value 1 -Type DWord

Write-Host 'Registry configuration complete.'
