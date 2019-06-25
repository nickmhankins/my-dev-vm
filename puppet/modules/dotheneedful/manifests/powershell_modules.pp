  class dotheneedful::powershell_modules {

  $modules = lookup(dotheneedful::powershell_modules, Hash, deep, {})

  $modules.each | String $module, Hash $properties | {
    exec { 'pwsh_modules':
      command => "/usr/bin/pwsh -command '& {Set-PSRepository PSGallery -InstallationPolicy Trusted; Install-Module ${module} -RequiredVersion ${properties['version']} -Scope CurrentUser}'",
      user    => 'vagrant'
    }
  }
}
