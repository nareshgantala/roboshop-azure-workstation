#!/bin/bash

echo Install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo -y
sudo yum -y install terraform

echo download azure cli rpm
sudo rpm --import https://packages.microsoft.com/keys/microsoft-2025.asc
echo insatall azure cli rpm package
sudo dnf install -y https://packages.microsoft.com/config/rhel/10/packages-microsoft-prod.rpm
echo install azure cli
sudo dnf install azure-cli -y