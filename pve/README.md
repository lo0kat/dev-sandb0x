## Initial Setup
0) Have terraform and packer installed on your machine.
1) Using balenaEtcher (https://www.balena.io/etcher), you can flash the Proxmox VE ISO onto a USB stick.
2) Plug the stick to the host and boot on it. Follow the installation instructions.
3) Once the server is installed, go to the web interface (port 8006) and naviguate to **pve** > **Updates** > **Repositories**. Disable the entreprise repo and add the No-Subscription repo. Make sure DNS is correctly setup. You are then able to update and upgrade.

## Setup the Proxmox provider for Terraform
On the proxmox server, setup the terraform service account with its associated roles:
```sh
$ pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"

$ pveum user add terraform-prov@pve --password <password>

$ pveum aclmod / -user terraform-prov@pve -role TerraformProv
```
On the terraform deployment machine, setup the following provider configuration options :
```sh
export PM_API_URL="https://YOUR_PROXMOX_SERVER_IP:8006/api2/json"
export PM_USER="terraform-prov@pve"
export PM_PASS="YOUR_PASSWORD"
```
