
Vagrant.configure(2) do |config|
  config.ssh.username = 'vagrant'
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.ssh.private_key_path = ["~/.ssh/key", "~/.vagrant.d/insecure_private_key"]

  config.vm.provision "file", source: "~/.ssh/key", destination: "~/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/key.pub", destination: "~/.ssh/authorized_keys"
  config.vm.provision "file", source: "~/.gitconfig", destination: "~/.gitconfig"

  config.vm.provision "shell" do |s|
    s.inline = <<-SHELL
      chmod 600 /home/vagrant/.ssh/id_rsa
      sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
      sudo systemctl restart sshd
      echo "Host github.com\n\tIdentityFile ~/.ssh/id_rsa" >> /home/vagrant/.ssh/config
    SHELL
  end
  
  config.vm.synced_folder "../", "/git", type: "virtualbox"

  config.vm.define "virtualbox" do |virtualbox|
    virtualbox.vm.box = "build/virtualbox/centos75.box"

    config.vm.provider "virtualbox" do |vb|

      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.cpus = 4
      vb.memory = "4096"
      
    end
  end
end