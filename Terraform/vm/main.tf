resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.servervms

  // General Information
  name        = "${each.value.name}0${each.value.index}"
  description = each.value.desc
  pool_id     = each.value.target_pool
  node_name   = each.value.target_node
  tags        = each.value.tags
  bios        = var.generalconfig.bios
  boot_order  = var.generalconfig.boot_order
  machine     = var.generalconfig.machine
  // Other general settings...
  
  dynamic "clone" {
    for_each = each.value.clone_target != null ? [each.value.clone_target] : []
    content {
      vm_id = clone.value
      retries = 3
    }
  }

  #cloud init

  initialization {
    datastore_id = each.value.datastore_id

    dynamic "ip_config" {
      for_each = each.value.ip_config != null ? [each.value.ip_config] : []
      content {
        ipv4 {
          address = ip_config.value.address
          gateway = ip_config.value.address != "dhcp" ? ip_config.value.gateway : null
        }
      }
    }

    #    ip_config {
    #      ipv4 {
    #        address = each.value.ip4config
    #      }
    #    }
  }

  // Hardware Blocks
  memory {
    dedicated = each.value.memory
    // Other memory settings...
  }

  cpu {
    cores = each.value.cpu_cores
    type  = var.generalconfig.cpu_type
    // Other CPU settings...
  }

  disk {
    size         = each.value.disk_size
    interface    = each.value.disk_interface
    datastore_id = each.value.datastore_id
    // Other disk settings...
  }

  network_device {
    bridge  = each.value.network_bridge
    vlan_id = each.value.vlan_id
  }

  // Additional hardware configurations like audio_device, cdrom, efi_disk, hostpci, usb...

  // Agent, if used
  agent {
    enabled = each.value.agent_enabled
  }

  // Additional configurations...
}

//noinspection HILUnresolvedReference
resource "local_file" "ansible_inventory" {
  depends_on = [proxmox_virtual_environment_vm.vm]

  content = templatefile("inventory.tmpl", {
    vm_user = var.proxmox_vm_user
    servers = {
      for k, v in proxmox_virtual_environment_vm.vm :
      v.name => length(v.ipv4_addresses) > 1 && length(v.ipv4_addresses[1]) > 0 ? v.ipv4_addresses[1][0] : (length(v.ipv4_addresses) > 0 && length(v.ipv4_addresses[0]) > 0 ? v.ipv4_addresses[0][0] : "")
    }
    clients = {}
  })
  filename = "${path.module}/inventory"
}
