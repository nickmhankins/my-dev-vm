
Vagrant.configure(2) do |config|
  config.ssh.username = 'vagrant'
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  config.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]

  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
  config.vm.provision "file", source: "~/.gitconfig", destination: "~/.gitconfig"

  # things that need to be run as root
  config.vm.provision "shell", privileged: true do |s|
    s.inline = <<-SHELL
      # key stuff
      chmod 600 /home/vagrant/.ssh/id_rsa
      sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
      sudo systemctl restart sshd
      echo "Host *.company.com\n\tIdentityFile ~/.ssh/id_rsa\n" > /home/vagrant/.ssh/config
      eval `ssh-agent -s`
      ssh-add "/home/vagrant/.ssh/id_rsa"

      # git stuff
      echo .DS_Store >> /home/vagrant/.gitignore_global
      git config --global core.excludesfile /home/vagrant/.gitignore_global
      git config --global push.default simple
    SHELL
  end
  
  # things that need to be run as user
  config.vm.provision "shell", privileged: false do |s|
    s.inline = <<-SHELL
      # zsh things
      sudo chsh -s $(which zsh) vagrant
      curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
    SHELL
  end

  config.vm.provision "file", source: "scripts/zsh/.zshrc", destination: "~/.zshrc"
  
  config.vm.synced_folder "../", "/git", type: "virtualbox"

  config.vm.define "virtualbox" do |virtualbox|
    virtualbox.vm.box = "build/metadata.json"
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.cpus = 4
      vb.memory = "4096"
    end
  end
end