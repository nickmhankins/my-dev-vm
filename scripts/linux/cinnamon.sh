#!/bin/bash
sudo yum install epel-release -y
sudo yum -y install epel-release
sudo yum -y groupinstall "X Window system"
sudo yum -y install lightdm
sudo systemctl enable lightdm.service
sudo yum -y install libnm-gtk
sudo yum -y install gtk-murrine-engine
sudo yum -y install cinnamon
sudo yum -y install curl cabextract xorg-x11-font-utils fontconfig
sudo yum -y install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
sudo yum -y install gnome-system-monitor
sudo yum -y install gnome-terminal
sudo yum -y install gedit
sudo yum -y install firefox
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo yum -y install sublime-text
sudo systemctl set-default graphical.target
sudo reboot