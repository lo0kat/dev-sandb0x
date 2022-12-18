variable "vms" {
  type = list(object({
    vm_name   = string
    vcpu      = number
    memory    = number
    disk_size = number
  }))
}