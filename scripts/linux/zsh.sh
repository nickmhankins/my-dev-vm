#!/bin/bash
yum -y install zsh
sed -i '2i\auth sufficient  pam_wheel.so trust group=wheel\' /etc/pam.d/chsh