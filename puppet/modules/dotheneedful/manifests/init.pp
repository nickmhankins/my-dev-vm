class dotheneedful (
  Array $applications,
  Array $terraform_versions,
  Array $ohmyzsh_plugin_repos
){
  include dotheneedful::repos
  include dotheneedful::apps
  include dotheneedful::terraform_setup
  include dotheneedful::powershell_modules
  include dotheneedful::ssh
  include dotheneedful::ohmyzsh
  include dotheneedful::pip_packages
  include dotheneedful::vbox_guestadditions
}
