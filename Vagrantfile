
Vagrant.configure(2) do |config|
  config.ssh.username = 'vagrant'
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]

  config.vm.provision "file", source: "~/.ssh/.", destination: "~/.ssh/"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
  config.vm.provision "file", source: "~/.gitconfig", destination: "~/.gitconfig"
  config.vm.provision "file", source: "~/.gitignore_global", destination: "~/.gitignore_global"
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 3080, host: 3080

  config.vm.provision "shell", privileged: true do |s|
    s.inline = <<-SHELL
      chmod 0600 /home/vagrant/.ssh/id_rsa
    SHELL
  end
  
  config.vm.synced_folder "../", "/git", type: "virtualbox"

  config.vm.define "virtualbox" do |virtualbox|
    virtualbox.vm.box = "dev_vm"
    virtualbox.vm.box_url = "file://build/metadata.json"
    #virtualbox.vm.box_version = ""
    virtualbox.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.cpus = 4
      vb.memory = "4096"
    end
  end
end