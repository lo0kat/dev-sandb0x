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

resource "proxmox_vm_qemu" "cloudinit-test" {
    name = "terraform-test-vm"
    desc = "A test for using terraform and cloudinit"

    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"


    # The template name to clone this vm from
    clone = "linux-cloudinit-template"

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    sockets = 1
    vcpus = 0
    cpu = "host"
    memory = 2048
    scsihw = "lsi"

    # Setup the disk
    disk {
        type         = "virtio"
        storage      = "local-lvm"
        storage_type = "lvm"
        size         = "4G"
    }

    # Setup the network interface and assign a vlan tag: 256
    network {
        model = "virtio"
        bridge = "vmbr0"
        tag = 256
    }

    # Setup the ip address using cloud-init.
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=192.168.1.200/24,gw=192.168.1.1"

    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfaFHX07UaMUt/lhXTfgiB3zGw8l5ivPimJDXuus4Tc1OMB3bHgGZg+I9BearN4/UzhddXo6S2B754UKHldzEg5uY9kUyOv5w5TOXFPKFm7cZrYaj0oEj2wwG7L3FctuFfltTEAPLjRtba/Et+rFIiZlI/8KHXOJ+S3zsPcglzXvLtg62ldHcLY21Xcy/9oIcg55X7pImllyRbIvoKaCEjr+Lxfy/2gsJs5tvFsJszPHFCVP89jKaJYIxRaPTZjnCU/b51G3G36slY26gXuv1qXVqHr2bn0IvwdOj5Yghy2SMkylPowHqpvmh7Pg2Ux4does/EcaBD4x/tpBuGOeoChHbHc8moOZb4TYILIWVYneXIdZtGCZOtzqQoR2A+sTvjWHEQEwsb/OvgnqbnxXqTdCe2OK8eyugxuj9o6Tr2a13H8+AMK8M6gmIBwYDpTfCFEYo1XM+E0Xc64sRyR7GvieSmXF275bwxCibXgovT3u3vSAsYNGXh2d0aZsZ2//D0V9Sb/uD4hvlctaW/JTz9BNjD8kewyx75CHdhyXEEWUFoCgRQJWp/jCKeA65U+ubpfD7+T4XgvSWD+ncnAzOhXnVQIgnsaezGh+767ThmnvBYDF5pEoZWjlO0hPpZLMSFJmgjDW2PRNT/eW2A5miB6bylLRnhyKSiIcbiuZ2Jkw==
    EOF
}