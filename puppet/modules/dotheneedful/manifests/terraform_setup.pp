class dotheneedful::terraform_setup {
  $versions = $dotheneedful::terraform_versions
  $user = 'vagrant'
  $install_path = "/home/${user}/.tfenv"

  exec { 'clone_tfenv':
    command => "/usr/bin/git clone https://github.com/tfutils/tfenv.git ${install_path}"
  }

  file { "${install_path}/.git":
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
    }
  }

}
