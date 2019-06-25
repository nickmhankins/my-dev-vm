class dotheneedful::terraform_setup {
  $version = $dotheneedful::terraform_version
  $base_uri = "https://releases.hashicorp.com/terraform/${version}/"
  $filename = "terraform_${version}_linux_amd64.zip"
  $full_uri = "${base_uri}${filename}"
  file {"/tmp/${filename}":
    ensure => 'present',
    source => $full_uri
  }
  exec { 'extract_tf_zip':
    command => "/usr/bin/unzip /tmp/${filename} -d /usr/local/bin"
  }
  exec { 'add_tf_path':
    command => '/usr/bin/echo "export PATH=$PATH:/usr/local/bin" >> /etc/bashrc'
  }
}
