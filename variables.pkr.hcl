variable "subscription_id" {
  type    = string
}

variable "tenant_id" {
  type    = string
}

variable "client_id" {
  type    = string
}

variable "resource_group_build" {
  type    = string
  default = "rg-imagebuilder-lab"
}

variable "resource_group_gallery" {
  type    = string
  default = "rg-imagegallery-lab"
}

variable "gallery_name" {
  type    = string
  default = "acg_avd_lab"
}

variable "image_definition" {
  type    = string
  default = "win11-avd-base"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}
