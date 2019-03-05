#!/bin/bash
curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo
yum install -y powershell
pwsh -command "& {Set-PSRepository PSGallery -InstallationPolicy Trusted; Install-Module Az}"