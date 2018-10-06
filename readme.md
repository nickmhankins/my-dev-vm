# CentOS VM for DevOps things

## What?
This VM is used for developing infrastructure in Azure with Terraform, and scripting in Python, PowerShell, and Bash.

## Why?
My current Dev environment is Windows 10 with [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10).  While the obfuscation is cool, it's not ideal when you want to know _exactly_ what your dev environment consists of, and how to make it repeatable across machines/environments.  When a Windows update inevitably [removes user data](https://it.slashdot.org/story/18/10/05/1246202/windows-10-october-2018-update-is-deleting-user-data-for-many), I don't want to spend time fixing something that Microsoft [failed to QA properly](https://www.theverge.com/2018/10/6/17944966/microsoft-windows-10-october-2018-update-documents-deleted-issues-windows-update-paused). 

This VM is meant to break the habit of using WSL and eventually using Windows at all. My preferred scripting languange, PowerShell,  is now [open-source](https://github.com/PowerShell/PowerShell), so why not use this opportunity to get comfortable with other Operating Systems?  [Python will get you further](https://stackoverflow.blog/2017/09/06/incredible-growth-python/) than PowerShell in cross-platform automation, so this a good next step.

## Mind the Gap - IDE/Git on Windows when developing for Linux

### CRLF vs LF
When writing code that will be deployed and committed using Linux systems using an IDE on Windows, you need to be aware of the difference between `LF` and `CRLF`, and [when to use which.](https://stackoverflow.com/questions/1552749/difference-between-cr-lf-lf-and-cr-line-break-types)  Windows doesn't really care which one you use, but Linux is very particular about LF. 

#### Configuring Git
Add this to your `.gitconfig.`
```json 
[core]
	autocrlf = false
```
#### Configuring Visual Studio Code
Add this line to your `settings.json`
```json
"file.eol": "\n",
```

#### Terraform
[According the documentation](https://www.terraform.io/guides/running-terraform-in-automation.html), you cannot run `terraform plan` on a Windows machine and then run `terraform apply` on that same plan on a Linux machine.  Pass your git repo folder through to the Vagrant Linux guest and make sure you're running your terraform commands in the right console!

## Requirements
You have the option of using either **Hyper-V** or **Virtualbox**.
## Building

### Hyper-V
```
packer build -only=hyperv-iso centos75.json
```
### VirtualBox
```
packer build -only=virtualbox-iso centos75.json
```

## Vagrant
Packer will export the VM you create as a Vagrant box in the build directory, which you can start by typing at the root folder (where the `Vagrantfile` lives):
```
vagrant up
```

You may need to edit the Vagrantfile to reflect your setup, such as your private key name, etc.

#### SSH Keys
I wanted my Vagrant machine to use the SSH keypair from my host, here are the steps, summarized

* Vagrant will initially SSH to the guest using the built-in insecure Vagrant key
* The file provisioner transfers my private key from the host to the VM
* Use the file provisioner again to overwrite the `authorized_keys` file in the guest with the contents of my public key from the host, making the insecure Vagrant key unusable.
* Since the `config.ssh.private_key_path` in my Vagrant file provides an array of keys, it will use the first one that works, which happens to the private key from my host, the one we transfered to the VM earlier

## Why not just create a Docker container for all this?
Shut up, I'm working on it.
