class dotheneedful::pip_packages {

$pips = lookup(dotheneedful::pip_packages, Hash, deep, {})

$python_version = '3.6'

exec {'pip3_install':
  command => "/usr/bin/easy_install-${python_version} pip"
}

$pips.each | String $name, Hash $properties | {
    exec {"${name}_install":
      command => "/usr/bin/easy_install-${python_version} ${name}==${properties['version']}"
    }
  }

}
