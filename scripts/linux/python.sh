#!/bin/bash
yum install -y yum-utils
yum groupinstall -y 'Development Tools'
yum install -y https://centos7.iuscommunity.org/ius-release.rpm
yum install -y python36u
python3.6 -V