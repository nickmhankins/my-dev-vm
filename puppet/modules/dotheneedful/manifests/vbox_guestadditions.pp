class dotheneedful::vbox_guestadditions {

  $user = 'vagrant'
  $vbox_version_path = "/home/${user}/.vbox_version"
  $vbox_version_content = file($vbox_version_path)
  $isopath = "/home/${user}/VBoxGuestAdditions_${vbox_version_content}.iso"

  $prereqs = ['gcc', 'make', 'bzip2', 'kernel-headers', 'kernel-devel']
  package { $prereqs:
    ensure => 'installed'
  }
  -> file {'/tmp/virtualbox':
    ensure  => 'directory'
  }
  -> exec {'mount_iso':
    command => "/bin/mount -o loop ${isopath} /tmp/virtualbox"
  }
  -> exec {'install_guest_additions':
    command => '/usr/bin/sh /tmp/virtualbox/VBoxLinuxAdditions.run'
  }
  -> exec {'unmount_iso':
    command => '/bin/umount /tmp/virtualbox'
  }
  -> exec {'cleanup':
    command => '/bin/rm -rf /tmp/virtualbox'
  }
  -> file {$isopath:
    ensure => absent,
  }
  -> file {$vbox_version_path:
    ensure => absent,
  }
}
