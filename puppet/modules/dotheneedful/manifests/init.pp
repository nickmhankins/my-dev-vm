class dotheneedful (
  Array $applications,
  String $terraform_version
){
  include dotheneedful::repos
  include dotheneedful::apps
  include dotheneedful::powershell_modules
  #include dotheneedful::pip_packages
  include dotheneedful::terraform_setup
  include dotheneedful::ssh
  include dotheneedful::ohmyzsh
  include dotheneedful::vbox_guestadditions
}
