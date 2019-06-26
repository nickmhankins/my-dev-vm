# CentOS Dev VM
Using Make to create a versioned, repeatable Dev VM with Packer and Vagrant. Local versioned Vagrant boxes created using Python.

## Requirements
* Packer
* Vagrant
* Make
* Python3
* Virtualbox

# Building
**Packer Build File steps:**

1. **Base image** 
   - Download the Centos 7.5 ISO, apply updates, create users, install Puppet
2. **Applications** 
   - Install all applications defined in the Hiera with Puppet, cleanup the OS
3. **Vagrant**
   - Export the Vagrant box
  
## Make
The Packer build files are split into 3 parts and chained together to allow for quicker iteration if you just want to add new applications or create a fresh Vagrant box instead of having to redownload and update the entire VM base image.

Vagrant boxes will either be added or updated depending on whether or not you choose to destroy existing resoures - because of this, manipulating this Vagrant box outside of this Makefile may cause problems.

Arguments in brackets are optional
#### From scratch, optionally destroy existing resources
```
make fresh_build [DESTROY_ALL=true] [VERBOSE=true]
```

#### Using existing base image, rebuild just applications and export new Vagrant box
```
make application_refresh [VERBOSE=true]
```

#### Use existing application image, and export new Vagrant box
```
make box_refresh [VERBOSE=true]
```

### Options
* **DESTROY_ALL** - Set TRUE in `fresh_build` step to enable.  Removes all Packer builds, Vagrant boxes, and their metadata.  Subsequent fresh builds will run `vagrant box add`, otherwise `vagrant box update` will be used.
* **VERBOSE** - Set TRUE to show all output from Packer and Vagrant.

## Vagrant
### "Local" Vagrant Cloud
Every time Make exports a new Vagrant box, the `metadata.py ` script will run using information from the build to update the `build/metadata.json` file. This is used to allow versioning of your Vagrant boxes, something that is typically only available if you use Hashicorp Atlas.

Everytime you run Vagrant up, it will check the metadata file to get the path to the box, see if there is a new version, and compare hashes.  

If you want to pin to a specific box version, uncomment the config value `vm.box_version` in the Vagrantfile and add the version you want

The only command you _should_ need to use outside of Make to bring up your box is:
```
vagrant up
```
or
```
vagrant destroy
```

After Make exports your new or updated box, you will need to `vagrant destroy` your current box, then `vagrant up` again.

### Assumptions:
* You have a .gitconfig in your home directory
* You have a public and private keypair (id_rsa, id_rsa.pub) in your home/.ssh directory
You may need to edit the Vagrantfile to reflect your setup, such as your private key name, etc.

### SSH Key steps in the Vagrantfile
The Vagrantfile uses the SSH keypair from my host and simultaneously invalidates the public Vagrant key using the following steps:

* Vagrant will initially bootstrap the guest using the built-in insecure Vagrant key
* The file provisioner transfers my private key from the host to the VM
* The file provisioner then overwrites the `authorized_keys` file in the guest with the contents of my public key from the host, making the insecure Vagrant key unusable.
* Since the `config.ssh.private_key_path` in my Vagrant file provides an array of keys, the next time you run `vagrant up` it will use the first one that works, which happens to be the private key from my host.
