# Class: kibana::params
#
# Defines all the variables used in the module.
#
class kibana::params {

  $install_base_url = 'https://github.com/elasticsearch/kibana/archive'

  $package = 'kibana'

  $file = '/etc/kibana/config.js'

  $file_mode = '0664'

  $file_owner = 'root'

  $file_group = 'root'

}
