sudo rpm -Uvh http://yum.puppet.com/puppet5-release-el-7.noarch.rpm  # add puppet repos
sudo yum -y install puppet-agent
export PATH=$PATH:/opt/puppetlabs/bin/