# Class: kibana::params
#
# Defines all the variables used in the module.
#
class kibana::params {

  $install_base_url = 'https://download.kibana.org/kibana/kibana/'

  $package = 'kibana'

  $service = 'kibana'

  $service_subscribe = Class['kibana::config']

  $file = $::osfamily ? {
    default => '/etc/kibana/kibana.yml',
  }

  $init_options_file = $::osfamily ? {
    Debian  => '/etc/default/kibana',
    default => '/etc/sysconfig/kibana',
  }

  $file_mode = '0644'

  $file_owner = 'root'

  $file_group = 'root'

  $dir = $::osfamily ? {
    default => '/etc/kibana/',
  }

}
