variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
}

variable "vcpu" {
  description = "Number of VCPUs allocated for the Virtual Machine"
  type        = number
}

variable "memory" {
  description = "Amount of memory dedicated to the Virtual Machine"
  type        = number
}

variable "disk_size" {
  description = "Size of the initial volume for the Virtual Machine"
  type        = number
}
