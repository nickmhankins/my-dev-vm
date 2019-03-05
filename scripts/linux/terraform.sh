#!/bin/bash
yum install -y unzip
curl -O https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
unzip ./terraform_0.11.11_linux_amd64.zip -d /usr/local/bin
rm -f ./terraform_0.11.11_linux_amd64.zip
echo "export PATH=$PATH:/usr/local/bin" >> /etc/bashrc