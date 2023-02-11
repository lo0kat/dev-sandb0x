terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.0"
    }
  }
}

resource "libvirt_pool" "storage_pool" {
  name = var.vm_name
  type = "dir"
  path = "/home/louis/Infra/storage/${var.vm_name}"
}

# Base volume from the cloud Image 
resource "libvirt_volume" "base" {
  name   = "${var.vm_name}-base"
  pool   = libvirt_pool.storage_pool.name
  source = "/home/louis/Infra/img/Fedora-Cloud-Base-37-1.7.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "main_volume" {
  name           = "${var.vm_name}-main-volume"
  base_volume_id = libvirt_volume.base.id
  pool           = libvirt_pool.storage_pool.name
  size           = var.disk_size # in bytes
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.storage_pool.name
}

# Create the machine
resource "libvirt_domain" "vm_domain" {
  name        = var.vm_name
  description = "development"
  memory      = var.memory
  vcpu        = var.vcpu
  cloudinit   = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.main_volume.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}