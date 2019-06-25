class dotheneedful::ohmyzsh {

  $user = 'vagrant'
  $base_uri = 'https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master'
  $installsource = "${base_uri}/tools/install.sh"

  exec { 'install_ohmyzsh':
    command => "/usr/bin/curl -fsSL ${installsource} | /usr/bin/bash",
    user    => $user
  }

  file { "/home/${user}/.zshrc":
    ensure => 'file',
    source => 'puppet:///modules/dotheneedful/.zshrc',
    mode   => '0600',
    owner  => 'vagrant'
  }

  user { $user:
    shell  => '/bin/zsh'
  }

}
