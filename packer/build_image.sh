#!/bin/bash

set -euo pipefail

export PACKER_LOG_PATH="/tmp/packer.log"
export PACKER_LOG=10

echo "Parsing installer.bu ..."
docker run -i --rm quay.io/coreos/butane:release --pretty --strict < config/installer.bu > config/installer.ign
echo "Parsing done"

echo "Parsing template.bu ..."
docker run -i --rm quay.io/coreos/butane:release  --pretty --strict < config/template.bu > config/template.ign
echo "Parsing done"

echo "Building image with packer"
packer build fedora-cloud-proxmox.json
