#!/bin/bash
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
yum check-update
yum install -y code

extensions=("ms-python.python" \
        "formulahendry.code-runner" \
        "peterjausovec.vscode-docker" \
        "ms-vscode.azure-account" \
        "ms-azuretools.vscode-azurestorage" \
        "chrmarti.azure-cli" \
        "ms-vscode.azurecli" \
        "msazurermtools.azurerm-vscode-tools" \
        "tuxtina.json2yaml" \
        "ms-vscode.powershell" \
        "mauve.terraform" \
        "run-at-scale.terraform-doc-snippets" \
        "zhuangtongfa.Material-theme" \ 
        "robertohuertasm.vscode-icons" \
        "jpogran.puppet-vscode")

for i in "${extensions[@]}"
do
    # VSCode will complain if you try to install extensions as a superuser, this bypasses that
    sudo -u vagrant code --install-extension $i 
done

