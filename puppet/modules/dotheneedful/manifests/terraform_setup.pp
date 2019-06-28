class dotheneedful::terraform_setup {
  $versions = $dotheneedful::terraform_versions
  $user = 'vagrant'
  $install_path = "/home/${user}/.tfenv"

  file { $install_path :
    ensure => 'directory',
    mode   => '0755',
    owner  => $user,
    group  => $user
  }

  -> exec { 'clone_tfenv':
    command => "/usr/bin/git clone https://github.com/tfutils/tfenv.git ${install_path}",
    user    => $user
  }

  -> file { "${install_path}/.git":
    ensure => absent,
    force  => true
  }

  file { '/usr/local/bin/tfenv':
    ensure => link,
    target => "${install_path}/bin/tfenv",
  }

  file { '/usr/local/bin/terraform':
    ensure => link,
    target => "${install_path}/bin/terraform",
  }

  $versions.each | String $version | {
    exec { "install_terraform_${version}":
      command => "tfenv install ${version}",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      user    => $user,
      require => [ File['/usr/local/bin/terraform'], File['/usr/local/bin/tfenv'] ]
    }
  }

}
