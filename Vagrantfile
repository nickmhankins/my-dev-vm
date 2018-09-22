
Vagrant.configure(2) do |config|  
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'
  config.ssh.keys_only = false
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.define "virtualbox" do |virtualbox|

    virtualbox.vm.box = "build/centos75.box"

    config.vm.provider "virtualbox" do |vb|

      vb.customize ["modifyvm", :id, "--vram", 256]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]

      vb.gui = true
      vb.cpus = 4
      vb.memory = "4096"
      
    end
  end
end