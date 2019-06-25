class dotheneedful::pip_packages {

$pips = lookup(dotheneedful::pip_packages, Hash, deep, {})

#   $pips.each | String $name, Hash $properties | {
#     package { $name:
#       ensure => $properties['version'],
#       source => 'pip3',
#     }
#   }
# }

$defaults = {
  provider => 'pip3'
}

create_resources(package, $pips, $defaults)
