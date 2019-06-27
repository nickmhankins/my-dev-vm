class dotheneedful::ssh {
  file {'/home/vagrant/.ssh':
    ensure => 'directory',
    mode   => '0700',
    owner  => 'vagrant'
  }
  file {'/home/vagrant/.ssh/authorized_keys':
    ensure => 'file',
    source => 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub',
    mode   => '0600',
    owner  => 'vagrant'
  }
}
