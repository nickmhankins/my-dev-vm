class dotheneedful::repos {
  $yum_repos = lookup(dotheneedful::repositories_yum, Hash, deep, {})
  $rpm_repos = lookup(dotheneedful::repositories_rpm, Hash, deep, {})

  $yum_defaults = {
    enabled => 1,
    gpgcheck => 0,
  }
  $rpm_defaults = {
    provider => 'rpm'
  }

  create_resources(yumrepo, $yum_repos, $yum_defaults)
  create_resources(package, $rpm_repos, $rpm_defaults)
}
