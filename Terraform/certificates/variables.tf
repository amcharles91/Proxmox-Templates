variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_vm_user" {
  type = string
}

variable "pm_tls_insecure" {
  type    = string
  default = false
}
