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

      puppi::netinstall { 'netinstall_kibana':
        url                 => $kibana::managed_install_url,
        destination_dir     => $kibana::install_destination,
        extracted_dir       => $kibana::extracted_dir,
        retrieve_command    => "wget -O ${kibana::download_file_name}",
      }

      file { 'kibana_link':
        ensure => "${kibana::home_dir}" ,
        path   => "${kibana::install_destination}/kibana",
      }
    }

    puppi: {

      puppi::project::archive { 'kibana':
        source      => $kibana::managed_install_url,
        deploy_root => $kibana::install_destination,
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
