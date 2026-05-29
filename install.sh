#!/bin/bash
# Stop script if any individual command fails
set -e

echo "Install terraform"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo -y
sudo yum -y install terraform

echo "download azure cli rpm"
sudo rpm --import https://packages.microsoft.com/keys/microsoft-2025.asc

echo "install azure cli rpm package"
sudo dnf install -y https://packages.microsoft.com/config/rhel/10/packages-microsoft-prod.rpm

echo "install azure cli"
sudo dnf -y install azure-cli

echo "download kind"
if [ "$(uname -m)" = "x86_64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
else
    echo "Skipping kind: Not an x86_64 architecture"
fi

echo "download kubectl"
# FIX: Hardcode a reliable version to avoid curl network dependency failures
KUBECTL_VERSION="v1.30.0"

# Add -f flag to curl so it fails explicitly if the URL is wrong
curl -LOf "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

echo "install kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Clean up local file
rm -f kubectl

echo "All installations completed successfully!"