#
# = Class: kibana::install
#
# This class installs kibana
#
class kibana::install {

  case $kibana::install {

    package: {

      if $kibana::package {
        package { $kibana::package:
          ensure   => $kibana::managed_package_ensure,
          provider => $kibana::package_provider,
        }
      }
    }

    upstream: {

      if $kibana::user_create == true {
        require kibana::user
      }
      # TODO: Use another define
      puppi::netinstall { 'netinstall_kibana':
        url                 => $kibana::managed_install_source,
        destination_dir     => $kibana::install_destination,
        owner               => $kibana::user,
        group               => $kibana::user,
      }

      file { 'kibana_link':
        ensure => "${kibana::home_dir}" ,
        path   => "${kibana::install_destination}/kibana",
      }
    }

    puppi: {

      if $kibana::bool_create_user == true {
        require kibana::user
      }

      puppi::project::archive { 'kibana':
        source      => $kibana::managed_install_source,
        deploy_root => $kibana::install_destination,
        user        => $kibana::user,
        auto_deploy => true,
        enable      => true,
      }

      file { 'kibana_link':
        ensure => "${kibana::home_dir}" ,
        path   => "${kibana::install_destination}/kibana",
      }
    }

    default: { }

  }

}
