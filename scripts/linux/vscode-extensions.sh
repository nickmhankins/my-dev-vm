#!/bin/bash
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
        "run-at-scale.terraform-doc-snippets")

for i in "${extensions[@]}"
do
    code --install-extension $i
done

