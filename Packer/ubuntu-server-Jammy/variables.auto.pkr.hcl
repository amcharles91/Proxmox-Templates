# Define varibles to be referenced
variable "proxmox_api_url" {
  type = string
}
variable "proxmox_api_token_id" {
  type = string
}
variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}
variable "ssh_username" {
  description = "The user to create on this template"
  type        = string
}
variable "ssh_private_key_file" {
  description = "The file path to your private ssh key"
  type        = string
}
#VM Settings
variable "vm_id" {
  description = "The ID of the VM you want to use as a template"
  type        = number
  default     = 901
}
variable "iso_file" {
  description = "The iso you want to install"
  type        = string
}
variable "template_name" {
  description = "The template name"
  type        = string
}
variable "proxmox_node" {
  description = "The node to run the build on"
  type        = string
}
variable "proxmox_pool_group" {
  description = "The logical pool group to tie this vm template too."
  type        = string
}
variable "proxmox_vm_os" {
  description = "The type of os to use, default is l26."
  type        = string
  default     = "l26"
}
variable "vm_cpu_cores" {
  description = "The type of os to use, default is other."
  type        = number
  default     = 1
}
variable "cloud_storage" {
  description = "The storage to store the cloud init drive in."
  type        = string
  default     = "local"
}
variable "vm_disk_controller" {
  description = "The disk controller to use for the default storage"
  type        = string
  default     = "virtio-scsi-pci"
}
variable "vm_memory_max" {
  description = "The Max amount of ram to give the template. default is 1024"
  type        = number
  default     = 4096
}
variable "vm_memory_min" {
  description = "The minimum amount of ram to give the template with balloning. default is 0 for disable"
  type        = number
  default     = 1024
}
variable "vm_network_vlan" {
  description = "The vlan this template should use"
  type        = number
  default     = -1
}