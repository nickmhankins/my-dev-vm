#!/bin/bash
yum install -y unzip
curl -O https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
unzip ./terraform_0.11.8_linux_amd64.zip -d /usr/local/bin
rm -f ./terraform_0.11.8_linux_amd64.zip
export PATH=$PATH:/usr/local/bin