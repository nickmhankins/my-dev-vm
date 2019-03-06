#!/bin/bash
yum install -y yum-utils
yum groupinstall -y 'Development Tools'
yum install -y https://centos7.iuscommunity.org/ius-release.rpm
yum install -y python36u python36u-pip python36u-libs python36u-devel python-pip
alias python="python3.6" 
alias pip="pip3.6"
#pip install azure