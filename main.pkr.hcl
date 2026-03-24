packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.0"
    }
  }
}

source "azure-arm" "win11_avd" {
  # Auth — uses environment from az login (OIDC via pipeline)
  use_azure_cli_auth = true
  subscription_id    = var.subscription_id

  # Build VM location
  location         = var.location
  vm_size          = var.vm_size
  build_resource_group_name = var.resource_group_build

  # Source image — Windows 11 multi-session 23H2
  image_publisher = "MicrosoftWindowsDesktop"
  image_offer     = "windows-11"
  image_sku       = "win11-23h2-avd"
  image_version   = "latest"

  # OS disk
  os_type    = "Windows"
  os_disk_size_gb = 128

  # WinRM for Packer to connect to the VM
  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "10m"
  winrm_username = "packer"

  # Publish to Compute Gallery
  shared_image_gallery_destination {
    subscription        = var.subscription_id
    resource_group      = var.resource_group_gallery
    gallery_name        = var.gallery_name
    image_name          = var.image_definition
    image_version       = formatdate("YYYY.MM.DD", timestamp())
    replication_regions = [var.location]
  }
}

build {
  name    = "avd-win11-base"
  sources = ["source.azure-arm.win11_avd"]

  # Windows Updates first (can take 20-40 min)
  provisioner "powershell" {
    inline = [
      "Write-Host 'Installing Windows Updates...'",
      "Install-PackageProvider -Name NuGet -Force -Scope AllUsers",
      "Install-Module -Name PSWindowsUpdate -Force -Scope AllUsers",
      "Get-WindowsUpdate -Install -AcceptAll -AutoReboot | Out-File C:\\packer-wu.log"
    ]
  }

  # Wait for reboot after updates
  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  # Run provisioner scripts in order
  provisioner "powershell" {
    scripts = [
      "${path.root}/scripts/install-fslogix.ps1",
      "${path.root}/scripts/run-vdot.ps1",
      "${path.root}/scripts/configure-registry.ps1",
    ]
  }

  # Final reboot before sysprep
  provisioner "windows-restart" {
    restart_timeout = "15m"
  }
}
