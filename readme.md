# CentOS Dev VM
Using Make to create a versioned, repeatable Dev VM with Packer and Vagrant. Local versioned Vagrant boxes created using Python.

**To Do**:
Add Vagrant commands to Makefile and update readme on use.

## Requirements
* Packer
* Vagrant
* Make
* Python3
* Virtualbox

# Building

## Packer
The Packer definition files are split into 3 parts and chained together to speed up iteration and testing if you just want to add new applications or create a fresh Vagrant box instead of having to redownload and update the entire VM.

**Packer Build Steps:**

1. **Base image** 
   - Download the Centos 7.5 ISO, apply updates, create users, install Puppet
2. **Applications** 
   - Install all applications defined in the Hiera with Puppet, cleanup the OS
3. **Vagrant**
   - Export the Vagrant box

#### From scratch
```
make fresh_build
```

#### Using existing base image, rebuild just applications and export new Vagrant box
```
make application_refresh
```

#### Use existing application image, and export new Vagrant box
```
make box_refresh
```
## Vagrant
### "Local" Vagrant Cloud
Every time Make exports a new Vagrant box, the `metadata.py ` script will run using information from the build to update the `build/metadata.json` file. This is used to allow versioning of your Vagrant boxes, something that is typically only available if you use Hashicorp Atlas.

Everytime you run Vagrant up, it will check the metadata file to get the path to the box, see if there is a new version, and compare hashes.  

If you want to pin to a specific box version, uncomment the config value `vm.box_version` in the Vagrantfile and add the version you want

### Assumptions:
* You have a .gitconfig in your home directory
* You have a public and private keypair (id_rsa, id_rsa.pub) in your home/.ssh directory

Packer will export the VM you create as a Vagrant box in the build directory, which you can start with:
```
vagrant up
```

You may need to edit the Vagrantfile to reflect your setup, such as your private key name, etc.

#### SSH Keys
The Vagrantfile uses the SSH keypair from my host and simultaenously invalidate the public Vagrant using the following steps:

* Vagrant will initially bootstrap the guest using the built-in insecure Vagrant key
* The file provisioner transfers my private key from the host to the VM
* The file provisioner then overwrites the `authorized_keys` file in the guest with the contents of my public key from the host, making the insecure Vagrant key unusable.
* Since the `config.ssh.private_key_path` in my Vagrant file provides an array of keys, the next time you run `vagrant up` it will use the first one that works, which happens to be the private key from my host.
