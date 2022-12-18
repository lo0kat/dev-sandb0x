terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "virtual_machines" {
  source = "./modules/vm"

  count     = length(var.vms)
  vm_name   = var.vms[count.index].vm_name
  vcpu      = var.vms[count.index].vcpu
  memory    = var.vms[count.index].memory
  disk_size = var.vms[count.index].disk_size
}