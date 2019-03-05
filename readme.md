# CentOS dev VM

## If using Windows to develop for Linux

### CRLF vs LF
When writing code that will be deployed and committed using Linux systems using an IDE on Windows, you need to be aware of the difference between `LF` and `CRLF`, and [when to use which.](https://stackoverflow.com/questions/1552749/difference-between-cr-lf-lf-and-cr-line-break-types)  Windows doesn't really care which one you use, but Linux is very particular.

#### Configuring Git
Add this to your `.gitconfig.`
```
[core]
	autocrlf = false
```
#### Configuring Visual Studio Code
Add this line to your `settings.json`
```json
"file.eol": "\n",
```

## Requirements
My current dev system is a MacBook Pro, but I do sometimes use Windows 10 as well, so you have the option of using either **Hyper-V** or **Virtualbox**.
### Building

#### Hyper-V
```
packer build -only=hyperv-iso centos75.json
```
#### VirtualBox
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

* Vagrant will initially bootstrap the guest using the built-in insecure Vagrant key
* The file provisioner transfers my private key from the host to the VM
* Use the file provisioner again to overwrite the `authorized_keys` file in the guest with the contents of my public key from the host, making the insecure Vagrant key unusable.
* Since the `config.ssh.private_key_path` in my Vagrant file provides an array of keys, the next time you run `vagrant up` it will use the first one that works, which happens to be the private key from my host, the one I transfered to the VM earlier.
