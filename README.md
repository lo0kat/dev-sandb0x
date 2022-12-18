# dev-sandb0x
## Goal
Leveraging automation tools for local development.

## Installation
### **Requirements**
- linux based OS with GUI (Ubuntu 22.04)
- terraform (v1.3.6)
- qemu_kvm/libvirt/virt-manager

##### **Steps for Installing QEMU/KVM with virt-manager**
**QEMU/KVM** is the virtualization system of linux distributions utilizing Kernel modules to provide a Type 1 hypervisor.
**virt-manager** is a frontend for KVM.

Under a terminal, execute the following commands :
```sh
    $ sudo apt update
    $ sudo apt upgrade
    $ sudo apt install qemu-kvm # virtual package that will change based on CPU architecture
    $ sudo apt install libvirt-daemon-system libvirt-clients # api for virtualization
    $ sudo adduser $USER kvm
    
    # Reboot computer
    $ sudo reboot now

    # Test KVM and virt
    $ groups # to check if $USER is in both kvm and libvirt groups
    $ virsh list --all

    #Install Frontend for Virtualization
    $ sudo apt install virt-manager
```

Edit **_/etc/libvirt/qemu.conf_** to disable SELinux enforced option for QEMU by uncommenting the "security_driver" line and setting its value to "none":
```sh
security_driver = "none"
```
Then, reboot your system to apply the changes.

For more information visit :
- [Github issue for permissions error in libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt/issues/536)
- [Documentation warning for terraform provider libvirt ](https://github.com/dmacvicar/terraform-provider-libvirt/commit/22f096d9)

## VM Provisionning
Under the **vm-prov** directory :
1) Create a **terraform.tfvars** under the **vm-prov** directory:
```sh
# Example of terraform.tfvars
vms = [
  {
    vm_name   = "k3s-master"
    vcpu      = 2
    memory    = 2048
    disk_size = 10737418240 # 10 GiB
  }
  ,
  {
    vm_name   = "k3s-node"
    vcpu      = 4
    memory    = 4096
    disk_size = 10737418240 # 10 GiB
  }
]
```

2) Then execute the following commands: 
```sh
$ terraform init

$ terraform plan

$ terraform apply
```