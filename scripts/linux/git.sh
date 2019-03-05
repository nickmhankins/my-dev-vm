#!/bin/bash

yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum -y install gcc perl-ExtUtils-MakeMaker
cd /usr/src
wget https://www.kernel.org/pub/software/scm/git/git-2.19.0.tar.gz
tar xzf git-2.19.0.tar.gz
cd git-2.19.0
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=/usr/local/git/bin:$PATH" >> /etc/bashrc
source /etc/bashrc
git --version

git clone https://github.com/magicmonty/bash-git-prompt.git /usr/bin/.bash-git-prompt --depth=1
printf "GIT_PROMPT_ONLY_IN_REPO=1\nsource /usr/bin/.bash-git-prompt/gitprompt.sh\n" >> /etc/bashrc