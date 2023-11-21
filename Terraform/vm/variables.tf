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

variable "generalconfig" {
  type = object({
    bios             = string
    machine          = string
    boot_order       = list(string)
    cpu_type         = string
    network_bridge   = string
    operating_system = string
  })
  default = {
    bios             = "ovmf"    // Example default value
    machine          = "q35"     // Example default value
    boot_order       = ["scsi0"] // Example default value
    cpu_type         = "host"    // Example default value
    network_bridge   = "vmbr0"   // Example default value
    operating_system = "l26"     // Example default value
  }
}

variable "servervms" {
  type = map(
    object(
      {
        index          = number
        name           = string
        desc           = string
        tags           = list(string)
        clone_target   = number
        memory         = number
        cpu_cores      = number
        datastore_id   = string //local-zfs
        disk_size      = number
        disk_interface = string
        network_bridge = string
        ip_config = object({
          address = string
          gateway = string
        })
        vlan_id       = number
        agent_enabled = bool
        agent_trim    = bool
        target_node   = string
        target_pool   = string
      }
    )
  )
  default = {
    "vm1" = {
      index          = 1
      name           = "examplevm"
      desc           = "Example VM 1 Description"
      tags           = ["tag1", "tag2"]
      clone_target   = 916
      memory         = 4096
      cpu_cores      = 2
      datastore_id   = "local-zfs"
      disk_size      = "32"
      disk_interface = "scsi0"
      network_bridge = "vmbr0"
      ip_config = {
        address = "dhcp"
        gateway = null
      }
      vlan_id       = 150
      agent_enabled = true
      agent_trim    = true
      target_node   = "node1"
      target_pool   = "home"
    },
    "vm2" = {
      index          = 2
      name           = "examplevm"
      desc           = "Example VM 1 Description"
      tags           = ["tag1", "tag2"]
      clone_target   = 916
      memory         = 4096
      cpu_cores      = 2
      datastore_id   = "local-zfs"
      disk_size      = "32"
      disk_interface = "scsi0"
      network_bridge = "vmbr0"
      ip_config = {
        address = "dhcp"
        gateway = null
      }
      vlan_id       = 150
      agent_enabled = true
      agent_trim    = true
      target_node   = "node1"
      target_pool   = "home"
    },
    "vm3" = {
      index          = 3
      name           = "examplevm"
      desc           = "Example VM 1 Description"
      tags           = ["tag1", "tag2"]
      clone_target   = 916
      memory         = 4096
      cpu_cores      = 2
      datastore_id   = "local-zfs"
      disk_size      = "32"
      disk_interface = "scsi0"
      network_bridge = "vmbr0"
      ip_config = {
        address = "dhcp"
        gateway = null
      }
      vlan_id       = 150
      agent_enabled = true
      agent_trim    = true
      target_node   = "node2"
      target_pool   = "home"
    }
    // Add more VM configurations as needed
  }
}
