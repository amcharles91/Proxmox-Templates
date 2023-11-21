# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token_id
  insecure  = var.pm_tls_insecure
}