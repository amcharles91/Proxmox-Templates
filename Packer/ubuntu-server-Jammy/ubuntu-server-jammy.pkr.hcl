packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# resource definition 
source "proxmox-iso" "ubuntu-server" {
  # PACKER Boot Commands
  boot_command = [
    "<esc><wait><wait>c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
    "<enter><wait>",
    "initrd /casper/<wait>initrd",
    "<enter><wait15>",
    "boot<enter>"
  ]
  boot      = "c"
  boot_wait = "5s"


  # Required paramaters
  proxmox_url          = "${var.proxmox_api_url}"
  username             = "${var.proxmox_api_token_id}"
  token                = "${var.proxmox_api_token_secret}"
  template_name        = "${var.template_name}"
  template_description = "${var.template_name} generated at ${timestamp()}"
  iso_file             = "${var.iso_file}"
  #iso_storage_pool     = ""  #Only need this if we downloading hte iso from somewhere
  node                     = "${var.proxmox_node}"
  pool                     = "${var.proxmox_pool_group}" # The pool to create the VM in
  insecure_skip_tls_verify = true
  
  #Machine Configurations
  vm_id       = "${var.vm_id}" # The ID of the VM you want to use as a template
  vm_name     = "${var.template_name}"
  tags        = "ubuntu-jammy;template;packer"
  unmount_iso = true
  qemu_agent  = true
  os          = "${var.proxmox_vm_os}" # sets the machines operating system
  bios        = "ovmf"
  machine     = "q35"
  
  #ssh settings
  ssh_username         = "${var.ssh_username}"
  ssh_private_key_file = "${var.ssh_private_key_file}"

  disks {
    disk_size    = "16G"
    storage_pool = "${var.cloud_storage}"
    io_thread    = false
    cache_mode   = "none"
  }
  
  #cloud init settings
  cloud_init              = true
  cloud_init_storage_pool = "${var.cloud_storage}"
  # VM Memory Settings
  memory             = "${var.vm_memory_max}"
  ballooning_minimum = "${var.vm_memory_min}"
  
  # VM CPU Settings
  cores    = "${var.vm_cpu_cores}"
  cpu_type = "host"

  scsi_controller = "${var.vm_disk_controller}"

  # VM Network Settings
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
    vlan_tag = "${var.vm_network_vlan}"
  }
  
  #efi_config 
  efi_config {
    efi_storage_pool  = "${var.cloud_storage}"
    pre_enrolled_keys = false
    efi_type          = "4m"
  }
  
  # PACKER Autoinstall Settings
  http_directory = "http"
  # (Optional) Bind IP Address and Port
  # http_bind_address = "192.168.x.x"
  # http_port_min = 8802
  # http_port_max = 8802

  # Raise the timeout, when installation takes longer
  ssh_timeout = "10m"
}

# Define the provisioners
build {
  sources = [
    "source.proxmox-iso.ubuntu-server"
  ]

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }
}