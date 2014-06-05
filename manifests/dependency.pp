# Class: kibana::dependency
#
# This class installs kibana dependency
#
# == Usage
#
# This class may contain resources available on the
# Example42 modules set.
#
class kibana::dependency {

  if ! defined(Package['unzip']) {
    package { 'unzip' :
      ensure => present,
      before => Class['kibana::install'],
    }
  }

  if $kibana::webserver {
    include $kibana::webserver
  }

  if $kibana::webserver == 'apache'
  and $kibana::virtualhost {
    apache::vhost { $kibana::virtualhost:
      docroot  => $kibana::home_dir,
    }
  }

}
