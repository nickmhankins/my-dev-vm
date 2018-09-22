#!/bin/bash
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install xrdp tigervnc-server
systemctl enable xrdp
chkconfig xrdp
firewall-cmd --permanent --add-port=3389/tcp
firewall-cmd --reload