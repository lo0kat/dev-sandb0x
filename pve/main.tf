terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
}


resource "proxmox_vm_qemu" "k3s-test-worker" {
  name = "k3s-test-worker"
  desc = "k3s test worker node"
  target_node ="pve"
  os_type = "centos"
  full_clone = true
  memory = 6144
  sockets = 1
  cores = 4
  cpu = "host"
  scsihw = "virtio-scsi-pci"
  clone = "coreos-37"
  agent = 1
  qemu_os = "l26"
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disk {
    type = "virtio"
    storage = "local-lvm"
    size = "30G"
  }
  
#  connection {
#     type     = "ssh"
#     user     = "core"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "echo 'toto'",
#     ]
#   }

}
