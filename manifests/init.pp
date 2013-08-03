#
# = Class: kibana
#
# This class installs and manages kibana
#
#
# == Parameters
#
# Refer to the official documentation for standard parameters usage.
# Look at the code for the list of supported parametes and their defaults.
#
class kibana (

  $ensure              = 'present',
  $version             = undef,
  $audit               = undef,
  $noop                = undef,

  $install             = 'package',
  $install_base_url    = $kibana::params::install_base_url,
  $install_source      = undef,
  $install_destination = '/opt',

  $user                = 'kibana',
  $user_create         = true,
  $user_uid            = undef,
  $user_gid            = undef,
  $user_groups         = undef,

  $java_heap_size      = '1024',

  $package             = $kibana::params::package,
  $package_provider    = undef,

  $service             = $kibana::params::service,
  $service_ensure      = 'running',
  $service_enable      = true,
  $service_subscribe   = $kibana::params::service_subscribe,
  $service_provider    = undef,

  $init_script_file           = '/etc/init.d/kibana',
  $init_script_file_template  = 'kibana/init.erb',
  $init_options_file          = $kibana::params::init_options_file,
  $init_options_file_template = 'kibana/init_options.erb',

  $file                = $kibana::params::file,
  $file_owner          = $kibana::params::file_owner,
  $file_group          = $kibana::params::file_group,
  $file_mode           = $kibana::params::file_mode,
  $file_replace        = $kibana::params::file_replace,
  $file_source         = undef,
  $file_template       = undef,
  $file_content        = undef,
  $file_options_hash   = undef,

  $dir                 = $kibana::params::dir,
  $dir_source          = undef,
  $dir_purge           = false,
  $dir_recurse         = true,

  $dependency_class    = 'kibana::dependency',
  $monitor_class       = 'kibana::monitor',
  $firewall_class      = 'kibana::firewall',
  $my_class            = undef,

  $monitor             = false,
  $monitor_host        = $::ipaddress,
  $monitor_port        = 9200,
  $monitor_protocol    = tcp,
  $monitor_tool        = '',

  $firewall            = false,
  $firewall_src        = '0/0',
  $firewall_dst        = '0/0',
  $firewall_port       = 9200,
  $firewall_protocol   = tcp

  ) inherits kibana::params {


  # Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent all the resources managed by the module are removed.')
  validate_re($install, ['package','upstream'], 'Valid values are: package, upstream.')
  validate_bool($service_enable)
  validate_bool($dir_recurse)
  validate_bool($dir_purge)
  if $file_options_hash { validate_hash($file_options_hash) }

  # Calculation of variables used in the module
  if $file_content {
    $managed_file_content = $file_content
  } else {
    if $file_template {
      $managed_file_content = template($file_template)
    } else {
      $managed_file_content = undef
    }
  }

  if $version {
    $managed_package_ensure = $version
  } else {
    $managed_package_ensure = $ensure
  }

  if $ensure == 'absent' {
    $managed_service_enable = undef
    $managed_service_ensure = stopped
    $dir_ensure = absent
    $file_ensure = absent
  } else {
    $managed_service_enable = $service_enable
    $managed_service_ensure = $service_ensure
    $dir_ensure = directory
    $file_ensure = present
  }

  $managed_install_source = $kibana::install_source ? {
    ''      => "${kibana::install_base_url}/kibana-${kibana::version}.zip",
    default => $kibana::install_source,
  }

  $created_dir = url_parse($managed_install_source,'filedir')
  $home_dir = "${kibana::install_destination}/${kibana::created_dir}"

  $managed_file = $kibana::install ? {
    package => $kibana::file,
    default => "${kibana::home_dir}/config/kibana.yml",
  }

  $managed_dir = $kibana::dir ? {
    ''      => $kibana::install ? {
      package => $kibana::dir,
      default => "${kibana::home_dir}/config/",
    },
    default => $kibana::dir,
  }

  $managed_service_provider = $install ? {
    /(?i:upstream|puppi)/ => 'init',
    default               => undef,
  }

  # Resources Managed
  class { 'kibana::install':
  }

  class { 'kibana::service':
    require => Class['kibana::install'],
  }

  class { 'kibana::config':
    require => Class['kibana::install'],
  }


  # Extra classes
  if $kibana::dependency_class {
    include $kibana::dependency_class
  }

  if $kibana::monitor and $kibana::monitor_class {
    include $kibana::monitor_class
  }

  if $kibana::firewall and $kibana::firewall_class {
    include $kibana::firewall_class
  }

  if $kibana::my_class {
    include $kibana::my_class
  }

}
