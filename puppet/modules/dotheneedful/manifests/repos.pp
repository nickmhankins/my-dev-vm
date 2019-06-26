class dotheneedful::repos {
  $yum_defaults = {
    enabled => 1,
    gpgcheck => 0,
  }
  $rpm_defaults = {
    provider => 'rpm'
  }

  $repos = lookup(dotheneedful::repositories, Hash, deep, {})
  $rpm_source = $repos.filter | $keys, $values | { source in $values }
  $yum_source = $repos.filter | $keys, $values | { baseurl in $values }

  create_resources(yumrepo, $yum_source, $yum_defaults)
  create_resources(package, $rpm_source, $rpm_defaults)
}
