#
# = Class: kibana
#
# This class installs and manages kibana
#
#
# == Parameters
#
# [*elasticsearch_url*]
#   String. Default: http://"+window.location.hostname+":9200
#   Url of your elasticsearch server.
#   Example: http://es.${::domain}:9200
#
# [*virtualhost*]
#   String. Default: kibana.${::domain}
#   Name of the virtualhost for the kibana web interface
#   Set to undef to disable the creation of a virtualhost
#
# [*webserver*]
#   String. Default: apache
#   Name of the webserver that provides the kibana files.
#   Note that the relevant $webserver class is included
#   Set to undef to disable the inclusion of the $webserver module.
#
# Refer to the official documentation for standard parameters usage.
# Look at the code for the list of supported parametes and their defaults.
#
class kibana (

  $elasticsearch_url   = 'http://"+window.location.hostname+":9200',
  $virtualhost         = "kibana.${::domain}",
  $webserver           = undef,

  $ensure              = 'present',
  $version             = '3.0.1',

  $install             = 'upstream',
  $install_base_url    = 'http://download.elasticsearch.org/kibana/kibana',
  $install_url         = undef,
  $install_destination = '/opt',
  $install_exec_env    = [],

  $package_name        = 'kibana',

  $file                = '/etc/kibana/config.js',
  $file_source         = undef,
  $file_template       = undef,
  $file_content        = undef,
  $file_options_hash   = undef,
  $file_mode           = '0664',
  $file_owner          = 'root',
  $file_group          = 'root',

  $dependency_class    = 'kibana::dependency',
  $my_class            = undef,

  ) {


  # Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent all the resources managed by the module are removed.')
  validate_re($install, ['package','upstream','puppi'], 'Valid values are: package, upstream, puppi.')
  if $file_options_hash { validate_hash($file_options_hash) }

  # Calculation of variables used in the module
  if $file_content {
    $managed_file_content = $file_content
  } else {
    if $file_template {
      $managed_file_content = template($file_template)
    } else {
      $managed_file_content = undef
    }
  }

  $managed_package_ensure = $version ? {
    'master' => $ensure,
    undef    => $ensure,
    default  => $version,
  }

  if $kibana::install_url {
    $managed_install_url = $kibana::install_url
    $download_file_name = url_parse($kibana::install_url,'filename')
    $extracted_dir = url_parse($download_file_name, 'filedir')
  } else {
    $managed_install_url = "${kibana::install_base_url}/kibana-${kibana::version}.zip"
    $download_file_name = "kibana-${kibana::version}.zip"
    $extracted_dir = "kibana-${kibana::version}"
  }

  $home_dir = "${kibana::install_destination}/${kibana::extracted_dir}"

  $managed_file = $kibana::install ? {
    package => $kibana::file,
    default => "${kibana::home_dir}/config.js",
  }

  # Resources Managed
  class { 'kibana::install':
  }

  class { 'kibana::config':
    require => Class['kibana::install'],
  }


  # Extra classes
  if $kibana::dependency_class {
    include $kibana::dependency_class
  }

  if $kibana::my_class {
    include $kibana::my_class
  }

}
