class dotheneedful (
  Array $applications,
  Array $terraform_versions,
  Array $ohmyzsh_plugin_repos
){

  $classes = [
    'dotheneedful::repos',
    'dotheneedful::apps',
    'dotheneedful::terraform_setup',
    'dotheneedful::powershell_modules',
    'dotheneedful::ssh',
    'dotheneedful::ohmyzsh',
    'dotheneedful::pip_packages',
    'dotheneedful::vbox_guestadditions'
  ]

  include $classes

}
