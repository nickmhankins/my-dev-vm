#!/bin/bash
yum install -y centos-release-scl
yum install -y rh-python36
scl enable rh-python36 bash
yum groupinstall -y 'Development Tools'